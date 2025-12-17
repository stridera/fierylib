#!/usr/bin/env python3
"""Extract ability messages from FieryMUD C++ source code.

Extracts:
1. Wear-off messages from skills.cpp spello() calls
2. Cast messages (to_char, to_vict, to_room) from magic.cpp

Creates ability_messages.csv with the following columns:
- ability_name: Name of the spell/skill
- ability_id: SPELL_*, SKILL_*, SONG_*, CHANT_* constant
- wearoff_to_target: Message when effect expires
- success_to_caster: Message to caster on success
- success_to_victim: Message to target on success
- success_to_room: Message to room on success

Messages are converted from legacy CircleMUD syntax ($n, $N, etc.) to modern
template syntax ({actor.name}, {target.name}, etc.).
"""

import csv
import re
import sys
from pathlib import Path
from dataclasses import dataclass, field

# Add src to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))
from fierylib.parsers.socials_parser import convert_legacy_template
from typing import Optional


@dataclass
class AbilityMessage:
    """Container for ability messages."""
    ability_id: str
    ability_name: str
    wearoff_to_target: Optional[str] = None
    wearoff_to_room: Optional[str] = None
    success_to_caster: Optional[str] = None
    success_to_victim: Optional[str] = None
    success_to_room: Optional[str] = None
    fail_to_caster: Optional[str] = None
    fail_to_victim: Optional[str] = None
    fail_to_room: Optional[str] = None
    # For conditional messages
    conditional_messages: list = field(default_factory=list)


def extract_wearoff_messages(skills_cpp_path: Path) -> dict[str, AbilityMessage]:
    """Extract wear-off messages from spello() calls in skills.cpp.

    spello format:
    spello(SPELL_NAME, "display name", mana_max, mana_min, mana_change,
           min_pos, ok_fighting, targets, violent, routines, pages,
           cast_speed, damage_type, sphere, level, quest_only, "wearoff message");

    The last parameter is the wear-off message (can be nullptr).
    """
    messages: dict[str, AbilityMessage] = {}

    content = skills_cpp_path.read_text()

    # Find all spello() calls - they span multiple lines
    # Pattern: spello(ABILITY_ID, "name", ... , "message" or nullptr);
    spello_pattern = re.compile(
        r'spello\s*\(\s*'
        r'(SPELL_\w+|SKILL_\w+|SONG_\w+|CHANT_\w+)\s*,\s*'  # ability ID
        r'"([^"]+)"\s*,',  # display name
        re.MULTILINE
    )

    # Find each spello call and extract the wear-off message
    for match in spello_pattern.finditer(content):
        ability_id = match.group(1)
        ability_name = match.group(2)

        # Find the complete spello() call by counting parens
        start = match.start()
        paren_count = 0
        end = start
        in_string = False
        escape_next = False

        for i, char in enumerate(content[start:], start):
            if escape_next:
                escape_next = False
                continue
            if char == '\\':
                escape_next = True
                continue
            if char == '"' and not escape_next:
                in_string = not in_string
                continue
            if in_string:
                continue
            if char == '(':
                paren_count += 1
            elif char == ')':
                paren_count -= 1
                if paren_count == 0:
                    end = i + 1
                    break

        full_call = content[start:end]

        # Extract the last parameter (wear-off message)
        # Look for the last string literal or nullptr before the closing paren
        wearoff_msg = None

        # Find the last quoted string in the call
        string_pattern = re.compile(r'"((?:[^"\\]|\\.)*)"\s*\)\s*;?\s*$')
        string_match = string_pattern.search(full_call)
        if string_match:
            wearoff_msg = string_match.group(1)
            # Unescape the string
            wearoff_msg = wearoff_msg.replace('\\n', '\n').replace('\\"', '"')

        # Check for nullptr
        if 'nullptr);' in full_call or 'nullptr )' in full_call:
            if not string_match or full_call.rfind('nullptr') > full_call.rfind('"'):
                wearoff_msg = None

        messages[ability_id] = AbilityMessage(
            ability_id=ability_id,
            ability_name=ability_name,
            wearoff_to_target=wearoff_msg
        )

    return messages


def extract_cast_messages(magic_cpp_path: Path, messages: dict[str, AbilityMessage]) -> dict[str, AbilityMessage]:
    """Extract cast messages from magic.cpp.

    Looks for patterns like:
        case SPELL_NAME:
            to_char = "message";
            to_vict = "message";
            to_room = "message";
    """
    content = magic_cpp_path.read_text()

    # Pattern to find case blocks with messages
    case_pattern = re.compile(
        r'case\s+(SPELL_\w+|SKILL_\w+|SONG_\w+|CHANT_\w+)\s*:',
        re.MULTILINE
    )

    # Message assignment patterns
    to_char_pattern = re.compile(r'to_char\s*=\s*"((?:[^"\\]|\\.|"[\s\n]*")*)"')
    to_vict_pattern = re.compile(r'to_vict\s*=\s*"((?:[^"\\]|\\.|"[\s\n]*")*)"')
    to_room_pattern = re.compile(r'to_room\s*=\s*"((?:[^"\\]|\\.|"[\s\n]*")*)"')

    # Find all case blocks
    case_positions = [(m.group(1), m.end()) for m in case_pattern.finditer(content)]

    for i, (ability_id, case_start) in enumerate(case_positions):
        # Find the end of this case block (next case or break)
        if i + 1 < len(case_positions):
            next_case_start = case_positions[i + 1][1]
            # Find 'break' or next 'case' before next case
            case_end = content.find('break', case_start)
            if case_end == -1 or case_end > next_case_start:
                case_end = next_case_start
        else:
            case_end = content.find('break', case_start)
            if case_end == -1:
                case_end = len(content)

        case_block = content[case_start:case_end]

        # Extract messages from this case block
        to_char = to_char_pattern.search(case_block)
        to_vict = to_vict_pattern.search(case_block)
        to_room = to_room_pattern.search(case_block)

        # Get or create the message object
        if ability_id not in messages:
            # Try to find the name from skills.cpp extraction
            messages[ability_id] = AbilityMessage(
                ability_id=ability_id,
                ability_name=ability_id.replace('SPELL_', '').replace('SKILL_', '').replace('SONG_', '').replace('CHANT_', '').lower().replace('_', ' ')
            )

        msg = messages[ability_id]

        # Only set if not already set (first occurrence wins) and if found
        if to_char and not msg.success_to_caster:
            text = to_char.group(1).replace('\n', '').replace('\\n', '\n').replace('\\"', '"')
            # Clean up concatenated strings
            text = re.sub(r'"\s*"', '', text)
            msg.success_to_caster = text.strip()

        if to_vict and not msg.success_to_victim:
            text = to_vict.group(1).replace('\n', '').replace('\\n', '\n').replace('\\"', '"')
            text = re.sub(r'"\s*"', '', text)
            msg.success_to_victim = text.strip()

        if to_room and not msg.success_to_room:
            text = to_room.group(1).replace('\n', '').replace('\\n', '\n').replace('\\"', '"')
            text = re.sub(r'"\s*"', '', text)
            msg.success_to_room = text.strip()

    return messages


def clean_message(msg: Optional[str]) -> Optional[str]:
    """Clean up and convert a message string.

    - Cleans up whitespace
    - Converts legacy CircleMUD placeholders ($n, $N, etc.) to modern syntax
    """
    if not msg:
        return None
    # Clean up whitespace
    msg = ' '.join(msg.split())
    if not msg:
        return None
    # Convert legacy placeholders to modern syntax
    msg = convert_legacy_template(msg)
    return msg


def main():
    """Main extraction function."""
    # Paths
    fierymud_path = Path("/home/strider/Code/mud/fierymud")
    skills_cpp = fierymud_path / "legacy/src/skills.cpp"
    magic_cpp = fierymud_path / "legacy/src/magic.cpp"

    output_dir = Path("/home/strider/Code/mud/fierylib/docs/extraction-reports")
    output_file = output_dir / "ability_messages.csv"

    print("Extracting ability messages from FieryMUD C++ source...")
    print(f"  skills.cpp: {skills_cpp}")
    print(f"  magic.cpp: {magic_cpp}")

    # Extract wear-off messages
    print("\n1. Extracting wear-off messages from skills.cpp...")
    messages = extract_wearoff_messages(skills_cpp)
    wearoff_count = sum(1 for m in messages.values() if m.wearoff_to_target)
    print(f"   Found {len(messages)} abilities, {wearoff_count} with wear-off messages")

    # Extract cast messages
    print("\n2. Extracting cast messages from magic.cpp...")
    messages = extract_cast_messages(magic_cpp, messages)
    cast_count = sum(1 for m in messages.values() if m.success_to_caster or m.success_to_victim or m.success_to_room)
    print(f"   Found cast messages for {cast_count} abilities")

    # Write CSV
    print(f"\n3. Writing to {output_file}...")
    output_dir.mkdir(parents=True, exist_ok=True)

    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow([
            'ability_id',
            'ability_name',
            'wearoff_to_target',
            'success_to_caster',
            'success_to_victim',
            'success_to_room'
        ])

        # Sort by ability name for readability
        for ability_id, msg in sorted(messages.items(), key=lambda x: x[1].ability_name):
            writer.writerow([
                ability_id,
                msg.ability_name,
                clean_message(msg.wearoff_to_target) or '',
                clean_message(msg.success_to_caster) or '',
                clean_message(msg.success_to_victim) or '',
                clean_message(msg.success_to_room) or ''
            ])

    # Print summary
    print("\n" + "=" * 60)
    print("Extraction Summary")
    print("=" * 60)
    print(f"  Total abilities:        {len(messages)}")
    print(f"  With wear-off messages: {wearoff_count}")
    print(f"  With cast messages:     {cast_count}")
    print(f"  Output file:            {output_file}")

    # Show some examples
    print("\nSample entries:")
    samples = ['SPELL_ARMOR', 'SPELL_EARTHQUAKE', 'SPELL_FIREBALL', 'SPELL_BLESS']
    for sample in samples:
        if sample in messages:
            m = messages[sample]
            print(f"\n  {m.ability_name}:")
            if m.wearoff_to_target:
                print(f"    wearoff: {m.wearoff_to_target[:60]}...")
            if m.success_to_caster:
                print(f"    to_char: {m.success_to_caster[:60]}...")
            if m.success_to_room:
                print(f"    to_room: {m.success_to_room[:60]}...")


if __name__ == "__main__":
    main()
