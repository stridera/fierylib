#!/usr/bin/env python3
"""Generate CSV mapping of all object effects.

Creates multiple CSVs:
- object_spell_effects.csv - Spells on scrolls, potions, wands, staves
- object_types_schema.csv - What effect fields each object type uses
- object_effect_flags.csv - Effect flags found on objects (when imported)
- object_stat_affects.csv - Stat modifiers on equipment (when imported)
"""

import asyncio
import csv
import json
from collections import defaultdict
from pathlib import Path
from prisma import Prisma


# Object types that can have spell effects
SPELL_ITEM_TYPES = {"SCROLL", "POTION", "WAND", "STAFF"}

# Legacy AFFECTS to new stat mappings
# AC in legacy = lower is better (like D&D), needs conversion
LEGACY_AFFECT_TO_STAT = {
    "AC": {
        "new_stats": ["eva", "ward"],  # Split based on armor type
        "conversion": "AC_to_defense",  # Conversion function name
        "notes": "Light armor → eva, Heavy armor → ward, Mixed → both",
    },
    "HITROLL": {"new_stats": ["acc"], "conversion": "direct"},
    "DAMROLL": {"new_stats": ["damroll"], "conversion": "direct"},
    "STR": {"new_stats": ["str"], "conversion": "direct"},
    "DEX": {"new_stats": ["dex"], "conversion": "direct"},
    "CON": {"new_stats": ["con"], "conversion": "direct"},
    "INT": {"new_stats": ["int"], "conversion": "direct"},
    "WIS": {"new_stats": ["wis"], "conversion": "direct"},
    "CHA": {"new_stats": ["cha"], "conversion": "direct"},
    "HIT": {"new_stats": ["max_hp"], "conversion": "direct"},
    "MANA": {"new_stats": ["focus"], "conversion": "mana_to_focus", "notes": "Mana removed; spell slots recover via Focus"},
    "MOVE": {"new_stats": ["max_stamina"], "conversion": "direct", "notes": "Renamed to Stamina (movement + physical skills)"},
    "SAVING_PARA": {"new_stats": ["save_para"], "conversion": "negate"},  # Lower = better
    "SAVING_ROD": {"new_stats": ["save_rod"], "conversion": "negate"},
    "SAVING_PETRI": {"new_stats": ["save_petri"], "conversion": "negate"},
    "SAVING_BREATH": {"new_stats": ["save_breath"], "conversion": "negate"},
    "SAVING_SPELL": {"new_stats": ["save_spell"], "conversion": "negate"},
    "SIZE": {"new_stats": ["size"], "conversion": "direct"},
    "FOCUS": {"new_stats": ["focus"], "conversion": "direct"},
    "PERCEPTION": {"new_stats": ["perception"], "conversion": "direct"},
    "HIDDENNESS": {"new_stats": ["stealth"], "conversion": "direct"},
}

# Object type schemas - what values each type can have
OBJECT_TYPE_SCHEMAS = {
    "WEAPON": {
        "effect_fields": ["Hit Dice", "Damage Type", "HitRoll"],
        "description": "Deals damage with dice roll and damage type",
        "idl_mapping": "damage (via weapon attack)",
    },
    "ARMOR": {
        "effect_fields": ["AC"],
        "description": "Provides armor class protection",
        "idl_mapping": "stat_mod (eva/ward based on armor weight)",
        "conversion_notes": "Legacy AC → split to eva (light) or ward (heavy)",
    },
    "SCROLL": {
        "effect_fields": ["Level", "Spells"],
        "description": "Single-use item casting up to 3 spells",
        "idl_mapping": "Linked Ability effects",
    },
    "WAND": {
        "effect_fields": ["Level", "Spell", "Max_Charges", "Charges_Left"],
        "description": "Multi-use item casting one spell with charges",
        "idl_mapping": "Linked Ability effects",
    },
    "STAFF": {
        "effect_fields": ["Level", "Spell", "Max_Charges", "Charges_Left"],
        "description": "Multi-use item casting one spell with charges (area effect)",
        "idl_mapping": "Linked Ability effects",
    },
    "POTION": {
        "effect_fields": ["Level", "Spells"],
        "description": "Single-use consumable casting up to 3 spells on drinker",
        "idl_mapping": "Linked Ability effects (self-target)",
    },
    "LIGHT": {
        "effect_fields": ["Duration"],
        "description": "Provides illumination for duration hours",
        "idl_mapping": "room_effect (light)",
    },
    "CONTAINER": {
        "effect_fields": ["Capacity", "Container_Flags", "Key_Vnum"],
        "description": "Holds other objects, may be locked",
        "idl_mapping": "N/A (storage)",
    },
    "DRINKCONTAINER": {
        "effect_fields": ["Capacity", "Current", "Liquid_Type", "Poisoned"],
        "description": "Holds liquid, may be poisoned",
        "idl_mapping": "status_apply (poison) if poisoned",
    },
    "FOOD": {
        "effect_fields": ["Filling", "Poisoned"],
        "description": "Restores hunger, may be poisoned",
        "idl_mapping": "resource_mod (hunger), status_apply (poison) if poisoned",
    },
    "PORTAL": {
        "effect_fields": ["Destination"],
        "description": "Teleports user to destination room",
        "idl_mapping": "teleport",
    },
    "TRAP": {
        "effect_fields": ["Trap_Type", "Damage", "Trigger"],
        "description": "Deals damage or effect when triggered",
        "idl_mapping": "damage or status_apply",
    },
    "INSTRUMENT": {
        "effect_fields": ["Instrument_Type", "Quality"],
        "description": "Used for bard songs, quality affects performance",
        "idl_mapping": "Enables Ability use (songs)",
    },
    "SPELLBOOK": {
        "effect_fields": ["Spells"],
        "description": "Contains spell pages for learning",
        "idl_mapping": "N/A (learning)",
    },
}

# Weapon damage types
WEAPON_DAMAGE_TYPES = [
    "SLASH", "PIERCE", "BLUDGEON", "POUND", "CLAW", "BITE", "STING",
    "WHIP", "CRUSH", "SHOCK", "FIRE", "COLD", "ACID", "POISON",
]


async def main():
    """Generate object effects mapping CSVs."""
    prisma = Prisma()
    await prisma.connect()

    print("Gathering object effect data...")

    output_dir = Path(__file__).parent.parent / "docs/mapping"
    output_dir.mkdir(parents=True, exist_ok=True)

    # 1. Object spell effects
    await generate_spell_effects_mapping(prisma, output_dir)

    # 2. Object type schemas
    generate_type_schema_mapping(output_dir)

    # 3. Effect flags on objects (if any imported)
    await generate_effect_flags_mapping(prisma, output_dir)

    # 4. Stat affects on objects (if any imported)
    await generate_stat_affects_mapping(prisma, output_dir)

    # 5. Summary by object type
    await generate_object_summary(prisma, output_dir)

    # 6. Legacy stat conversion mapping
    generate_stat_conversion_mapping(output_dir)

    await prisma.disconnect()

    print(f"\nFiles created in: {output_dir}")


async def generate_spell_effects_mapping(prisma: Prisma, output_dir: Path):
    """Generate mapping of spells found on objects."""
    print("\nExtracting spell effects from objects...")

    # Get all spell-casting items
    objects = await prisma.objects.find_many(
        where={"type": {"in": list(SPELL_ITEM_TYPES)}},
        order=[{"zoneId": "asc"}, {"id": "asc"}],
    )

    # Collect spell usage data
    spell_usage = defaultdict(lambda: {"objects": [], "types": set()})

    for obj in objects:
        values = obj.values if obj.values else {}
        if isinstance(values, str):
            values = json.loads(values)

        # Extract spell(s) from values
        spells = []
        if "Spells" in values:
            spells = values["Spells"] if isinstance(values["Spells"], list) else [values["Spells"]]
        elif "Spell" in values:
            spells = [values["Spell"]]

        for spell in spells:
            if spell:
                spell_usage[spell]["objects"].append(obj.name)
                spell_usage[spell]["types"].add(obj.type)

    # Write spell effects CSV
    output_file = output_dir / "object_spell_effects.csv"
    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "Spell",
            "Object_Types",
            "Object_Count",
            "Example_Objects"
        ])

        for spell, data in sorted(spell_usage.items()):
            types_str = ", ".join(sorted(data["types"]))
            examples = data["objects"][:5]
            examples_str = "; ".join(examples)
            if len(data["objects"]) > 5:
                examples_str += f" (+{len(data['objects']) - 5} more)"

            writer.writerow([
                spell,
                types_str,
                len(data["objects"]),
                examples_str
            ])

    print(f"  Created: {output_file}")
    print(f"  Unique spells on objects: {len(spell_usage)}")

    # Print summary by type
    type_counts = defaultdict(int)
    for obj in objects:
        type_counts[obj.type] += 1

    print("\n  Objects with spell effects by type:")
    for obj_type, count in sorted(type_counts.items()):
        print(f"    {obj_type}: {count}")


def generate_type_schema_mapping(output_dir: Path):
    """Generate mapping of object type schemas."""
    print("\nGenerating object type schema mapping...")

    output_file = output_dir / "object_types_schema.csv"
    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "Object_Type",
            "Effect_Fields",
            "Description",
            "IDL_Mapping"
        ])

        for obj_type, schema in sorted(OBJECT_TYPE_SCHEMAS.items()):
            fields_str = ", ".join(schema["effect_fields"])
            writer.writerow([
                obj_type,
                fields_str,
                schema["description"],
                schema["idl_mapping"]
            ])

    print(f"  Created: {output_file}")
    print(f"  Object types with effects: {len(OBJECT_TYPE_SCHEMAS)}")


async def generate_effect_flags_mapping(prisma: Prisma, output_dir: Path):
    """Generate mapping of effect flags found on objects."""
    print("\nChecking for effect flags on objects...")

    # Check if any objects have effect flags
    objects_with_flags = await prisma.objects.find_many(
        where={"effectFlags": {"isEmpty": False}},
        take=100,
    )

    output_file = output_dir / "object_effect_flags.csv"
    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "Effect_Flag",
            "Category",
            "Nature",
            "Object_Count",
            "Example_Objects"
        ])

        if not objects_with_flags:
            # Write header-only file with schema info
            writer.writerow([
                "(No effect flags imported yet)",
                "-",
                "-",
                "0",
                "-"
            ])
            print(f"  Created: {output_file}")
            print("  No objects with effect flags found (not yet imported)")
            return

        # Collect flag usage
        flag_usage = defaultdict(list)
        for obj in objects_with_flags:
            if obj.effectFlags:
                for flag in obj.effectFlags:
                    flag_usage[flag].append(obj.name)

        # Categorize flags
        def categorize_flag(flag: str) -> tuple[str, str]:
            flag_upper = flag.upper()
            # Protection flags
            if flag_upper.startswith("PROTECT_") or flag_upper.startswith("NEGATE_"):
                return "protection", "beneficial"
            # Shields
            if flag_upper in ("FIRESHIELD", "COLDSHIELD", "SOULSHIELD"):
                return "defense", "beneficial"
            # Globes
            if "GLOBE" in flag_upper:
                return "magic_defense", "beneficial"
            # Detection
            if flag_upper.startswith("DETECT_") or flag_upper in ("INFRAVISION", "ULTRAVISION", "FARSEE", "SENSE_LIFE"):
                return "detection", "beneficial"
            # Movement
            if flag_upper in ("FLY", "WATERWALK", "WATERBREATH", "FEATHER_FALL"):
                return "movement", "beneficial"
            # Stealth
            if flag_upper in ("INVISIBLE", "SNEAK", "STEALTH", "CAMOUFLAGED", "SHADOWING"):
                return "stealth", "beneficial"
            # Buffs
            if flag_upper in ("HASTE", "BLUR", "BLESS", "SANCTUARY", "STONE_SKIN", "VITALITY", "GLORY", "AWARE", "BERSERK"):
                return "buff", "beneficial"
            # Debuffs/CC
            if flag_upper in ("BLIND", "CONFUSION", "CURSE", "POISON", "SLEEP", "CHARM", "FEAR", "SILENCE", "DISEASE", "INSANITY"):
                return "debuff", "harmful"
            # Paralysis
            if "PARALYSIS" in flag_upper or flag_upper == "IMMOBILIZED":
                return "crowd_control", "harmful"
            # Weapon enchants
            if flag_upper.endswith("_WEAPON"):
                return "weapon_enchant", "beneficial"
            return "other", "neutral"

        for flag, objects in sorted(flag_usage.items()):
            category, nature = categorize_flag(flag)
            examples = objects[:5]
            examples_str = "; ".join(examples)
            if len(objects) > 5:
                examples_str += f" (+{len(objects) - 5} more)"

            writer.writerow([flag, category, nature, len(objects), examples_str])

    print(f"  Created: {output_file}")
    print(f"  Objects with effect flags: {len(objects_with_flags)}")


async def generate_stat_affects_mapping(prisma: Prisma, output_dir: Path):
    """Generate mapping of stat modifiers on objects."""
    print("\nChecking for stat affects on objects...")

    # Get all object affects
    affects = await prisma.objectaffects.find_many(
        include={"objects": True},
        order=[{"location": "asc"}],
    )

    output_file = output_dir / "object_stat_affects.csv"
    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "Stat_Location",
            "Nature",
            "Object_Count",
            "Modifier_Range",
            "Example_Objects"
        ])

        if not affects:
            writer.writerow([
                "(No stat affects imported yet)",
                "-",
                "0",
                "-",
                "-"
            ])
            print(f"  Created: {output_file}")
            print("  No object affects found (not yet imported)")
            return

        # Collect by location
        location_data = defaultdict(lambda: {"objects": [], "modifiers": []})
        for affect in affects:
            location_data[affect.location]["objects"].append(
                affect.objects.name if affect.objects else "Unknown"
            )
            location_data[affect.location]["modifiers"].append(affect.modifier)

        # Determine nature based on location
        def get_nature(location: str) -> str:
            loc_upper = location.upper()
            # Negative stats are usually penalties
            if "SAVING" in loc_upper:
                return "varies"  # Lower saves are better
            return "varies"

        for location, data in sorted(location_data.items()):
            nature = get_nature(location)
            min_mod = min(data["modifiers"])
            max_mod = max(data["modifiers"])
            mod_range = f"{min_mod} to {max_mod}" if min_mod != max_mod else str(min_mod)

            examples = list(set(data["objects"]))[:5]
            examples_str = "; ".join(examples)
            if len(set(data["objects"])) > 5:
                examples_str += f" (+{len(set(data['objects'])) - 5} more)"

            writer.writerow([location, nature, len(data["objects"]), mod_range, examples_str])

    print(f"  Created: {output_file}")
    print(f"  Total stat affects: {len(affects)}")


async def generate_object_summary(prisma: Prisma, output_dir: Path):
    """Generate summary of objects by type and their effect potential."""
    print("\nGenerating object summary...")

    # Get counts by type
    objects = await prisma.objects.find_many()

    type_counts = defaultdict(int)
    type_with_spells = defaultdict(int)
    type_with_flags = defaultdict(int)

    for obj in objects:
        type_counts[obj.type] += 1

        values = obj.values if obj.values else {}
        if isinstance(values, str):
            values = json.loads(values)

        if values.get("Spells") or values.get("Spell"):
            type_with_spells[obj.type] += 1

        if obj.effectFlags:
            type_with_flags[obj.type] += 1

    output_file = output_dir / "object_effects_summary.csv"
    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "Object_Type",
            "Total_Count",
            "With_Spells",
            "With_Effect_Flags",
            "Has_Schema",
            "IDL_Mapping"
        ])

        for obj_type in sorted(type_counts.keys()):
            schema = OBJECT_TYPE_SCHEMAS.get(obj_type, {})
            writer.writerow([
                obj_type,
                type_counts[obj_type],
                type_with_spells.get(obj_type, 0),
                type_with_flags.get(obj_type, 0),
                "Yes" if schema else "No",
                schema.get("idl_mapping", "-")
            ])

    print(f"  Created: {output_file}")

    # Print summary
    print("\n" + "=" * 60)
    print("Object Effects Summary")
    print("=" * 60)
    total = sum(type_counts.values())
    print(f"  Total objects: {total}")
    print(f"  Objects with spell effects: {sum(type_with_spells.values())}")
    print(f"  Objects with effect flags: {sum(type_with_flags.values())}")

    print("\n  By type (top 10):")
    for obj_type, count in sorted(type_counts.items(), key=lambda x: -x[1])[:10]:
        spells = type_with_spells.get(obj_type, 0)
        flags = type_with_flags.get(obj_type, 0)
        print(f"    {obj_type:20} {count:5} objects ({spells} with spells, {flags} with flags)")


def generate_stat_conversion_mapping(output_dir: Path):
    """Generate mapping of legacy stats to new stat system."""
    print("\nGenerating legacy stat conversion mapping...")

    output_file = output_dir / "legacy_stat_conversion.csv"
    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "Legacy_Stat",
            "New_Stats",
            "Conversion",
            "Notes"
        ])

        for legacy_stat, mapping in sorted(LEGACY_AFFECT_TO_STAT.items()):
            new_stats = ", ".join(mapping["new_stats"])
            conversion = mapping["conversion"]
            notes = mapping.get("notes", "")

            writer.writerow([legacy_stat, new_stats, conversion, notes])

    print(f"  Created: {output_file}")
    print(f"  Legacy stats mapped: {len(LEGACY_AFFECT_TO_STAT)}")

    # Print AC conversion strategy
    print("\n  AC Conversion Strategy:")
    print("    - Light armor (robes, leather): AC → eva (dodge bonus)")
    print("    - Heavy armor (plate, chain): AC → ward (damage reduction)")
    print("    - Shields: AC → ward (block bonus)")
    print("    - Magic items: AC → eva + ward (split based on type)")
    print("    - Legacy AC was 'lower is better', new system is 'higher is better'")
    print("    - Formula: new_defense = -legacy_AC (negate the value)")


if __name__ == "__main__":
    asyncio.run(main())
