#!/usr/bin/env python3
"""Generate the object effect-bit mapping repair (data/sql/2026-10-13-object-effect-mapping.sql).

fierymud-rs #151 ("A dagger of ice" shows a permanent Major Globe and no ice attribute).

Root cause: mud.types.object.Object.parse rebuilt the three legacy EFF_* words (FLAGBLOCK_SIZE = 32,
flag N = word N // 32, bit N % 32) as ``eff3 << 26 | eff2 << 13 | eff1`` instead of
``eff3 << 64 | eff2 << 32 | eff1``. Every object with a non-zero second or third word was imported
with wrong effects (the ice dagger's EFF_ICE_WEAPON, bit 85, landed on bit 47 = MAJOR_GLOBE), which fed
the wrong status flags / globes / resistances into ObjectEffects and ObjectResistance (including the
2026-10-08 backfills generated from the same parser).

This script re-reads lib/world/obj/*.obj with the fixed parser, derives per object what the buggy
import produced ("old") and what the correct import produces ("new"), and emits a guarded,
idempotent SQL patch: an object is rewritten only if its current status flags / globe / resistances
still equal the buggy import's output exactly, so Muditor edits survive. Elemental weapons
(EFF_*_WEAPON on a WEAPON) also get weapon_damage_type = the element, but only while it still holds
the legacy physical type.

Usage:
    python scripts/gen_object_effect_mapping_sql.py --lib /path/to/lib [--out PATH]
"""

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from mud.flags import EFFECTS  # noqa: E402
from mud.mudfile import MudData  # noqa: E402
from mud.types.object import Object  # noqa: E402

from fierylib.converters import normalize_flags  # noqa: E402
from fierylib.converters.flag_normalizer import (  # noqa: E402
    OBJECT_STATUS_FLAG_TABLE,
    EFFECT_FLAG_TO_EFFECT_NAME,
    mob_default_status_flags,
    object_globe_circle,
    object_weapon_damage_type,
)
from fierylib.importers.object_importer import EFFECT_TO_RESISTANCE  # noqa: E402

DEFAULT_OUT = Path(__file__).resolve().parent.parent / "data" / "sql" / "2026-10-13-object-effect-mapping.sql"


def buggy_effect_names(names: list[str]) -> list[str]:
    """Effect names the old parser produced for an object whose correct names are `names`."""
    mask = 0
    for n in names:
        mask |= 1 << EFFECTS.index(n)
    words = [(mask >> (32 * i)) & 0xFFFFFFFF for i in range(3)]
    old = (words[2] << 26) | (words[1] << 13) | words[0]
    return [EFFECTS[i] for i in range(len(EFFECTS)) if old >> i & 1]


def derive(effects: list[str]) -> tuple[list[str], int, dict[str, int]]:
    """(status flags, globe circle, {element: pct}) as the importer writes them."""
    effects = normalize_flags(effects)
    flags, _ = mob_default_status_flags(effects, OBJECT_STATUS_FLAG_TABLE)
    best: dict[str, int] = {}
    for name in dict.fromkeys(EFFECT_FLAG_TO_EFFECT_NAME[e] for e in effects if e in EFFECT_FLAG_TO_EFFECT_NAME):
        mapping = EFFECT_TO_RESISTANCE.get(name)
        if mapping and mapping[1] > best.get(mapping[0], 0):
            best[mapping[0]] = mapping[1]
    return sorted(set(flags)), object_globe_circle(effects), best


def collect(lib: Path):
    effect_rows, dmg_rows, failed = [], [], []
    for f in sorted((p for p in lib.glob("world/obj/*.obj") if p.stem.isdigit()), key=lambda p: int(p.stem)):
        zone = int(f.stem)
        try:
            objs = Object.parse(MudData(f.read_text(encoding="latin-1").split("\n")))
        except Exception as e:
            failed.append((f.name, str(e)))
            continue
        for obj in objs:
            oid = obj.id - zone * 100
            new_names = normalize_flags(obj.effects or [])
            old_state = derive(buggy_effect_names(obj.effects or []))
            new_state = derive(new_names)
            if old_state != new_state:
                effect_rows.append((zone, oid, old_state, new_state))
            if (obj.type or "").upper() == "WEAPON":
                element = object_weapon_damage_type(new_names)
                legacy = (obj.values or {}).get("Damage Type")
                if element and legacy and legacy != element:
                    dmg_rows.append((zone, oid, str(legacy), element))
    return effect_rows, dmg_rows, failed


def arr(items: list[str]) -> str:
    return "ARRAY[" + ", ".join(f"'{i}'" for i in items) + "]::text[]"


HEADER = """-- fierymud-rs #151: object effect bits were imported through the wrong word shifts.
--
-- Object.parse rebuilt the legacy EFF_* bitvector as eff3 << 26 | eff2 << 13 | eff1; the legacy
-- words are 32 bits wide (eff3 << 64 | eff2 << 32 | eff1). Objects with a non-zero second / third
-- word got the wrong effects: the "dagger of ice" (EFF_ICE_WEAPON, bit 85) became MAJOR_GLOBE
-- (bit 47) and lost its ice attribute, ~130 other objects got wrong globes, status flags and
-- resistances (the 2026-10-08 object-flag-effects backfills were generated from the same parser).
--
-- 1. {n_effects} objects: the worn `status` flags, `globe` row and ObjectResistance rows are rewritten to what
--    the fixed importer produces. GUARD: only objects whose CURRENT status flags, globe circle and
--    resistances equal the buggy import's output exactly (and whose status row carries nothing but
--    "flags") are touched, so anything edited in Muditor since is left alone.
-- 2. {n_dmg} elemental weapons (EFF_FIRE/ICE/POISON/SHOCK/ACID/RADIANT_WEAPON): weapon_damage_type becomes
--    the element (legacy convert_weapon_damage swaps the damage type for the element), only while it
--    still holds the legacy physical type.
-- Idempotent: after a run the current state equals the new state, never the old one, so a second run
-- changes 0 rows. Keyed by (zone_id, id) only; data only, no DDL.
-- Generated by scripts/gen_object_effect_mapping_sql.py from lib/world/obj/*.obj.

BEGIN;

CREATE TEMP TABLE _oem (
    zone_id int, object_id int,
    old_status text[], old_globe int, old_res jsonb,
    new_status text[], new_globe int, new_res jsonb
) ON COMMIT DROP;

INSERT INTO _oem VALUES
{rows};

-- Objects still exactly as the buggy import left them.
CREATE TEMP TABLE _oem_hit ON COMMIT DROP AS
SELECT m.*
FROM _oem m
JOIN "Objects" o ON o.zone_id = m.zone_id AND o.id = m.object_id
WHERE COALESCE((SELECT array_agg(DISTINCT f ORDER BY f)
                  FROM "ObjectEffects" oe
                  JOIN "Effect" e ON e.id = oe.effect_id AND e.name = 'status'
                  CROSS JOIN LATERAL jsonb_array_elements_text(COALESCE(oe.modifier_data -> 'flags', '[]'::jsonb)) f
                 WHERE oe.object_zone_id = m.zone_id AND oe.object_id = m.object_id), '{{}}'::text[]) = m.old_status
  AND NOT EXISTS (SELECT 1 FROM "ObjectEffects" oe
                    JOIN "Effect" e ON e.id = oe.effect_id AND e.name = 'status'
                   WHERE oe.object_zone_id = m.zone_id AND oe.object_id = m.object_id
                     AND oe.modifier_data - 'flags' <> '{{}}'::jsonb)
  AND COALESCE((SELECT max(oe.strength)
                  FROM "ObjectEffects" oe
                  JOIN "Effect" e ON e.id = oe.effect_id AND e.name = 'globe'
                 WHERE oe.object_zone_id = m.zone_id AND oe.object_id = m.object_id), 0) = m.old_globe
  AND (SELECT count(*) FROM "ObjectEffects" oe
         JOIN "Effect" e ON e.id = oe.effect_id AND e.name = 'globe'
        WHERE oe.object_zone_id = m.zone_id AND oe.object_id = m.object_id) <= 1
  AND COALESCE((SELECT jsonb_object_agg(r.element::text, r.value)
                  FROM "ObjectResistance" r
                 WHERE r.object_zone_id = m.zone_id AND r.object_id = m.object_id), '{{}}'::jsonb) = m.old_res;

DELETE FROM "ObjectEffects" oe
USING _oem_hit h, "Effect" e
WHERE oe.object_zone_id = h.zone_id AND oe.object_id = h.object_id
  AND e.id = oe.effect_id AND e.name IN ('status', 'globe');

DELETE FROM "ObjectResistance" r
USING _oem_hit h
WHERE r.object_zone_id = h.zone_id AND r.object_id = h.object_id;

INSERT INTO "ObjectEffects" (object_zone_id, object_id, effect_id, strength, modifier_data)
SELECT h.zone_id, h.object_id, e.id, 1, jsonb_build_object('flags', to_jsonb(h.new_status))
FROM _oem_hit h
JOIN "Effect" e ON e.name = 'status'
WHERE cardinality(h.new_status) > 0;

INSERT INTO "ObjectEffects" (object_zone_id, object_id, effect_id, strength, modifier_data)
SELECT h.zone_id, h.object_id, e.id, h.new_globe, '{{}}'::jsonb
FROM _oem_hit h
JOIN "Effect" e ON e.name = 'globe'
WHERE h.new_globe > 0;

INSERT INTO "ObjectResistance" (object_zone_id, object_id, element, value, allow_absorption)
SELECT h.zone_id, h.object_id, r.key::"ElementType", r.value::int, false
FROM _oem_hit h
CROSS JOIN LATERAL jsonb_each_text(h.new_res) r;
"""

DMG_SQL = """
-- 2. Elemental weapons: the element replaces the legacy physical damage type.
UPDATE "Objects" o
SET weapon_damage_type = v.element::"DamageType"
FROM (VALUES
{rows}
) AS v(zone_id, object_id, legacy, element)
WHERE o.zone_id = v.zone_id AND o.id = v.object_id
  AND o.type = 'WEAPON'
  AND o.weapon_damage_type = v.legacy::"DamageType";
"""


def render(effect_rows, dmg_rows) -> str:
    rows = ",\n".join(
        f"    ({z}, {i}, {arr(o[0])}, {o[1]}, '{json.dumps(o[2], sort_keys=True)}'::jsonb, "
        f"{arr(n[0])}, {n[1]}, '{json.dumps(n[2], sort_keys=True)}'::jsonb)"
        for z, i, o, n in effect_rows
    )
    out = HEADER.format(rows=rows, n_effects=len(effect_rows), n_dmg=len(dmg_rows))
    if dmg_rows:
        out += DMG_SQL.format(rows=",\n".join(f"    ({z}, {i}, '{lg}', '{el}')" for z, i, lg, el in dmg_rows))
    return out + "\nCOMMIT;\n"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lib", default=str(Path(__file__).resolve().parent.parent.parent / "lib"))
    ap.add_argument("--out", default=str(DEFAULT_OUT))
    args = ap.parse_args()
    effect_rows, dmg_rows, failed = collect(Path(args.lib))
    Path(args.out).write_text(render(effect_rows, dmg_rows))
    print(f"wrote {args.out}: {len(effect_rows)} effect rows, {len(dmg_rows)} weapon damage types")
    for name, err in failed:
        print(f"unparseable {name}: {err}", file=sys.stderr)


if __name__ == "__main__":
    main()
