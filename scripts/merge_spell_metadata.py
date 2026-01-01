#!/usr/bin/env python3
"""
Merge spell metadata from legacy spell_metadata.json into abilities.json.

This script enriches abilities.json with:
- sphere (magic school/element)
- castTimeRounds (corrected from legacy)
- pages (memorization pages)
- damageType (element type)
- wearOffMessage (from legacy)
"""

import json
from pathlib import Path
from typing import Dict, Any, Optional


# Sphere mapping: SKILL_SPHERE_* -> Prisma enum
SPHERE_MAP = {
    "SKILL_SPHERE_FIRE": "FIRE",
    "SKILL_SPHERE_WATER": "WATER",
    "SKILL_SPHERE_EARTH": "EARTH",
    "SKILL_SPHERE_AIR": "AIR",
    "SKILL_SPHERE_HEALING": "HEALING",
    "SKILL_SPHERE_PROT": "PROTECTION",
    "SKILL_SPHERE_ENCHANT": "ENCHANTMENT",
    "SKILL_SPHERE_SUMMON": "SUMMONING",
    "SKILL_SPHERE_DEATH": "DEATH",
    "SKILL_SPHERE_DIVIN": "DIVINATION",
    "SKILL_SPHERE_GENERIC": "GENERIC",
}

# Damage type mapping: DAM_* -> Prisma ElementType enum
DAMAGE_TYPE_MAP = {
    "DAM_FIRE": "FIRE",
    "DAM_COLD": "COLD",
    "DAM_SHOCK": "SHOCK",
    "DAM_ACID": "ACID",
    "DAM_POISON": "POISON",
    "DAM_HEAL": "HEAL",
    "DAM_SLASH": "SLASH",
    "DAM_PIERCE": "PIERCE",
    "DAM_CRUSH": "CRUSH",
    "DAM_MENTAL": "MENTAL",
    "DAM_ALIGN": "HOLY",
    "DAM_UNDEFINED": None,
}


def normalize_name(name: str) -> str:
    """Normalize spell name for matching."""
    return name.lower().replace("_", " ").replace("-", " ").strip()


# Manual name mappings for spells with different names
NAME_ALIASES = {
    "blur": "minor blurring",
    "comprehend lang": "comprehend languages",
    "curse": "bestow curse",
    "recall": "word of recall",
    "relocate": "dimension door",
    "resurrect": "resurrection",
    "statue": "stone skin",  # May need verification
}


def map_sphere(legacy_sphere: str) -> Optional[str]:
    """Map legacy sphere to Prisma enum."""
    return SPHERE_MAP.get(legacy_sphere)


def map_damage_type(legacy_damage: str) -> Optional[str]:
    """Map legacy damage type to Prisma enum."""
    return DAMAGE_TYPE_MAP.get(legacy_damage)


def load_spell_metadata(metadata_path: Path) -> Dict[str, Any]:
    """Load spell metadata and index by normalized name."""
    with open(metadata_path) as f:
        raw_data = json.load(f)

    indexed = {}
    for spell_id, spell_data in raw_data.items():
        name = normalize_name(spell_data.get("name", ""))
        if name:
            indexed[name] = spell_data
            enum_name = spell_data.get("enumName", "")
            if enum_name:
                plain = enum_name.replace("SPELL_", "").replace("SKILL_", "").lower()
                indexed[plain] = spell_data

    return indexed


def merge_abilities(
    abilities_path: Path,
    metadata_path: Path,
    output_path: Optional[Path] = None,
    dry_run: bool = False,
) -> Dict[str, int]:
    """Merge spell metadata into abilities.json."""

    stats = {
        "total_abilities": 0,
        "matched": 0,
        "sphere_added": 0,
        "cast_time_updated": 0,
        "pages_added": 0,
        "damage_type_added": 0,
        "wear_off_added": 0,
        "not_matched": 0,
    }

    with open(abilities_path) as f:
        abilities = json.load(f)

    metadata = load_spell_metadata(metadata_path)

    print(f"Loaded {len(abilities)} abilities")
    print(f"Loaded {len(metadata)} spell metadata entries")

    unmatched = []

    for ability in abilities:
        stats["total_abilities"] += 1

        ability_type = ability.get("abilityType", "")
        if ability_type != "SPELL":
            continue

        name = ability.get("name", "")
        plain_name = ability.get("plainName", "")
        normalized_name = normalize_name(name)
        normalized_plain = normalize_name(plain_name)

        spell_meta = metadata.get(normalized_name) or metadata.get(normalized_plain)

        # Try alias lookup if not found
        if not spell_meta:
            alias = NAME_ALIASES.get(normalized_name)
            if alias:
                spell_meta = metadata.get(alias)

        if not spell_meta:
            stats["not_matched"] += 1
            unmatched.append(name)
            continue

        stats["matched"] += 1

        # Merge sphere
        if not ability.get("sphere"):
            legacy_sphere = spell_meta.get("sphere")
            if legacy_sphere:
                mapped = map_sphere(legacy_sphere)
                if mapped:
                    ability["sphere"] = mapped
                    stats["sphere_added"] += 1

        # Update castTimeRounds
        legacy_cast_time = spell_meta.get("castTimeRounds")
        if legacy_cast_time is not None:
            current = ability.get("castTimeRounds")
            if current != legacy_cast_time:
                ability["castTimeRounds"] = legacy_cast_time
                stats["cast_time_updated"] += 1

        # Merge pages
        if not ability.get("pages"):
            legacy_pages = spell_meta.get("pages")
            if legacy_pages:
                ability["pages"] = legacy_pages
                stats["pages_added"] += 1

        # Merge damageType
        if not ability.get("damageType"):
            legacy_damage = spell_meta.get("damageType")
            if legacy_damage and legacy_damage != "DAM_UNDEFINED":
                mapped = map_damage_type(legacy_damage)
                if mapped:
                    ability["damageType"] = mapped
                    stats["damage_type_added"] += 1

        # Merge wearOffMessage
        wear_off = spell_meta.get("wearOffMessage")
        if wear_off:
            messages = ability.get("messages", {})
            if not messages.get("wearoffToTarget"):
                messages["wearoffToTarget"] = wear_off
                ability["messages"] = messages
                stats["wear_off_added"] += 1

    if unmatched:
        print(f"\nUnmatched spells ({len(unmatched)}):")
        for name in sorted(unmatched)[:20]:
            print(f"  - {name}")
        if len(unmatched) > 20:
            print(f"  ... and {len(unmatched) - 20} more")

    if not dry_run:
        out_path = output_path or abilities_path
        with open(out_path, "w") as f:
            json.dump(abilities, f, indent=2)
        print(f"\nSaved to {out_path}")

    return stats


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Merge spell metadata into abilities.json")
    parser.add_argument(
        "--abilities",
        type=Path,
        default=Path(__file__).parent.parent / "data" / "abilities.json",
        help="Path to abilities.json",
    )
    parser.add_argument(
        "--metadata",
        type=Path,
        default=Path(__file__).parent.parent.parent / "fierymud" / "docs" / "reference" / "spell_metadata.json",
        help="Path to spell_metadata.json",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Output path (defaults to overwriting abilities.json)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would change without modifying files",
    )

    args = parser.parse_args()

    print("=" * 60)
    print("Merging Spell Metadata into Abilities")
    print("=" * 60)

    if args.dry_run:
        print("\n*** DRY RUN - No files will be modified ***\n")

    stats = merge_abilities(
        args.abilities,
        args.metadata,
        args.output,
        args.dry_run,
    )

    print("\n" + "=" * 60)
    print("Summary")
    print("=" * 60)
    print(f"  Total abilities:     {stats['total_abilities']}")
    print(f"  Matched spells:      {stats['matched']}")
    print(f"  Sphere added:        {stats['sphere_added']}")
    print(f"  Cast time updated:   {stats['cast_time_updated']}")
    print(f"  Pages added:         {stats['pages_added']}")
    print(f"  Damage type added:   {stats['damage_type_added']}")
    print(f"  Wear off msg added:  {stats['wear_off_added']}")
    print(f"  Not matched:         {stats['not_matched']}")


if __name__ == "__main__":
    main()
