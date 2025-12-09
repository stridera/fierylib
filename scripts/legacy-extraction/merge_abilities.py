#!/usr/bin/env python3
"""
Merge ABILITIES.md with all_spell_implementations.json to create ABILITIES_COMPLETE.md
"""

import json
import re
from pathlib import Path
from datetime import datetime

def parse_abilities_md(md_path):
    """Parse ABILITIES.md and extract all ability entries"""
    with open(md_path, 'r') as f:
        content = f.read()

    abilities = []
    current_category = None

    # Split by category headers (## Category Name)
    category_pattern = r'^## (.+)$'
    ability_pattern = r'^#### (.+?) \(ID (\d+)\)$'
    enum_pattern = r'- \*\*Enum\*\*: `(.+?)`'

    lines = content.split('\n')
    current_ability = None
    current_text = []

    for line in lines:
        cat_match = re.match(category_pattern, line)
        if cat_match:
            if current_ability:
                current_ability['text'] = '\n'.join(current_text)
                abilities.append(current_ability)
                current_text = []
                current_ability = None
            current_category = cat_match.group(1)
            continue

        ability_match = re.match(ability_pattern, line)
        if ability_match:
            if current_ability:
                current_ability['text'] = '\n'.join(current_text)
                abilities.append(current_ability)
                current_text = []

            name = ability_match.group(1)
            ability_id = int(ability_match.group(2))
            current_ability = {
                'id': ability_id,
                'name': name,
                'category': current_category,
                'header_line': line,
                'enum': None
            }
            current_text.append(line)
        elif current_ability:
            # Check for enum
            enum_match = re.match(enum_pattern, line)
            if enum_match:
                current_ability['enum'] = enum_match.group(1)
            current_text.append(line)

    # Don't forget the last one
    if current_ability:
        current_ability['text'] = '\n'.join(current_text)
        abilities.append(current_ability)

    return abilities

def parse_implementation_json(json_path):
    """Parse all_spell_implementations.json"""
    with open(json_path, 'r') as f:
        return json.load(f)

def extract_metadata(ability_text):
    """Extract metadata section from ability text"""
    lines = ability_text.split('\n')
    metadata = []
    in_implementation = False

    for line in lines:
        if line.startswith('**Implementation**'):
            in_implementation = True
            break
        if line.startswith('#### '):
            metadata.append(line)
        elif line.startswith('- ') or line.startswith('  - '):
            metadata.append(line)

    return '\n'.join(metadata)

def format_duration(duration_data):
    """Format duration information"""
    if not duration_data:
        return None

    formula = duration_data.get('formula', '')
    description = duration_data.get('description', '')

    # Clean up formula (remove excessive whitespace and newlines)
    if formula:
        formula = ' '.join(formula.split())

    if formula:
        return f"`{formula}` {description}".strip()
    return description

def format_damage(damage_data):
    """Format damage information"""
    if not damage_data:
        return None

    lines = []

    if 'damage_type' in damage_data:
        lines.append(f"- **Damage Type**: {damage_data['damage_type']}")

    if 'formula' in damage_data:
        lines.append(f"- **Damage Formula**: `{damage_data['formula']}`")

    if 'estimated' in damage_data:
        lines.append("- **Estimated Damage**:")
        for est in damage_data['estimated']:
            lines.append(f"  - {est}")

    return '\n'.join(lines)

def format_effects(effects):
    """Format effects list"""
    if not effects:
        return None

    lines = ["- **Effects**:"]

    for effect in effects:
        effect_type = effect.get('type', '')

        if effect_type == 'modifier':
            # The 'formula' field contains the APPLY_ constant
            # The 'location' field contains the modifier value/formula
            apply_const = effect.get('formula', '')
            modifier_formula = effect.get('location', '')

            # Clean up the location field to extract just the modifier
            # e.g., "APPLY_-2 - (skill / 10)" -> "-2 - (skill / 10)"
            if modifier_formula.startswith('APPLY_'):
                modifier_formula = modifier_formula.replace('APPLY_', '', 1)

            lines.append(f"  - **APPLY_{apply_const}**: `{modifier_formula}`")

        elif effect_type == 'effect_flag':
            flag = effect.get('flag', '')
            desc = effect.get('description', '')
            if desc:
                lines.append(f"  - **{flag}**: {desc}")
            else:
                lines.append(f"  - **{flag}**")

        # Legacy format fallback
        elif 'location' in effect and 'type' not in effect:
            modifier = effect.get('modifier', '')
            lines.append(f"  - **{effect['location']}**: `{modifier}`")
        elif 'flag' in effect and 'type' not in effect:
            desc = effect.get('description', '')
            if desc:
                lines.append(f"  - **{effect['flag']}**: {desc}")
            else:
                lines.append(f"  - **{effect['flag']}**")

    return '\n'.join(lines)

def format_mechanics(mechanics):
    """Format skill mechanics"""
    if not mechanics:
        return None

    lines = []

    if 'description' in mechanics:
        lines.append(f"- **Mechanics**: {mechanics['description']}")

    if 'duration' in mechanics:
        lines.append(f"- **Duration**: {mechanics['duration']}")

    if 'requirements' in mechanics:
        reqs = mechanics['requirements']
        if isinstance(reqs, list):
            lines.append(f"- **Requirements**: {'; '.join(reqs)}")
        else:
            lines.append(f"- **Requirements**: {reqs}")

    if 'multiplier' in mechanics:
        lines.append(f"- **Multiplier**: {mechanics['multiplier']}")

    if 'immunities' in mechanics:
        lines.append(f"- **Immunities**: {mechanics['immunities']}")

    if 'max_followers' in mechanics:
        lines.append(f"- **Max Followers**: {mechanics['max_followers']}")

    if 'special' in mechanics:
        lines.append(f"- **Special**: {mechanics['special']}")

    if 'source' in mechanics:
        lines.append(f"- **Source**: {mechanics['source']}")

    return '\n'.join(lines)

def format_implementation(impl_data):
    """Format complete implementation section"""
    if not impl_data:
        return "**Implementation**: Data not yet extracted from source code\n"

    lines = ["**Implementation**:"]

    # Duration
    if 'duration' in impl_data:
        dur = format_duration(impl_data['duration'])
        if dur:
            lines.append(f"- **Duration**: {dur}")

    # Damage
    if 'damage' in impl_data:
        dam = format_damage(impl_data['damage'])
        if dam:
            lines.append(dam)

    # Effects
    if 'effects' in impl_data:
        eff = format_effects(impl_data['effects'])
        if eff:
            lines.append(eff)

    # Mechanics (for skills)
    if 'mechanics' in impl_data:
        mech = format_mechanics(impl_data['mechanics'])
        if mech:
            lines.append(mech)

    # Special mechanics
    if 'special_mechanics' in impl_data:
        specials = impl_data['special_mechanics']
        if specials:
            lines.append("- **Special Mechanics**:")
            for special in specials:
                lines.append(f"  - {special}")

    # Requirements
    if 'requirements' in impl_data and not ('mechanics' in impl_data):
        reqs = impl_data['requirements']
        if reqs:
            if isinstance(reqs, list):
                lines.append(f"- **Requirements**: {'; '.join(reqs)}")
            else:
                lines.append(f"- **Requirements**: {reqs}")

    # Conflicts
    if 'conflicts' in impl_data:
        conflicts = impl_data['conflicts']
        if conflicts:
            lines.append(f"- **Conflicts**: {', '.join(conflicts)}")

    # Messages
    if 'messages' in impl_data:
        msgs = impl_data['messages']
        if msgs:
            lines.append("- **Messages**:")
            for key, val in msgs.items():
                if val:
                    lines.append(f"  - **{key}**: \"{val}\"")

    # Save type
    if 'save_type' in impl_data:
        lines.append(f"- **Save Type**: {impl_data['save_type']}")

    # Healing
    if 'healing' in impl_data:
        heal = impl_data['healing']
        if 'amount' in heal:
            lines.append(f"- **Healing Amount**: {heal['amount']}")
        if 'type' in heal:
            lines.append(f"- **Healing Type**: {heal['type']}")

    # Source
    if 'source' in impl_data:
        src = impl_data['source']
        if isinstance(src, list):
            lines.append(f"- **Source**: {', '.join(src)}")
        else:
            lines.append(f"- **Source**: {src}")

    return '\n'.join(lines) + '\n'

def match_ability_to_implementation(ability, implementations):
    """Find matching implementation data for an ability"""
    ability_enum = ability.get('enum')
    ability_name = ability['name']

    # Try enum match first (most reliable)
    if ability_enum and ability_enum in implementations:
        return implementations[ability_enum]

    # Try name matching (exact)
    for impl_key, impl_data in implementations.items():
        if impl_data.get('name', '') == ability_name:
            return impl_data

    # Try case-insensitive name matching
    for impl_key, impl_data in implementations.items():
        if impl_data.get('name', '').lower() == ability_name.lower():
            return impl_data

    return None

def create_complete_md(abilities, implementations, output_path):
    """Create the complete merged markdown file"""

    # Count coverage
    total_abilities = len(abilities)
    with_impl = 0
    categories = {}

    for ability in abilities:
        cat = ability['category']
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(ability)

        impl = match_ability_to_implementation(ability, implementations)
        if impl:
            with_impl += 1

    # Generate header
    header = f"""# FieryMUD Ability System - Complete Reference

**Source**: Extracted from actual C++ implementation code

**Last Updated**: {datetime.now().strftime('%Y-%m-%d')}

**Coverage**: {with_impl}/{total_abilities} abilities ({(with_impl/total_abilities*100):.1f}%)

## Overview

- **Total abilities**: {total_abilities}
  - Spells: ~268
  - Skills: ~94
  - Songs: ~10
  - Chants: ~18

### Implementation Coverage

- **With complete implementation data**: {with_impl}/{total_abilities} ({(with_impl/total_abilities*100):.1f}%)
- **Missing implementation data**: {total_abilities - with_impl}

### Categories

"""

    for cat, items in sorted(categories.items()):
        header += f"- **{cat}**: {len(items)} abilities\n"

    header += """
### Quick Reference

- [Implementation Mechanics](#implementation-mechanics) - System-level details
- [Damage Formulas](DAMAGE_SPELL_FORMULAS.md) - All damage spell formulas
- [Skill Mechanics](SKILL_MECHANICS.md) - All skill mechanics
- [Complete JSON Data](all_spell_implementations.json) - Machine-readable database

---

"""

    # Read the existing header content from ABILITIES.md (saving throws, etc.)
    with open('/home/strider/Code/mud/docs/ABILITIES.md', 'r') as f:
        md_content = f.read()

    # Extract the section between first ## and second ##
    intro_match = re.search(r'^# .+?\n\n(.+?)\n## ', md_content, re.DOTALL | re.MULTILINE)
    if intro_match:
        intro_content = intro_match.group(1).strip()
        # Skip the first paragraph (we have our own)
        intro_lines = intro_content.split('\n\n', 1)
        if len(intro_lines) > 1:
            header += intro_lines[1] + '\n\n---\n\n'

    # Now write the complete file
    with open(output_path, 'w') as f:
        f.write(header)

        # Write each category
        for cat in sorted(categories.keys()):
            f.write(f"\n## {cat}\n\n")

            for ability in sorted(categories[cat], key=lambda x: x['id']):
                # Get metadata
                metadata = extract_metadata(ability['text'])

                # Get implementation
                impl = match_ability_to_implementation(ability, implementations)
                impl_section = format_implementation(impl)

                # Write ability entry
                f.write(f"{metadata}\n\n")
                f.write(f"{impl_section}\n")
                f.write("---\n\n")

    return total_abilities, with_impl

def create_summary(total, with_impl, output_path):
    """Create summary statistics file"""
    missing = total - with_impl

    summary = f"""FieryMUD Ability System - Implementation Coverage Summary
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

COVERAGE STATISTICS
===================

Total Abilities: {total}
With Implementation Data: {with_impl} ({(with_impl/total*100):.1f}%)
Missing Implementation Data: {missing} ({(missing/total*100):.1f}%)

COMPLETION STATUS
================

{"✅ COMPLETE - All abilities have implementation data!" if missing == 0 else f"⚠️  IN PROGRESS - {missing} abilities still need implementation data"}

FILES GENERATED
===============

✅ ABILITIES_COMPLETE.md - {total} abilities with merged implementation data
✅ This summary file

NEXT STEPS
==========

"""

    if missing > 0:
        summary += f"- Extract implementation data for remaining {missing} abilities\n"
        summary += "- Update all_spell_implementations.json with missing entries\n"
        summary += "- Re-run this merge script\n"
    else:
        summary += "- Review ABILITIES_COMPLETE.md for accuracy\n"
        summary += "- Validate all formulas against source code\n"
        summary += "- Generate derived documentation (damage tables, skill guides, etc.)\n"

    with open(output_path, 'w') as f:
        f.write(summary)

def main():
    docs_dir = Path('/home/strider/Code/mud/docs')

    print("Reading ABILITIES.md...")
    abilities = parse_abilities_md(docs_dir / 'ABILITIES.md')
    print(f"Found {len(abilities)} abilities")

    print("\nReading all_spell_implementations.json...")
    implementations = parse_implementation_json(docs_dir / 'all_spell_implementations.json')
    print(f"Found {len(implementations)} implementation entries")

    print("\nMerging data...")
    total, with_impl = create_complete_md(
        abilities,
        implementations,
        docs_dir / 'ABILITIES_COMPLETE.md'
    )

    print(f"\n✅ Created ABILITIES_COMPLETE.md")
    print(f"   - {total} total abilities")
    print(f"   - {with_impl} with implementation data ({(with_impl/total*100):.1f}%)")
    print(f"   - {total - with_impl} missing implementation data")

    print("\nCreating summary...")
    create_summary(total, with_impl, docs_dir / 'ABILITIES_COMPLETE_SUMMARY.txt')
    print("✅ Created ABILITIES_COMPLETE_SUMMARY.txt")

if __name__ == '__main__':
    main()
