#!/usr/bin/env python3
"""
Generate a comprehensive spell implementation report.
This creates a human-readable markdown report with all extracted spell data.
"""

import json
from pathlib import Path
from typing import Dict, Any

# Paths
SPELL_DATA_JSON = Path("/home/strider/Code/mud/docs/all_spell_implementations.json")
REPORT_MD = Path("/home/strider/Code/mud/docs/SPELL_IMPLEMENTATION_REPORT.md")

def format_value(val):
    """Format a value for display."""
    if isinstance(val, list):
        return ', '.join(str(v) for v in val)
    elif isinstance(val, dict):
        return json.dumps(val, indent=2)
    else:
        return str(val)

def generate_report():
    """Generate the implementation report."""
    print(f"Loading spell data from {SPELL_DATA_JSON}...")

    with open(SPELL_DATA_JSON, 'r') as f:
        spell_data = json.load(f)

    print(f"Loaded {len(spell_data)} spell implementations")

    # Start building the report
    lines = []
    lines.append("# FieryMUD Spell Implementation Report")
    lines.append("")
    lines.append(f"**Generated from**: magic.cpp (mag_affect function)")
    lines.append(f"**Total spells extracted**: {len(spell_data)}")
    lines.append("")
    lines.append("---")
    lines.append("")

    # Count by type
    spell_count = sum(1 for k in spell_data if k.startswith('SPELL_'))
    chant_count = sum(1 for k in spell_data if k.startswith('CHANT_'))
    song_count = sum(1 for k in spell_data if k.startswith('SONG_'))

    lines.append("## Summary")
    lines.append("")
    lines.append(f"- **Spells**: {spell_count}")
    lines.append(f"- **Chants**: {chant_count}")
    lines.append(f"- **Songs**: {song_count}")
    lines.append("")

    # Statistics
    with_duration = sum(1 for impl in spell_data.values() if 'duration' in impl)
    with_effects = sum(1 for impl in spell_data.values() if 'effects' in impl and impl['effects'])
    with_messages = sum(1 for impl in spell_data.values() if 'messages' in impl)
    with_requirements = sum(1 for impl in spell_data.values() if 'requirements' in impl)
    with_conflicts = sum(1 for impl in spell_data.values() if 'conflicts' in impl)
    with_saving_throw = sum(1 for impl in spell_data.values() if 'saving_throw' in impl)

    lines.append("### Coverage")
    lines.append("")
    lines.append(f"- Spells with duration formula: {with_duration} ({with_duration * 100 / len(spell_data):.1f}%)")
    lines.append(f"- Spells with effects: {with_effects} ({with_effects * 100 / len(spell_data):.1f}%)")
    lines.append(f"- Spells with messages: {with_messages} ({with_messages * 100 / len(spell_data):.1f}%)")
    lines.append(f"- Spells with requirements: {with_requirements} ({with_requirements * 100 / len(spell_data):.1f}%)")
    lines.append(f"- Spells with conflicts: {with_conflicts} ({with_conflicts * 100 / len(spell_data):.1f}%)")
    lines.append(f"- Spells with saving throws: {with_saving_throw} ({with_saving_throw * 100 / len(spell_data):.1f}%)")
    lines.append("")

    lines.append("---")
    lines.append("")
    lines.append("## Detailed Spell Implementations")
    lines.append("")

    # Generate detailed entries for each spell (sorted alphabetically)
    for spell_name in sorted(spell_data.keys()):
        impl = spell_data[spell_name]

        lines.append(f"### {spell_name}")
        lines.append("")

        # Source
        if 'source' in impl:
            lines.append(f"**Source**: `{impl['source']}`")
            lines.append("")

        # Duration
        if 'duration' in impl:
            lines.append("**Duration**:")
            dur = impl['duration']
            if 'formula' in dur:
                lines.append(f"- Formula: `{dur['formula']}`")

            # Additional duration info
            for key in dur:
                if key != 'formula' and key != 'source':
                    lines.append(f"- {key.replace('_', ' ').title()}: `{dur[key]}`")

            lines.append("")

        # Effects
        if 'effects' in impl and impl['effects']:
            lines.append("**Effects**:")

            # Group effects by slot
            effects_by_slot = {}
            for effect in impl['effects']:
                slot = effect.get('effect_slot', 0)
                if slot not in effects_by_slot:
                    effects_by_slot[slot] = []
                effects_by_slot[slot].append(effect)

            # Output effects grouped by slot
            for slot in sorted(effects_by_slot.keys()):
                if len(effects_by_slot) > 1:
                    lines.append(f"- Effect slot {slot}:")
                else:
                    slot_prefix = ""

                for effect in effects_by_slot[slot]:
                    indent = "  " if len(effects_by_slot) > 1 else ""

                    if effect['type'] == 'modifier':
                        location = effect['location']
                        formula = effect['formula']
                        lines.append(f"{indent}- **{location}**: `{formula}`")
                    elif effect['type'] == 'effect_flag':
                        flag = effect['flag']
                        lines.append(f"{indent}- **Flag**: `{flag}`")

            lines.append("")

        # Special Mechanics
        if 'special_mechanics' in impl and impl['special_mechanics']:
            lines.append("**Special Mechanics**:")
            for mech in impl['special_mechanics']:
                lines.append(f"- {mech}")
            lines.append("")

        # Requirements
        if 'requirements' in impl and impl['requirements']:
            lines.append("**Requirements**:")
            for req in impl['requirements']:
                lines.append(f"- {req}")
            lines.append("")

        # Conflicts
        if 'conflicts' in impl and impl['conflicts']:
            lines.append("**Conflicts With**:")
            for conflict in impl['conflicts']:
                lines.append(f"- `{conflict}`")
            lines.append("")

        # Saving Throw
        if 'saving_throw' in impl:
            lines.append(f"**Saving Throw**: `{impl['saving_throw']}`")
            lines.append("")

        # Messages
        if 'messages' in impl and impl['messages']:
            lines.append("**Messages**:")
            msgs = impl['messages']
            if 'to_vict' in msgs:
                lines.append(f"- To victim: \"{msgs['to_vict']}\"")
            if 'to_room' in msgs:
                lines.append(f"- To room: \"{msgs['to_room']}\"")
            if 'to_char' in msgs:
                lines.append(f"- To caster: \"{msgs['to_char']}\"")
            lines.append("")

        lines.append("---")
        lines.append("")

    # Write the report
    print(f"Writing report to {REPORT_MD}...")
    with open(REPORT_MD, 'w') as f:
        f.write('\n'.join(lines))

    print(f"\nReport generation complete!")
    print(f"  Output: {REPORT_MD}")
    print(f"  Spells documented: {len(spell_data)}")

def main():
    """Main function."""
    print("FieryMUD Spell Implementation Report Generator")
    print("=" * 60)

    generate_report()

if __name__ == '__main__':
    main()
