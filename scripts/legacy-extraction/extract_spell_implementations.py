#!/usr/bin/env python3
"""
Extract spell implementations from FieryMUD magic.cpp
This script parses the mag_affect() function to extract all spell formulas and effects.
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Any, Tuple

# Path to magic.cpp
MAGIC_CPP = Path("/home/strider/Code/mud/fierymud/legacy/src/magic.cpp")
OUTPUT_JSON = Path("/home/strider/Code/mud/docs/all_spell_implementations.json")
SUMMARY_FILE = Path("/home/strider/Code/mud/docs/extraction_summary.txt")

def find_switch_end(lines: List[str], start_idx: int) -> int:
    """Find the end of the switch statement by tracking braces."""
    brace_count = 0
    for i in range(start_idx, len(lines)):
        line = lines[i]

        # Count opening and closing braces
        brace_count += line.count('{')
        brace_count -= line.count('}')

        # When we return to the original brace level, we've found the end
        if brace_count == -1:  # The closing brace of switch
            return i

    return len(lines)

def extract_spell_cases(lines: List[str], switch_start: int, switch_end: int) -> Dict[str, Tuple[List[str], int, int]]:
    """
    Extract all case blocks from switch statement.
    Returns dict of spell_name -> (case_names, impl_lines, start_line, end_line)
    """
    cases = {}
    current_case_names = []
    current_impl_lines = []
    current_start_line = None
    idx = switch_start + 1

    while idx < switch_end:
        line = lines[idx]

        # Check for case statement
        case_match = re.match(r'\s*case\s+(SPELL_\w+|CHANT_\w+|SONG_\w+):', line)
        if case_match:
            spell_name = case_match.group(1)
            current_case_names.append(spell_name)

            if current_start_line is None:
                current_start_line = idx + 1  # 1-indexed

            idx += 1
            continue

        # Check for break statement - end of current case block
        if re.match(r'\s*break;\s*$', line):
            if current_case_names and current_impl_lines:
                # All case names in this block share the same implementation
                impl_text = '\n'.join(current_impl_lines)
                for spell_name in current_case_names:
                    cases[spell_name] = (impl_text, current_start_line, idx + 1)

            # Reset for next case block
            current_case_names = []
            current_impl_lines = []
            current_start_line = None
            idx += 1
            continue

        # Accumulate implementation lines
        if current_case_names:
            current_impl_lines.append(line)

        idx += 1

    return cases

def parse_spell_impl(impl_text: str, spell_name: str, start_line: int, end_line: int) -> Dict[str, Any]:
    """Parse a spell implementation block and extract details."""
    impl = {
        "name": spell_name,
        "duration": {},
        "effects": [],
        "requirements": [],
        "conflicts": [],
        "messages": {},
        "special_mechanics": [],
        "source": f"magic.cpp:{start_line}-{end_line}"
    }

    # Extract duration formulas (can be multiple for different effect slots)
    duration_matches = re.finditer(r'eff\[(\d+)\]\.duration\s*=\s*([^;]+);', impl_text)
    for match in duration_matches:
        effect_num = int(match.group(1))
        formula = match.group(2).strip()

        if effect_num == 0:
            impl["duration"]["formula"] = formula
        else:
            impl["duration"][f"effect_{effect_num}"] = formula

    # Extract modifiers
    modifier_patterns = [
        # Pattern 1: location and modifier on separate lines
        (r'eff\[(\d+)\]\.location\s*=\s*APPLY_(\w+);\s*eff\[\1\]\.modifier\s*=\s*([^;]+);', re.DOTALL),
        # Pattern 2: modifier before location
        (r'eff\[(\d+)\]\.modifier\s*=\s*([^;]+);.*?eff\[\1\]\.location\s*=\s*APPLY_(\w+);', re.DOTALL),
    ]

    for pattern, flags in modifier_patterns:
        matches = re.finditer(pattern, impl_text, flags)
        for match in matches:
            if len(match.groups()) == 3:
                effect_num = match.group(1)
                if pattern.find('location.*modifier') > -1:
                    location = match.group(2)
                    modifier = match.group(3).strip()
                else:
                    modifier = match.group(2).strip()
                    location = match.group(3)

                # Check if this effect is already added
                existing = [e for e in impl["effects"] if e.get("effect_slot") == int(effect_num) and e.get("type") == "modifier"]
                if not existing:
                    impl["effects"].append({
                        "type": "modifier",
                        "location": f"APPLY_{location}",
                        "formula": modifier,
                        "effect_slot": int(effect_num)
                    })

    # Extract effect flags
    flag_matches = re.finditer(r'SET_FLAG\(eff\[(\d+)\]\.flags,\s*EFF_(\w+)\)', impl_text)
    for match in flag_matches:
        effect_num = match.group(1)
        flag = match.group(2)

        impl["effects"].append({
            "type": "effect_flag",
            "flag": f"EFF_{flag}",
            "effect_slot": int(effect_num)
        })

    # Extract messages (handle multi-line strings and concatenation)
    msg_patterns = {
        'to_vict': r'to_vict\s*=\s*"([^"]+)"',
        'to_room': r'to_room\s*=\s*"([^"]+)"',
        'to_char': r'to_char\s*=\s*"([^"]+)"',
    }

    for msg_type, pattern in msg_patterns.items():
        match = re.search(pattern, impl_text)
        if match:
            impl["messages"][msg_type] = match.group(1)

    # Extract requirements
    if 'IS_EVIL(victim)' in impl_text and 'can\'t' in impl_text.lower():
        impl["requirements"].append("Alignment: Cannot target evil")
    if 'IS_GOOD(victim)' in impl_text and 'can\'t' in impl_text.lower():
        impl["requirements"].append("Alignment: Cannot target good")
    if 'IS_NEUTRAL(ch)' in impl_text:
        impl["requirements"].append("Alignment: Caster must be neutral")
    if 'IS_EVIL(ch)' in impl_text and 'forsaken' in impl_text:
        impl["requirements"].append("Alignment: Caster cannot be evil")
    if 'IS_GOOD(ch)' in impl_text and 'forsaken' in impl_text:
        impl["requirements"].append("Alignment: Caster cannot be good")
    if 'SKILL_BAREHAND' in impl_text:
        impl["requirements"].append("Must have SKILL_BAREHAND (monk-only)")
    if 'IS_NPC(victim)' in impl_text and 'return' in impl_text:
        impl["requirements"].append("Cannot target NPCs")
    if 'too_heavy_to_fly' in impl_text:
        impl["special_mechanics"].append("Weight restriction for flying")

    # Extract conflicts
    conflict_matches = re.finditer(r'affected_by_spell\([^,]+,\s*(SPELL_\w+|CHANT_\w+|SONG_\w+)\)', impl_text)
    for match in conflict_matches:
        conflict = match.group(1)
        if conflict != spell_name and conflict not in impl["conflicts"]:
            impl["conflicts"].append(conflict)

    # Extract saving throw info
    if 'mag_savingthrow' in impl_text:
        savetype_match = re.search(r'mag_savingthrow\([^,]+,\s*(\w+)\)', impl_text)
        if savetype_match:
            impl["saving_throw"] = savetype_match.group(1)

    # Extract attack_ok requirement
    if 'attack_ok' in impl_text:
        impl["requirements"].append("Requires attack_ok check (offensive spell)")

    # Extract refresh flag
    if 'refresh = false' in impl_text:
        impl["special_mechanics"].append("Does not refresh existing spell duration")

    # Extract accumulation flags
    if 'accum_effect = true' in impl_text:
        impl["special_mechanics"].append("Effect modifiers accumulate")
    if 'accum_duration = true' in impl_text:
        impl["special_mechanics"].append("Duration accumulates")

    # Extract special function calls
    if 'get_vitality_hp_gain' in impl_text:
        impl["special_mechanics"].append("HP gain calculated by get_vitality_hp_gain()")
    if 'get_spell_duration' in impl_text:
        impl["special_mechanics"].append("Duration calculated by get_spell_duration()")
    if 'check_armor_spells' in impl_text:
        impl["special_mechanics"].append("Conflicts with other armor spells (check_armor_spells)")
    if 'check_bless_spells' in impl_text:
        impl["special_mechanics"].append("Conflicts with other blessing spells (check_bless_spells)")
    if 'check_enhance_spells' in impl_text:
        impl["special_mechanics"].append("Conflicts with other enhancement spells")
    if 'check_monk_hand_spells' in impl_text:
        impl["special_mechanics"].append("Conflicts with other monk hand spells")

    # Extract parameter parsing (for elemental spells)
    if 'is_abbrev(buf2,' in impl_text:
        param_matches = re.findall(r'is_abbrev\(buf2,\s*"(\w+)"\)', impl_text)
        if param_matches:
            impl["special_mechanics"].append(f"Requires parameter: {', '.join(param_matches)}")

    # Clean up empty fields
    if not impl["duration"]:
        del impl["duration"]
    if not impl["requirements"]:
        del impl["requirements"]
    if not impl["conflicts"]:
        del impl["conflicts"]
    if not impl["messages"]:
        del impl["messages"]
    if not impl["special_mechanics"]:
        del impl["special_mechanics"]

    return impl

def extract_all_spells():
    """Extract all spell implementations from magic.cpp."""
    print(f"Reading {MAGIC_CPP}...")

    with open(MAGIC_CPP, 'r') as f:
        lines = f.readlines()

    # Find mag_affect function start
    mag_affect_start = None
    for i, line in enumerate(lines):
        if 'int mag_affect' in line and '(' in line:
            mag_affect_start = i
            break

    if not mag_affect_start:
        print("ERROR: Could not find mag_affect function!")
        return {}

    print(f"Found mag_affect at line {mag_affect_start + 1}")

    # Find switch statement
    switch_start = None
    for i in range(mag_affect_start, min(mag_affect_start + 50, len(lines))):
        if 'switch (spellnum)' in lines[i]:
            switch_start = i
            break

    if not switch_start:
        print("ERROR: Could not find switch statement!")
        return {}

    print(f"Found switch at line {switch_start + 1}")

    # Find end of switch
    switch_end = find_switch_end(lines, switch_start)
    print(f"Switch statement ends at line {switch_end + 1}")
    print(f"Analyzing {switch_end - switch_start} lines of switch statement...")

    # Extract all cases
    cases = extract_spell_cases(lines, switch_start, switch_end)
    print(f"Found {len(cases)} spell cases")

    # Parse each case
    implementations = {}
    for spell_name, (impl_text, start_line, end_line) in cases.items():
        impl = parse_spell_impl(impl_text, spell_name, start_line, end_line)
        implementations[spell_name] = impl

    print(f"Parsed {len(implementations)} implementations")
    return implementations

def write_summary(implementations: Dict[str, Any]):
    """Write extraction summary."""
    with open(SUMMARY_FILE, 'w') as f:
        f.write(f"Spell Implementation Extraction Summary\n")
        f.write(f"=" * 60 + "\n\n")
        f.write(f"Total spells extracted: {len(implementations)}\n\n")

        # Count by type
        spell_count = sum(1 for k in implementations if k.startswith('SPELL_'))
        chant_count = sum(1 for k in implementations if k.startswith('CHANT_'))
        song_count = sum(1 for k in implementations if k.startswith('SONG_'))

        f.write(f"By type:\n")
        f.write(f"  Spells: {spell_count}\n")
        f.write(f"  Chants: {chant_count}\n")
        f.write(f"  Songs: {song_count}\n\n")

        # Statistics
        with_duration = sum(1 for impl in implementations.values() if 'duration' in impl)
        with_effects = sum(1 for impl in implementations.values() if 'effects' in impl and impl['effects'])
        with_messages = sum(1 for impl in implementations.values() if 'messages' in impl)
        with_requirements = sum(1 for impl in implementations.values() if 'requirements' in impl)

        f.write(f"Statistics:\n")
        f.write(f"  With duration formula: {with_duration}\n")
        f.write(f"  With effects: {with_effects}\n")
        f.write(f"  With messages: {with_messages}\n")
        f.write(f"  With requirements: {with_requirements}\n\n")

        # List all extracted spells
        f.write(f"Extracted spells:\n")
        f.write(f"-" * 60 + "\n")
        for spell_name in sorted(implementations.keys()):
            impl = implementations[spell_name]
            effect_count = len(impl.get('effects', []))
            has_dur = 'duration' in impl
            has_msg = 'messages' in impl
            f.write(f"{spell_name:40} effects={effect_count} dur={has_dur} msg={has_msg}\n")

def main():
    """Main extraction function."""
    print("FieryMUD Spell Implementation Extractor")
    print("=" * 60)

    # Extract all spell implementations
    implementations = extract_all_spells()

    if not implementations:
        print("ERROR: No implementations extracted!")
        return

    # Write JSON output
    print(f"\nWriting JSON to {OUTPUT_JSON}...")
    with open(OUTPUT_JSON, 'w') as f:
        json.dump(implementations, f, indent=2, sort_keys=True)

    # Write summary
    print(f"Writing summary to {SUMMARY_FILE}...")
    write_summary(implementations)

    print("\nExtraction complete!")
    print(f"  JSON output: {OUTPUT_JSON}")
    print(f"  Summary: {SUMMARY_FILE}")
    print(f"  Total spells: {len(implementations)}")

if __name__ == '__main__':
    main()
