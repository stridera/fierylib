#!/usr/bin/env python3
"""Wire per-color recall scrolls to their bound temple destinations.

Legacy `spec_procs.cpp::do_recall` mapped each scroll vnum to a
per-class destination room with a fallback to that color's "default
temple". The Rust runtime models this as one ability per color, each
with a teleport AbilityEffect overriding ``destination=room`` and
``destination_zone`` / ``destination_id`` to the temple. Per-class
nuance is a later layer (it can ride on top by branching at the
runtime teleport arm when ``destination=room_by_class`` lands).

This seeder:

1. Upserts four abilities: ``RECALL_RED``, ``RECALL_GREEN``,
   ``RECALL_BLUE``, ``RECALL_GRAY``.
2. Binds the shared ``teleport`` Effect to each, with override
   params pointing at the right temple.
3. Re-targets each ObjectAbilities row on the colored scrolls to
   the new per-color ability (replacing the generic ``RECALL``).
4. Updates the scroll's ``values.Spells`` for builder visibility
   so Muditor shows ``RECALL_GREEN`` etc. instead of ``RECALL``.

Idempotent — runs are safe to repeat. Per data-over-code: builders
can edit the destination by tweaking the ability's override_params
row in Muditor without a recompile.

Run via: poetry run python scripts/seed_recall_scrolls.py
"""
import asyncio
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from prisma import Prisma  # type: ignore
from prisma.errors import RecordNotFoundError  # type: ignore


# (color → (object_zone_id, object_id, destination_zone, destination_id, label))
COLOR_SCROLLS = [
    # red  → Gate of Anduin
    ("RED",   30,  56,  60,   1, "Gate of Anduin"),
    # green → The Altar to Mielikki
    ("GREEN", 30,  57,  30,   2, "The Altar to Mielikki"),
    # blue  → The Arctic Temple Altar (Ickle)
    ("BLUE",  30,  58, 100,   1, "The Arctic Temple Altar (Ickle)"),
    # gray  → Town Center of Mistweave (zone 300 default; legacy gray
    # fallback chain bottoms out at Anduin (6001) when the per-class
    # guild room is missing — we use Mistweave's town center because
    # that's the natural "default temple" for gray scrolls in that
    # city).
    ("GRAY", 300,  10, 300,   1, "Mistweave Town Center"),
]


async def main() -> int:
    db = Prisma()
    await db.connect()
    try:
        return await seed(db)
    finally:
        await db.disconnect()


async def upsert_color_ability(
    db: Prisma,
    base: dict,
    color: str,
    dest_zone: int,
    dest_id: int,
    label: str,
    teleport_effect_id: int,
) -> int:
    """Upsert the per-color ability + its teleport AbilityEffect.

    Returns the ability id.
    """
    plain = f"RECALL_{color}"
    name = f"Recall ({color.title()})"

    found = await db.ability.find_first(where={"plainName": plain})
    if found is None:
        created = await db.ability.create(
            data={
                "name": name,
                "plainName": plain,
                "description": f"Whisks the caster to {label}.",
                "abilityType": base["abilityType"],
                "minPosition": base["minPosition"],
                "violent": False,
                "castTimeRounds": base["castTimeRounds"],
                "cooldownMs": base["cooldownMs"],
                "inCombatOnly": False,
                "combatOk": base["combatOk"],
                "isArea": False,
                "targetScope": base["targetScope"],
                "isMagical": base["isMagical"],
                "isToggle": False,
                "memorizationTime": base["memorizationTime"],
                "questOnly": False,
                "humanoidOnly": False,
                "contestedVisibility": False,
            }
        )
        ability_id = created.id
        print(f"  created ability {plain} #{ability_id}")
    else:
        ability_id = found.id
        print(f"  found ability {plain} #{ability_id}")

    # Upsert the teleport effect binding for this ability. The unique
    # key on AbilityEffect is (ability_id, effect_id, order) — using
    # order=0 by convention for a single-effect ability.
    override = {
        "type": "self",
        "scope": "self",
        "destination": "room",
        "destination_zone": dest_zone,
        "destination_id": dest_id,
        "restrictions": [],
    }
    override_json = json.dumps(override)
    existing_link = await db.abilityeffect.find_first(
        where={"abilityId": ability_id, "effectId": teleport_effect_id},
    )
    if existing_link is None:
        await db.abilityeffect.create(
            data={
                "abilityId": ability_id,
                "effectId": teleport_effect_id,
                "order": 0,
                "overrideParams": override_json,
                "chancePct": 100,
            }
        )
        print(f"    linked teleport effect → ({dest_zone}, {dest_id})")
    else:
        await db.abilityeffect.update(
            where={
                "abilityId_effectId_order": {
                    "abilityId": ability_id,
                    "effectId": teleport_effect_id,
                    "order": existing_link.order,
                }
            },
            data={"overrideParams": override_json, "chancePct": 100},
        )
        print(f"    refreshed teleport effect → ({dest_zone}, {dest_id})")

    return ability_id


async def seed(db: Prisma) -> int:
    # Look up the generic RECALL ability so we can copy its
    # cast_time / memorization / etc. into the per-color variants.
    recall = await db.ability.find_first(where={"plainName": "RECALL"})
    if recall is None:
        print("ERROR: generic RECALL ability missing — re-run magic_system_importer first.")
        return 1
    base = {
        "abilityType": recall.abilityType,
        "minPosition": recall.minPosition,
        "castTimeRounds": recall.castTimeRounds,
        "cooldownMs": recall.cooldownMs,
        "combatOk": recall.combatOk,
        "targetScope": recall.targetScope,
        "isMagical": recall.isMagical,
        "memorizationTime": recall.memorizationTime,
    }

    # Effects come from a stable seeder ID so look up by name. The
    # canonical teleport row is named "teleport" (lowercase) in the
    # current schema.
    tp_effect = await db.effect.find_first(where={"name": "teleport"})
    if tp_effect is None:
        print("ERROR: teleport Effect row missing — re-run effects seeder first.")
        return 1
    print(f"using teleport effect #{tp_effect.id}")

    color_to_ability: dict[str, int] = {}
    for color, _oz, _oi, dz, di, label in COLOR_SCROLLS:
        ability_id = await upsert_color_ability(
            db, base, color, dz, di, label, tp_effect.id
        )
        color_to_ability[color] = ability_id

    # Re-target each color scroll's ObjectAbilities row(s). Delete
    # existing rows on the scroll, then create one row pointing at
    # the per-color ability. Also patch values.Spells for builder
    # visibility so Muditor shows the per-color spell name.
    for color, oz, oi, _dz, _di, label in COLOR_SCROLLS:
        # Ensure the proto exists.
        try:
            proto = await db.objects.find_unique(
                where={"zoneId_id": {"zoneId": oz, "id": oi}}
            )
        except RecordNotFoundError:
            proto = None
        if proto is None:
            print(f"  skipping ({oz}, {oi}) {color}: object missing")
            continue

        ability_id = color_to_ability[color]

        # Drop any existing bindings on this scroll, then create
        # exactly one pointing at the per-color ability.
        await db.objectabilities.delete_many(
            where={"objectZoneId": oz, "objectId": oi}
        )
        await db.objectabilities.create(
            data={
                "objectZoneId": oz,
                "objectId": oi,
                "abilityId": ability_id,
                "level": 1,
                "charges": None,
            }
        )

        # Patch values.Spells so Muditor surfaces the per-color name.
        vals = dict(proto.values or {})
        spell_list = vals.get("Spells") if isinstance(vals, dict) else None
        new_list = [f"RECALL_{color}"]
        if spell_list != new_list:
            vals["Spells"] = new_list
            await db.objects.update(
                where={"zoneId_id": {"zoneId": oz, "id": oi}},
                data={"values": json.dumps(vals)},
            )
        print(f"  rebound ({oz}, {oi}) {proto.name} → RECALL_{color} ({label})")

    # ConsumableEffects rows seeded by `seed_consumable_effects.py`
    # still point at the generic RECALL's teleport effect. Recompute
    # the rows for the colored scrolls so the consumable path picks
    # up the per-color destination.
    print("\nRefreshing ConsumableEffects rows for colored scrolls…")
    for color, oz, oi, _dz, _di, _label in COLOR_SCROLLS:
        ability_id = color_to_ability[color]
        # Pull the new ability's effect ids.
        new_effects = await db.abilityeffect.find_many(
            where={"abilityId": ability_id}
        )
        effect_ids = [e.effectId for e in new_effects]
        # Drop old rows for the scroll, repopulate from the new
        # ability's effects.
        await db.consumableeffect.delete_many(
            where={"objectZoneId": oz, "objectId": oi}
        )
        for eid in effect_ids:
            await db.consumableeffect.create(
                data={
                    "objectZoneId": oz,
                    "objectId": oi,
                    "effectId": eid,
                    "level": 1,
                    "chance": 1.0,
                }
            )
        print(f"  refreshed ConsumableEffects ({oz}, {oi}) → {len(effect_ids)} effect row(s)")

    print("\nDone.")
    return 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
