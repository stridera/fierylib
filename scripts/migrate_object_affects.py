"""One-shot migration: ObjectAffects → ObjectEffects (modifier-style).

Wave 3.4 of the combat redesign retires the legacy `(location, modifier)`
ObjectAffects table. Each row is mapped to a new ObjectEffects row that
references the "modify" Effect with `modifier_data = {"target": "<key>",
"amount": <signed_int>}`. The runtime equip-apply path reads the modify
effects, branches on `effectType == "modify"`, and routes through
`apply_modify_delta(target, amount)`.

Mapping table (from parking-lot.md, approved 2026-05-12):

  Legacy location          → target,        amount transform
  ------------------------------------------------------------------
  HITROLL                  → accuracy,      modifier * 2
  DAMROLL                  → attack_power,  modifier * 5
  AC                       → armor_pct,     -modifier * 5  (legacy AC inverted)
  ACCURACY                 → accuracy,      modifier
  ATTACK_POWER             → attack_power,  modifier
  SPELL_POWER              → spell_power,   modifier
  EVASION                  → evasion,       modifier
  ARMOR_RATING             → armor_pct,     modifier
  HARDNESS                 → hardness,      modifier
  WARD_PCT                 → ward_pct,      modifier
  PEN_FLAT                 → pen_flat,      modifier
  PEN_PCT                  → pen_pct,       modifier
  SOAK                     → armor_flat,    modifier  (renamed)
  STR/DEX/CON/INT/WIS/CHA  → <stat>_bonus,  modifier
  HIT / MAX_HP             → max_hp,        modifier
  MOVE / MAX_MOVEMENT      → stamina_max,   modifier
  FOCUS                    → focus_bonus,   modifier  (only if such a stat exists)
  Everything else          → SKIPPED (logged)

NOTE: requires the ObjectEffects `(object_zone_id, object_id, effect_id)`
unique constraint to be dropped first — multiple "modify" rows per
object are legitimate (e.g. an item granting both STR+5 and DEX+3).
"""

import argparse
import json
import os
import sys
from collections import defaultdict
from typing import Optional

import psycopg2
from dotenv import load_dotenv

load_dotenv()


# Direct map from legacy `location` text to the new target string.
# A `None` value means "explicit skip" (cosmetic / dropped concept).
# Absent keys fall through to the "unknown — skip + log" path.
DIRECT_TARGET: dict[str, Optional[str]] = {
    # Combat stats — modern direct names (no scale)
    "ACCURACY": "accuracy",
    "ATTACK_POWER": "attack_power",
    "SPELL_POWER": "spell_power",
    "EVASION": "evasion",
    "ARMOR_RATING": "armor_pct",
    "HARDNESS": "hardness",
    "WARD_PCT": "ward_pct",
    "WARD": "ward_pct",
    "PEN_FLAT": "pen_flat",
    "PEN_PCT": "pen_pct",
    "SOAK": "armor_flat",  # rename
    # Core stats
    "STR": "str_bonus",
    "DEX": "dex_bonus",
    "CON": "con_bonus",
    "INT": "int_bonus",
    "WIS": "wis_bonus",
    "CHA": "cha_bonus",
    # Pools
    "HIT": "max_hp",
    "MAX_HP": "max_hp",
    "MOVE": "stamina_max",
    "MAX_MOVEMENT": "stamina_max",
    # Stretch / unsure-but-keep
    "FOCUS": "focus",
    "PERCEPTION": "perception",
    "HIT_REGEN": "hit_regen",
    "HIDDENNESS": "hiddenness",
    # Explicit skips (no modern equivalent)
    "MANA": None,
    "MAX_MANA": None,
    "AGE": None,
    "CHAR_WEIGHT": None,
    "CHAR_HEIGHT": None,
    "SAVING_PARA": None,
    "SAVING_ROD": None,
    "SAVING_PETRI": None,
    "SAVING_BREATH": None,
    "SAVING_SPELL": None,
    "COMPOSITION": None,
}

# Scaling rules for legacy CircleMUD names (target, scale).
LEGACY_SCALED: dict[str, tuple[str, int]] = {
    "HITROLL": ("accuracy", 2),
    "DAMROLL": ("attack_power", 5),
}


def map_row(location: str, modifier: int) -> tuple[Optional[str], int, str]:
    """Return (target, amount, reason). target=None means skip."""
    loc = location.upper()
    if loc == "AC":
        # Per parking-lot table: legacy AC inverted, scale * 5.
        return ("armor_pct", -modifier * 5, "legacy AC inverted")
    if loc in LEGACY_SCALED:
        target, scale = LEGACY_SCALED[loc]
        return (target, modifier * scale, f"legacy {loc} scaled x{scale}")
    if loc in DIRECT_TARGET:
        target = DIRECT_TARGET[loc]
        if target is None:
            return (None, 0, f"explicit skip ({loc} has no modern equivalent)")
        return (target, modifier, "direct mapping")
    return (None, 0, f"unknown location {loc!r}")


def find_modify_effect_id(cur) -> Optional[int]:
    """Look up the singleton 'modify' Effect row's id."""
    cur.execute(
        "SELECT id FROM \"Effect\" WHERE \"effectType\" = 'modify' "
        "ORDER BY id ASC LIMIT 1"
    )
    row = cur.fetchone()
    return row[0] if row else None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Plan the migration; print counts but make no writes.",
    )
    args = parser.parse_args()

    db_url = os.environ.get("DATABASE_URL")
    if not db_url:
        print("ERROR: DATABASE_URL is unset.", file=sys.stderr)
        return 1

    conn = psycopg2.connect(db_url)
    try:
        cur = conn.cursor()

        modify_effect_id = find_modify_effect_id(cur)
        if modify_effect_id is None:
            print(
                "ERROR: no Effect row found with effectType='modify'. Aborting.\n"
                "Seed the 'modify' effect first (effects seeder or manual insert).",
                file=sys.stderr,
            )
            return 2
        print(f"Found 'modify' Effect id = {modify_effect_id}")

        cur.execute(
            'SELECT object_zone_id, object_id, location, modifier '
            'FROM "ObjectAffects" ORDER BY id ASC'
        )
        rows = cur.fetchall()
        print(f"Loaded {len(rows)} ObjectAffects rows")

        # Per-(object, target) accumulation: two HITROLL+1 rows on the
        # same object sum into one HITROLL+2 ObjectEffects row.
        accumulator: dict[tuple[int, int, str], int] = defaultdict(int)
        skip_by_loc: dict[str, int] = defaultdict(int)
        skipped = 0

        for zone_id, obj_id, location, modifier in rows:
            target, amount, _reason = map_row(location, modifier)
            if target is None:
                skipped += 1
                skip_by_loc[location.upper()] += 1
                continue
            if amount == 0:
                skipped += 1
                skip_by_loc[f"{location.upper()} (zero delta)"] += 1
                continue
            accumulator[(zone_id, obj_id, target)] += amount

        print("\nMapping plan:")
        print(f"  Unique (object, target) tuples to write: {len(accumulator)}")
        print(f"  Rows skipped: {skipped}")
        if skip_by_loc:
            print("  Skip breakdown:")
            for loc, count in sorted(skip_by_loc.items(), key=lambda x: -x[1]):
                print(f"    {loc}: {count}")

        if args.dry_run:
            print("\n[dry-run] No writes performed. Re-run without --dry-run to apply.")
            return 0

        # Build insert list (skip zero-net accumulator entries).
        data_rows = [
            (zone_id, obj_id, modify_effect_id, 1, json.dumps({"target": target, "amount": total}))
            for (zone_id, obj_id, target), total in accumulator.items()
            if total != 0
        ]
        print(f"\nInserting {len(data_rows)} ObjectEffects rows...")

        migrated = 0
        errored = 0
        for params in data_rows:
            try:
                cur.execute(
                    'INSERT INTO "ObjectEffects" '
                    '(object_zone_id, object_id, effect_id, strength, modifier_data) '
                    'VALUES (%s, %s, %s, %s, %s::jsonb)',
                    params,
                )
                migrated += 1
            except Exception as e:
                errored += 1
                conn.rollback()  # roll back the failed insert only
                target_label = json.loads(params[4])["target"]
                print(
                    f"  ERROR inserting (zone={params[0]}, id={params[1]}, "
                    f"target={target_label}): {e}",
                    file=sys.stderr,
                )
            else:
                conn.commit()

        print("\nResults:")
        print(f"  Migrated: {migrated}")
        print(f"  Skipped:  {skipped}")
        print(f"  Errored:  {errored}")
        print(f"  Source rows: {len(rows)}")
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    sys.exit(main())
