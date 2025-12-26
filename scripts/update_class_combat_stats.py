#!/usr/bin/env python3
"""
Updates classes.json with combat modifier fields for each class.
Run from fierylib directory: python scripts/update_class_combat_stats.py
"""

import json
from pathlib import Path

# Combat stats for each class by plainName
# Format: (bonusHitroll, bonusDamroll, hpPerLevel, thac0PerLevel, primaryStat, hitDice)
CLASS_COMBAT_STATS = {
    # Pure melee fighters - best combat stats
    "Warrior": (2, 2, 14, 1.0, "STR", "1d12"),
    "Berserker": (3, 2, 14, 1.0, "STR", "1d12"),  # Berserkers hit harder
    "Mercenary": (2, 2, 12, 1.0, "STR", "1d10"),

    # Warrior hybrids - good combat stats
    "Paladin": (2, 1, 12, 0.9, "STR", "1d10"),
    "Anti-Paladin": (2, 2, 12, 0.9, "STR", "1d10"),
    "Ranger": (1, 1, 10, 0.85, "DEX", "1d10"),
    "Hunter": (1, 2, 10, 0.85, "DEX", "1d10"),

    # Martial artists
    "Monk": (2, 1, 10, 0.9, "DEX", "1d8"),

    # Rogues - moderate combat
    "Thief": (1, 1, 8, 0.75, "DEX", "1d6"),
    "Rogue": (1, 1, 8, 0.75, "DEX", "1d6"),
    "Assassin": (2, 2, 8, 0.8, "DEX", "1d6"),  # Better at killing

    # Bard - hybrid performer
    "Bard": (1, 0, 8, 0.7, "CHA", "1d8"),

    # Divine casters - better HP than arcane
    "Cleric": (0, 0, 8, 0.6, "WIS", "1d8"),
    "Priest": (0, 0, 8, 0.6, "WIS", "1d8"),
    "Druid": (0, 0, 8, 0.65, "WIS", "1d8"),
    "Shaman": (0, 0, 8, 0.6, "WIS", "1d8"),

    # Arcane casters - worst combat
    "Sorcerer": (0, 0, 6, 0.5, "INT", "1d4"),
    "Necromancer": (0, 0, 6, 0.5, "INT", "1d4"),
    "Conjurer": (0, 0, 6, 0.5, "INT", "1d4"),
    "Illusionist": (0, 0, 6, 0.5, "INT", "1d4"),
    "Pyromancer": (0, 0, 6, 0.5, "INT", "1d4"),
    "Cryomancer": (0, 0, 6, 0.5, "INT", "1d4"),

    # Dark casters
    "Diabolist": (0, 0, 6, 0.5, "INT", "1d4"),
    "Mystic": (0, 0, 6, 0.55, "WIS", "1d6"),
}

def update_classes_json(input_path: Path, output_path: Path = None):
    """Update classes.json with combat stats"""
    if output_path is None:
        output_path = input_path

    with open(input_path, 'r') as f:
        data = json.load(f)

    classes = data.get("classes", [])
    updated_count = 0

    for cls in classes:
        plain_name = cls.get("plainName")
        if plain_name is None:
            continue  # Skip null placeholder

        stats = CLASS_COMBAT_STATS.get(plain_name)
        if stats:
            bonus_hr, bonus_dr, hp_lvl, thac0_lvl, primary_stat, hit_dice = stats
            cls["bonusHitroll"] = bonus_hr
            cls["bonusDamroll"] = bonus_dr
            cls["hpPerLevel"] = hp_lvl
            cls["thac0Base"] = 20  # All classes start at 20
            cls["thac0PerLevel"] = thac0_lvl
            cls["primaryStat"] = primary_stat
            cls["hitDice"] = hit_dice
            cls["baseAc"] = 100  # Standard base AC for all
            updated_count += 1
            print(f"  Updated {plain_name}: HR+{bonus_hr} DR+{bonus_dr} HP/lvl={hp_lvl}")
        else:
            print(f"  Warning: No stats defined for {plain_name}")

    # Write back
    with open(output_path, 'w') as f:
        json.dump(data, f, indent=2)

    print(f"\nUpdated {updated_count} classes in {output_path}")


if __name__ == "__main__":
    # Find the data directory
    script_dir = Path(__file__).parent
    data_dir = script_dir.parent / "data"
    classes_json = data_dir / "classes.json"

    if not classes_json.exists():
        print(f"Error: {classes_json} not found")
        exit(1)

    print(f"Updating {classes_json}...")
    update_classes_json(classes_json)
