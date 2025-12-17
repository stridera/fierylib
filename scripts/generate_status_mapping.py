#!/usr/bin/env python3
"""Generate CSV mapping of all status effects.

Creates status_effects_mapping.csv with:
- Status type/flag
- Effect category (crowd_control, status, detection, stealth, movement, protection)
- Nature (beneficial, harmful, neutral)
- Abilities that apply this status
"""

import asyncio
import csv
import json
from pathlib import Path
from prisma import Prisma


# Categorize status effects by nature
HARMFUL_STATUSES = {
    'blind', 'blindness', 'charm', 'confuse', 'confusion', 'fear', 'generic',
    'immobilize', 'insanity', 'mesmerize', 'minor_paralysis', 'major_paralysis',
    'paralysis', 'silence', 'sleep', 'web', 'curse', 'doom', 'poison',
    'disease', 'plague', 'weakness', 'slow', 'vulnerability',
}

BENEFICIAL_STATUSES = {
    'aware', 'berserk', 'bless', 'blur', 'featherfall', 'fly', 'haste',
    'invisible', 'sanctuary', 'waterbreath', 'waterwalk', 'protection',
    'shield', 'armor', 'strength', 'dexterity', 'constitution', 'intelligence',
    'wisdom', 'charisma', 'detect_invisible', 'detect_magic', 'detect_align',
    'infravision', 'sense_life', 'glory', 'nimble', 'invigorate',
}


def get_nature(status_type: str) -> str:
    """Determine if a status effect is beneficial, harmful, or neutral."""
    if not status_type:
        return "unknown"
    status_lower = status_type.lower()
    if status_lower in HARMFUL_STATUSES:
        return "harmful"
    if status_lower in BENEFICIAL_STATUSES:
        return "beneficial"
    return "neutral"


async def main():
    """Generate status effects mapping CSV."""
    prisma = Prisma()
    await prisma.connect()

    print("Gathering status effect data...")

    # Get all abilities with their effects
    abilities = await prisma.ability.find_many(
        include={"effects": {"include": {"effect": True}}},
        order={"name": "asc"}
    )

    # Collect status effects by type
    status_data = {}  # {(category, status_type): [ability_names]}

    for ability in abilities:
        for ae in ability.effects:
            effect = ae.effect
            params = ae.overrideParams if ae.overrideParams else {}
            if isinstance(params, str):
                params = json.loads(params)

            # Determine category and status type based on effect name
            category = None
            status_type = None

            if effect.name == 'crowd_control':
                category = 'crowd_control'
                status_type = params.get('type', 'unknown')
            elif effect.name == 'status':
                category = 'status'
                # Check for flag, type, or status params
                status_type = params.get('flag') or params.get('type') or params.get('status') or 'unknown'
            elif effect.name == 'stealth':
                category = 'stealth'
                status_type = params.get('type', 'invisible')
            elif effect.name == 'detection':
                category = 'detection'
                status_type = params.get('detects', params.get('type', 'unknown'))
            elif effect.name == 'movement':
                category = 'movement'
                status_type = params.get('type', 'unknown')
            elif effect.name == 'protection':
                category = 'protection'
                status_type = params.get('against', params.get('type', 'unknown'))
            elif effect.name == 'vulnerability':
                category = 'vulnerability'
                status_type = params.get('to', params.get('type', 'unknown'))

            if category and status_type:
                key = (category, status_type)
                if key not in status_data:
                    status_data[key] = []
                if ability.name not in status_data[key]:
                    status_data[key].append(ability.name)

    await prisma.disconnect()

    # Create output directory
    output_dir = Path(__file__).parent.parent / "docs/mapping"
    output_dir.mkdir(parents=True, exist_ok=True)

    # Write CSV
    output_file = output_dir / "status_effects_mapping.csv"

    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "Category",
            "Status_Type",
            "Nature",
            "Ability_Count",
            "Abilities"
        ])

        # Sort by category, then status type
        for (category, status_type), ability_names in sorted(status_data.items()):
            nature = get_nature(status_type)
            abilities_str = "; ".join(sorted(set(ability_names)))

            writer.writerow([
                category,
                status_type,
                nature,
                len(set(ability_names)),
                abilities_str
            ])

    print(f"Created: {output_file}")

    # Print summary
    print("\n" + "=" * 60)
    print("Status Effects Summary")
    print("=" * 60)

    categories = {}
    for (cat, _), names in status_data.items():
        if cat not in categories:
            categories[cat] = 0
        categories[cat] += 1

    for cat, count in sorted(categories.items()):
        print(f"  {cat}: {count} types")

    print(f"\n  Total unique status types: {len(status_data)}")

    # Print by category
    for category in sorted(categories.keys()):
        print(f"\n{category.upper()}:")
        for (cat, status_type), names in sorted(status_data.items()):
            if cat == category:
                nature = get_nature(status_type)
                print(f"  {status_type} ({nature}): {len(set(names))} abilities")


if __name__ == "__main__":
    asyncio.run(main())
