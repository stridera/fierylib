"""
Trigger Parser - Parses legacy DG Script trigger files (.trg)

Handles the CircleMUD/FieryMUD DG Script format:
- #VNUM header
- Name~
- type flags probability
- args~
- script body~
"""

import re
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Optional


class ScriptType(Enum):
    """DG Script type - matches Prisma ScriptType enum"""
    MOB = 0
    OBJECT = 1
    WORLD = 2


# DG Script trigger flags - TYPE-SPECIFIC mappings
# Flag letters map to bit positions (a=0, b=1, etc.) and meanings differ by type
# Based on FieryMUD dg_scripts.hpp definitions

# MOB trigger flags (trig_types in dg_scripts.hpp lines 30-49)
MOB_TRIGGER_FLAGS = {
    'a': 'GLOBAL',      # bit 0 - check even if zone empty
    'b': 'RANDOM',      # bit 1 - checked randomly
    'c': 'COMMAND',     # bit 2 - character types a command
    'd': 'SPEECH',      # bit 3 - a char says a word/phrase
    'e': 'ACT',         # bit 4 - word or phrase sent to act
    'f': 'DEATH',       # bit 5 - character dies
    'g': 'GREET',       # bit 6 - something enters room seen
    'h': 'GREET_ALL',   # bit 7 - anything enters room
    'i': 'ENTRY',       # bit 8 - the mob enters a room
    'j': 'RECEIVE',     # bit 9 - character is given obj
    'k': 'FIGHT',       # bit 10 - each pulse while fighting
    'l': 'HIT_PERCENT', # bit 11 - fighting and below some hp
    'm': 'BRIBE',       # bit 12 - coins are given to mob
    'n': 'SPEECH_TO',   # bit 13 - ask/whisper/tell
    'o': 'LOAD',        # bit 14 - the mob is loaded
    'p': 'CAST',        # bit 15 - mob is target of cast
    'q': 'LEAVE',       # bit 16 - someone leaves room seen
    'r': 'DOOR',        # bit 17 - door manipulated in room
    's': 'LOOK',        # bit 18 - the mob is looked at
    't': 'TIME',        # bit 19 - trigger based on game hour
}

# OBJECT trigger flags (otrig_types in dg_scripts.hpp lines 52-70)
OBJ_TRIGGER_FLAGS = {
    'a': 'GLOBAL',      # bit 0 - unused
    'b': 'RANDOM',      # bit 1 - checked randomly
    'c': 'COMMAND',     # bit 2 - character types a command
    'd': 'ATTACK',      # bit 3 - trigger for weapons on attack
    'e': 'DEFEND',      # bit 4 - trigger for weapons on defense
    'f': 'TIMER',       # bit 5 - item's timer expires
    'g': 'GET',         # bit 6 - item is picked up
    'h': 'DROP',        # bit 7 - character tries to drop obj
    'i': 'GIVE',        # bit 8 - character tries to give obj
    'j': 'WEAR',        # bit 9 - character tries to wear obj
    'k': 'DEATH',       # bit 10 - character dies
    'l': 'REMOVE',      # bit 11 - character tries to remove obj
    'm': 'LOOK',        # bit 12 - object is looked at
    'n': 'USE',         # bit 13 - object is used
    'o': 'LOAD',        # bit 14 - the object is loaded
    'p': 'CAST',        # bit 15 - object targeted by spell
    'q': 'LEAVE',       # bit 16 - someone leaves room seen
    # bit 17 unused
    's': 'CONSUME',     # bit 18 - char tries to eat/drink obj
    't': 'TIME',        # bit 19 - trigger based on game hour
}

# WORLD trigger flags (wtrig_types in dg_scripts.hpp lines 73-84)
WLD_TRIGGER_FLAGS = {
    'a': 'GLOBAL',      # bit 0 - check even if zone empty
    'b': 'RANDOM',      # bit 1 - checked randomly
    'c': 'COMMAND',     # bit 2 - character types a command
    'd': 'SPEECH',      # bit 3 - a char says word/phrase
    # bit 4 unused
    'f': 'RESET',       # bit 5 - zone has been reset
    'g': 'PREENTRY',    # bit 6 - someone is about to enter
    'h': 'DROP',        # bit 7 - something dropped in room
    'i': 'POSTENTRY',   # bit 8 - someone has just entered
    # bits 9-14 unused
    'p': 'CAST',        # bit 15 - spell cast in room
    'q': 'LEAVE',       # bit 16 - character leaves the room
    'r': 'DOOR',        # bit 17 - door manipulated in room
    # bit 18 unused
    't': 'TIME',        # bit 19 - trigger based on game hour
}

# Legacy fallback for backward compatibility (same as MOB flags)
TRIGGER_FLAGS = MOB_TRIGGER_FLAGS


@dataclass
class DGTrigger:
    """Parsed DG Script trigger data"""
    vnum: int
    name: str
    script_type: ScriptType
    flags: list[str]
    probability: int
    arg_string: str
    commands: str
    numeric_arg: int = 0

    @property
    def zone_id(self) -> int:
        """Extract zone ID from VNUM (e.g., 3045 -> 30)"""
        return self.vnum // 100

    @property
    def local_id(self) -> int:
        """Extract local ID from VNUM (e.g., 3045 -> 45)"""
        return self.vnum % 100


def parse_trigger_file(filepath: Path) -> list[DGTrigger]:
    """
    Parse a DG Script trigger file and return list of triggers.

    Args:
        filepath: Path to .trg file

    Returns:
        List of DGTrigger objects

    Examples:
        >>> triggers = parse_trigger_file(Path("lib/world/trg/30.trg"))
        >>> for t in triggers:
        ...     print(f"Trigger {t.vnum}: {t.name}")
    """
    triggers = []
    content = filepath.read_text(encoding='latin-1')

    # Split by trigger headers (#VNUM)
    trigger_pattern = re.compile(r'^#(\d+)\s*$', re.MULTILINE)
    parts = trigger_pattern.split(content)

    i = 1
    while i < len(parts) - 1:
        vnum = int(parts[i])
        trigger_content = parts[i + 1]
        i += 2

        # Skip empty or terminator triggers
        if vnum == 0 or trigger_content.strip() == '$~':
            continue

        trigger = parse_single_trigger(vnum, trigger_content)
        if trigger:
            triggers.append(trigger)

    return triggers


def parse_single_trigger(vnum: int, content: str) -> Optional[DGTrigger]:
    """
    Parse a single trigger from its content.

    Args:
        vnum: Trigger VNUM
        content: Raw trigger content (after #VNUM line)

    Returns:
        DGTrigger object or None if parsing fails
    """
    lines = content.strip().split('\n')
    if len(lines) < 3:
        return None

    # Line 0: Name~
    name_line = lines[0]
    if not name_line.endswith('~'):
        return None
    name = name_line[:-1].strip()

    # Line 1: type flags probability
    header_line = lines[1].strip()
    header_match = re.match(r'^(\d+)\s+([a-zA-Z]+)\s+(\d+)', header_line)
    if not header_match:
        return None

    type_num = int(header_match.group(1))
    flag_chars = header_match.group(2).lower()
    probability = int(header_match.group(3))

    # Map type number to ScriptType
    script_type = ScriptType(type_num) if type_num in [0, 1, 2] else ScriptType.MOB

    # Select the appropriate flag mapping based on script type
    if script_type == ScriptType.MOB:
        flag_mapping = MOB_TRIGGER_FLAGS
    elif script_type == ScriptType.OBJECT:
        flag_mapping = OBJ_TRIGGER_FLAGS
    elif script_type == ScriptType.WORLD:
        flag_mapping = WLD_TRIGGER_FLAGS
    else:
        flag_mapping = MOB_TRIGGER_FLAGS  # fallback

    # Parse trigger flags using type-specific mapping
    flags = []
    for char in flag_chars:
        if char in flag_mapping:
            flag = flag_mapping[char]
            if flag not in flags:
                flags.append(flag)

    # Line 2: args~ (optional)
    arg_string = ""
    cmd_start = 2
    if lines[2].endswith('~'):
        arg_string = lines[2][:-1].strip()
        cmd_start = 3

    # Remaining lines: script body ending with ~
    commands_lines = []
    for j in range(cmd_start, len(lines)):
        line = lines[j]
        if line.strip() == '~':
            break
        if line.endswith('~'):
            commands_lines.append(line[:-1])
            break
        commands_lines.append(line)

    commands = '\n'.join(commands_lines)

    # Extract numeric arg for HIT_PERCENT and TIME triggers
    numeric_arg = 0
    if 'HIT_PERCENT' in flags or 'TIME' in flags:
        match = re.search(r'(\d+)', arg_string)
        if match:
            numeric_arg = int(match.group(1))

    return DGTrigger(
        vnum=vnum,
        name=name,
        script_type=script_type,
        flags=flags,
        probability=probability,
        arg_string=arg_string,
        commands=commands,
        numeric_arg=numeric_arg
    )


def parse_all_triggers(trg_dir: Path) -> list[DGTrigger]:
    """
    Parse all trigger files in a directory.

    Args:
        trg_dir: Path to directory containing .trg files

    Returns:
        List of all DGTrigger objects from all files
    """
    all_triggers = []
    trg_files = sorted(trg_dir.glob('*.trg'))

    for trg_file in trg_files:
        try:
            triggers = parse_trigger_file(trg_file)
            all_triggers.extend(triggers)
        except Exception as e:
            print(f"Warning: Failed to parse {trg_file.name}: {e}")

    return all_triggers
