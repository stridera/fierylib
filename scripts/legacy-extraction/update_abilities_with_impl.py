#!/usr/bin/env python3
"""
Update ABILITIES.md with implementation details from extracted spell data.
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Any

# Paths
ABILITIES_MD = Path("/home/strider/Code/mud/docs/ABILITIES.md")
SPELL_DATA_JSON = Path("/home/strider/Code/mud/docs/all_spell_implementations.json")
OUTPUT_MD = Path("/home/strider/Code/mud/docs/ABILITIES_UPDATED.md")

def load_spell_data() -> Dict[str, Any]:
    """Load extracted spell implementation data."""
    with open(SPELL_DATA_JSON, 'r') as f:
        return json.load(f)

def format_implementation(spell_name: str, impl_data: Dict[str, Any]) -> List[str]:
    """Format implementation data as markdown."""
    lines = ["", "**Implementation**:"]

    # Duration
    if 'duration' in impl_data:
        dur = impl_data['duration']
        if 'formula' in dur:
            formula = dur['formula']
            lines.append(f"- **Duration**: `{formula}`")

            # Add additional duration info for other effect slots
            for key in dur:
                if key.startswith('effect_'):
                    lines.append(f"  - {key.replace('_', ' ').title()}: `{dur[key]}`")

    # Effects
    if 'effects' in impl_data and impl_data['effects']:
        lines.append("- **Effects**:")

        # Group effects by slot
        effects_by_slot = {}
        for effect in impl_data['effects']:
            slot = effect.get('effect_slot', 0)
            if slot not in effects_by_slot:
                effects_by_slot[slot] = []
            effects_by_slot[slot].append(effect)

        # Output effects
        for slot in sorted(effects_by_slot.keys()):
            slot_effects = effects_by_slot[slot]

            for effect in slot_effects:
                if effect['type'] == 'modifier':
                    location = effect['location']
                    formula = effect['formula']
                    lines.append(f"  - **{location}**: `{formula}`")
                elif effect['type'] == 'effect_flag':
                    flag = effect['flag']
                    lines.append(f"  - **{flag}**: Granted")

    # Special Mechanics
    if 'special_mechanics' in impl_data and impl_data['special_mechanics']:
        lines.append("- **Special Mechanics**:")
        for mech in impl_data['special_mechanics']:
            lines.append(f"  - {mech}")

    # Requirements
    if 'requirements' in impl_data and impl_data['requirements']:
        lines.append("- **Requirements**:")
        for req in impl_data['requirements']:
            lines.append(f"  - {req}")

    # Conflicts
    if 'conflicts' in impl_data and impl_data['conflicts']:
        lines.append("- **Conflicts with**:")
        conflicts = ', '.join(impl_data['conflicts'][:5])
        if len(impl_data['conflicts']) > 5:
            conflicts += f" + {len(impl_data['conflicts']) - 5} more"
        lines.append(f"  - {conflicts}")

    # Saving Throw
    if 'saving_throw' in impl_data:
        lines.append(f"- **Saving Throw**: {impl_data['saving_throw']}")

    # Messages
    if 'messages' in impl_data and impl_data['messages']:
        msgs = impl_data['messages']
        if 'to_vict' in msgs:
            lines.append(f"- **Message (to victim)**: \"{msgs['to_vict']}\"")

    # Source
    if 'source' in impl_data:
        lines.append(f"- **Source**: {impl_data['source']}")

    return lines

def update_abilities_md():
    """Update ABILITIES.md with implementation details."""
    print("Loading spell data...")
    spell_data = load_spell_data()

    print(f"Loaded {len(spell_data)} spell implementations")

    print("Reading ABILITIES.md...")
    with open(ABILITIES_MD, 'r') as f:
        lines = f.readlines()

    print(f"Read {len(lines)} lines")

    # Find all ability entries that need updating
    updated_count = 0
    skipped_count = 0
    output_lines = []
    i = 0

    while i < len(lines):
        line = lines[i]
        output_lines.append(line)

        # Check if this is an ability enum line
        enum_match = re.match(r'- \*\*Enum\*\*: `(SPELL_\w+|CHANT_\w+|SONG_\w+)`', line)
        if enum_match:
            spell_name = enum_match.group(1)

            # Look ahead to see if there's already an **Implementation**: section
            has_impl = False
            j = i + 1
            while j < len(lines) and j < i + 50:  # Look ahead up to 50 lines
                if re.match(r'####', lines[j]):  # Next ability entry
                    break
                if re.match(r'\*\*Implementation\*\*:', lines[j]):
                    has_impl = True
                    break
                j += 1

            # Check if we have data for this spell
            if spell_name in spell_data:
                if has_impl:
                    # Skip existing implementation section and replace it
                    i += 1
                    while i < len(lines):
                        line = lines[i]

                        # Skip until we hit the next section or entry
                        if re.match(r'####', line) or re.match(r'- \*\*Enum\*\*:', line):
                            # Don't consume this line, back up
                            i -= 1
                            break

                        # Skip the old implementation section
                        if re.match(r'\*\*Implementation\*\*:', line):
                            # Skip this line and all following until next section
                            while i < len(lines):
                                next_line = lines[i]
                                if re.match(r'####', next_line):
                                    i -= 1  # Back up to not skip the header
                                    break
                                if re.match(r'- \*\*', next_line) and not next_line.strip().startswith('- **'):
                                    i -= 1
                                    break
                                i += 1
                            break

                        output_lines.append(line)
                        i += 1

                    # Add new implementation
                    impl_lines = format_implementation(spell_name, spell_data[spell_name])
                    for impl_line in impl_lines:
                        output_lines.append(impl_line + '\n')

                    updated_count += 1
                    print(f"Updated: {spell_name}")
                else:
                    # Find where to insert (after attributes, before next entry)
                    insert_pos = len(output_lines)

                    # Look for the end of this entry's attributes
                    j = i + 1
                    while j < len(lines):
                        if re.match(r'####', lines[j]):  # Next entry
                            insert_pos = len(output_lines) + (j - i - 1)
                            break
                        if re.match(r'- \*\*Enum\*\*:', lines[j]):  # Another entry
                            insert_pos = len(output_lines) + (j - i - 1)
                            break
                        j += 1

                    # Add lines up to insert position
                    while i + 1 < j and i + 1 < len(lines):
                        i += 1
                        output_lines.append(lines[i])

                    # Insert implementation
                    impl_lines = format_implementation(spell_name, spell_data[spell_name])
                    for impl_line in impl_lines:
                        output_lines.append(impl_line + '\n')

                    updated_count += 1
                    print(f"Added: {spell_name}")
            else:
                skipped_count += 1

        i += 1

    # Write updated file
    print(f"\nWriting updated file to {OUTPUT_MD}...")
    with open(OUTPUT_MD, 'w') as f:
        f.writelines(output_lines)

    print(f"\nUpdate complete!")
    print(f"  Updated: {updated_count} abilities")
    print(f"  Skipped: {skipped_count} abilities (no implementation data)")
    print(f"  Output: {OUTPUT_MD}")

def main():
    """Main update function."""
    print("FieryMUD ABILITIES.md Implementation Updater")
    print("=" * 60)

    update_abilities_md()

if __name__ == '__main__':
    main()
