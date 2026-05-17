#!/usr/bin/env python3
"""One-off seeder for ConsumableEffects.

Walks every Object whose type is POTION / SCROLL / WAND / STAFF and
whose `values` JSON has a `Spells` list, looks up each spell by
`plain_name`, and writes one ConsumableEffects row per (object,
AbilityEffect) pair so the runtime's `spawn_consumable_effect` path
can fire actual effects when a potion is quaffed / a scroll read.

Run via: poetry run python scripts/seed_consumable_effects.py
"""
import asyncio
import os
import sys
from pathlib import Path

# Make fierylib importable without poetry install
sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from prisma import Prisma  # type: ignore


CONSUMABLE_TYPES = {"POTION", "SCROLL", "WAND", "STAFF"}


async def main() -> int:
    db = Prisma()
    await db.connect()
    try:
        return await seed(db)
    finally:
        await db.disconnect()


async def seed(db: Prisma) -> int:
    # Pull every consumable proto with a Spells list. The Prisma JSON
    # filter API is awkward, so we just fetch all candidates and filter
    # in Python — there are <300 of them total.
    objects = await db.objects.find_many(
        where={"type": {"in": list(CONSUMABLE_TYPES)}},
    )
    print(f"  {len(objects)} consumable protos to scan")

    # Build an ability plain_name → [effect_id, ...] map up front so we
    # don't re-fetch per object.
    ability_to_effects: dict[str, list[int]] = {}
    abilities = await db.ability.find_many(
        include={"effects": True},
    )
    for a in abilities:
        ability_to_effects[a.plainName] = [e.effectId for e in (a.effects or [])]

    # Pre-load existing ConsumableEffects so the (object, effect) unique
    # constraint doesn't blow us up on re-runs.
    existing_rows = await db.consumableeffect.find_many(
        where={"objectZoneId": {"not": None}},
    )
    existing_keys: set[tuple[int, int, int]] = {
        (r.objectZoneId, r.objectId, r.effectId)  # type: ignore[arg-type]
        for r in existing_rows
        if r.objectZoneId is not None and r.objectId is not None
    }

    created = 0
    skipped_no_spells = 0
    skipped_unknown_spell: dict[str, int] = {}
    skipped_no_effects: dict[str, int] = {}

    for obj in objects:
        vals = obj.values or {}
        spells = vals.get("Spells") if isinstance(vals, dict) else None
        if not spells or not isinstance(spells, list):
            skipped_no_spells += 1
            continue
        level = vals.get("Level", 1) if isinstance(vals, dict) else 1
        try:
            level_int = int(level)
        except (TypeError, ValueError):
            level_int = 1

        for spell_name in spells:
            if not isinstance(spell_name, str):
                continue
            key = spell_name.upper()
            effect_ids = ability_to_effects.get(key)
            if effect_ids is None:
                skipped_unknown_spell[key] = skipped_unknown_spell.get(key, 0) + 1
                continue
            if not effect_ids:
                skipped_no_effects[key] = skipped_no_effects.get(key, 0) + 1
                continue
            for effect_id in effect_ids:
                k = (obj.zoneId, obj.id, effect_id)
                if k in existing_keys:
                    continue
                try:
                    await db.consumableeffect.create(
                        data={
                            "objectZoneId": obj.zoneId,
                            "objectId": obj.id,
                            "effectId": effect_id,
                            "level": level_int,
                            "chance": 1.0,
                        }
                    )
                    existing_keys.add(k)
                    created += 1
                except Exception as e:
                    print(f"  ERROR creating row for {obj.name} → effect {effect_id}: {e}")

    print(f"  Created {created} ConsumableEffects rows")
    print(f"  Skipped {skipped_no_spells} consumables without a Spells list")
    if skipped_unknown_spell:
        print(f"  Skipped {sum(skipped_unknown_spell.values())} occurrences across "
              f"{len(skipped_unknown_spell)} unknown spells:")
        for name, count in sorted(skipped_unknown_spell.items(), key=lambda kv: -kv[1])[:10]:
            print(f"    {name}: {count}")
    if skipped_no_effects:
        print(f"  Skipped {sum(skipped_no_effects.values())} occurrences across "
              f"{len(skipped_no_effects)} spells with no AbilityEffect rows:")
        for name, count in sorted(skipped_no_effects.items(), key=lambda kv: -kv[1])[:10]:
            print(f"    {name}: {count}")
    return 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
