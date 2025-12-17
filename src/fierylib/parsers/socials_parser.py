"""
Socials Parser - Parses legacy CircleMUD socials file and converts to modern template syntax.

See /docs/MESSAGE_TEMPLATES.md for the modern template specification.
"""

import re
from dataclasses import dataclass
from pathlib import Path
from typing import Optional


# Legacy CircleMUD code to modern template mapping
# See docs/MESSAGE_TEMPLATES.md for full specification
LEGACY_CODE_MAP = {
    # Actor codes (lowercase in legacy = actor)
    "$n": "{actor.name}",
    "$e": "{actor.pronoun.subjective}",
    "$m": "{actor.pronoun.objective}",
    "$s": "{actor.pronoun.possessive}",

    # Target codes (uppercase in legacy = target, but $N is target name)
    "$N": "{target.name}",
    "$E": "{target.pronoun.Subjective}",  # Capitalized for sentence mid-position
    "$M": "{target.pronoun.objective}",   # Usually mid-sentence
    "$S": "{target.pronoun.possessive}",

    # Reflexive - legacy uses $mself pattern
    "$mself": "{actor.pronoun.reflexive}",
    "$Mself": "{target.pronoun.reflexive}",
}

# Position enum mapping (CircleMUD position values)
# From structs.hpp: POS_DEAD=0, POS_MORT=1, POS_INCAP=2, POS_STUNNED=3,
#                   POS_SLEEPING=4, POS_RESTING=5, POS_SITTING=6, POS_FIGHTING=7, POS_STANDING=8
# However, the socials file uses a simplified version where:
# 0 = any position (mapped to PRONE as minimum)
# 1 = must be at least sitting (SITTING)
# Higher values rarely used
POSITION_MAP = {
    0: "PRONE",      # Any position
    1: "SITTING",    # At least sitting
    2: "KNEELING",   # At least kneeling
    3: "STANDING",   # Must be standing
    4: "STANDING",   # Standing (legacy had more positions)
    5: "STANDING",   # Standing
    6: "SITTING",    # Sitting
    7: "STANDING",   # Fighting (treat as standing)
    8: "STANDING",   # Standing
}


@dataclass
class Social:
    """Parsed social command data with modern template syntax."""
    name: str
    hide: bool
    min_victim_position: str  # Position enum value

    # No argument messages
    char_no_arg: Optional[str]
    others_no_arg: Optional[str]

    # Target found messages (None if social doesn't support targeting)
    char_found: Optional[str]
    others_found: Optional[str]
    vict_found: Optional[str]

    # Target not found
    not_found: Optional[str]

    # Self-targeting messages
    char_auto: Optional[str]
    others_auto: Optional[str]


def convert_legacy_template(text: Optional[str]) -> Optional[str]:
    """
    Convert a legacy CircleMUD template string to modern syntax.

    Legacy: "$n bows before $N."
    Modern: "{actor.name} bows before {target.name}."

    Args:
        text: Legacy template string or None

    Returns:
        Modern template string or None
    """
    if text is None:
        return None

    result = text

    # Sort by length (longest first) to avoid partial replacements
    # e.g., replace $mself before $m
    sorted_codes = sorted(LEGACY_CODE_MAP.keys(), key=len, reverse=True)

    for legacy_code in sorted_codes:
        modern_code = LEGACY_CODE_MAP[legacy_code]
        result = result.replace(legacy_code, modern_code)

    # Handle edge case: $<letter>self patterns not in map
    # e.g., "$eself" should become "{actor.pronoun.reflexive}"
    result = re.sub(r'\$([a-z])self', r'{actor.pronoun.reflexive}', result)
    result = re.sub(r'\$([A-Z])self', r'{target.pronoun.reflexive}', result)

    return result


def parse_socials_file(filepath: Path) -> list[Social]:
    """
    Parse a CircleMUD socials file and convert to modern format.

    File format:
        social_name hide_flag min_victim_position
        char_no_arg_message
        others_no_arg_message
        char_found_message (or # if no target allowed)
        [if char_found exists:]
        others_found_message
        vict_found_message
        not_found_message
        char_auto_message
        others_auto_message

        [blank line between entries]
        $ [end of file marker]

    Args:
        filepath: Path to the socials file

    Returns:
        List of parsed Social objects with modern templates
    """
    socials = []

    with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()

    lines = content.split('\n')
    i = 0

    while i < len(lines):
        line = lines[i].strip()

        # Skip empty lines
        if not line:
            i += 1
            continue

        # End of file marker
        if line == '$':
            break

        # Parse header line: name hide_flag min_position
        parts = line.split()
        if len(parts) < 3:
            # Malformed header, skip
            i += 1
            continue

        name = parts[0]

        # Skip entries that look like garbage (e.g., "z001#@#")
        if not name.isalpha():
            # Skip until next blank line or end
            while i < len(lines) and lines[i].strip():
                i += 1
            continue

        try:
            hide = int(parts[1]) != 0
            min_pos_num = int(parts[2])
            min_victim_position = POSITION_MAP.get(min_pos_num, "STANDING")
        except ValueError:
            # Skip malformed entry
            i += 1
            continue

        # Read message lines
        i += 1

        def read_line() -> Optional[str]:
            """Read next message line, returning None for # marker."""
            nonlocal i
            if i >= len(lines):
                return None
            text = lines[i]
            i += 1
            if text.strip() == '#':
                return None
            return text if text else None

        char_no_arg = read_line()
        others_no_arg = read_line()
        char_found = read_line()

        # If char_found is None (was #), this social doesn't support targeting
        if char_found is None:
            others_found = None
            vict_found = None
            not_found = None
            char_auto = None
            others_auto = None
        else:
            others_found = read_line()
            vict_found = read_line()
            not_found = read_line()
            char_auto = read_line()
            others_auto = read_line()

        # Convert all templates to modern syntax
        social = Social(
            name=name,
            hide=hide,
            min_victim_position=min_victim_position,
            char_no_arg=convert_legacy_template(char_no_arg),
            others_no_arg=convert_legacy_template(others_no_arg),
            char_found=convert_legacy_template(char_found),
            others_found=convert_legacy_template(others_found),
            vict_found=convert_legacy_template(vict_found),
            not_found=convert_legacy_template(not_found),
            char_auto=convert_legacy_template(char_auto),
            others_auto=convert_legacy_template(others_auto),
        )

        socials.append(social)

    return socials


def parse_socials(lib_path: Path) -> list[Social]:
    """
    Parse socials from the standard lib/misc/socials location.

    Args:
        lib_path: Path to the lib directory

    Returns:
        List of parsed Social objects
    """
    socials_file = lib_path / "misc" / "socials"

    if not socials_file.exists():
        raise FileNotFoundError(f"Socials file not found: {socials_file}")

    return parse_socials_file(socials_file)


# For testing/debugging
if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1:
        filepath = Path(sys.argv[1])
    else:
        filepath = Path("../lib/misc/socials")

    socials = parse_socials_file(filepath)
    print(f"Parsed {len(socials)} socials\n")

    # Show first few as examples
    for social in socials[:5]:
        print(f"=== {social.name} ===")
        print(f"  hide: {social.hide}")
        print(f"  min_position: {social.min_victim_position}")
        print(f"  char_no_arg: {social.char_no_arg}")
        print(f"  others_no_arg: {social.others_no_arg}")
        if social.char_found:
            print(f"  char_found: {social.char_found}")
            print(f"  vict_found: {social.vict_found}")
        print()
