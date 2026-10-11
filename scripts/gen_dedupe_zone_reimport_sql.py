#!/usr/bin/env python3
"""Generate data/sql/2026-10-11-dedupe-zone-reimport.sql.

Before the importers cleared a zone first, every `import-legacy --zone N` appended another
copy of the zone's MobResets, ObjectResets, RoomExtraDescriptions and ObjectExtraDescriptions.
The patch removes those extra copies and nothing else.

Resets: legacy genuinely repeats some M/O commands (3 identical guards, 2 identical
objects), so exact-duplicate rows are not enough evidence. This reads lib/world/zon/*.zon
with the importer's own parser and emits

  * legacy_multi(...) - every (zone, mob/object vnum, room vnum, max) that .zon repeats
    n > 1 times. Any other key has n = 1.

A key held m*n times (m >= 2) is a whole number of re-imported copies; a zone qualifies when
>= 90% of its rows sit in such keys (builder-added or import-failed rows don't block it).
Inside a qualifying zone, rows of a multiplied key that are exact duplicates on every
content column are ranked by id and rows beyond rank n are deleted (lowest ids kept). ON DELETE CASCADE removes the
equipment and nested contents of the deleted copies.

Extra descriptions: prod (a clean single import) has zero duplicate groups, so legacy has no
genuine repeats; exact duplicates are collapsed to the lowest id.

Re-running the SQL changes 0 rows.

Usage:
    PYTHONPATH=src python scripts/gen_dedupe_zone_reimport_sql.py [--lib /path/to/lib] [--out PATH]
"""

import argparse
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))

from mud.mudfile import MudData  # noqa: E402
from mud.types.zone import Zone  # noqa: E402

from fierylib.converters import convert_zone_id  # noqa: E402

DEFAULT_OUT = ROOT / "data" / "sql" / "2026-10-11-dedupe-zone-reimport.sql"


def legacy_counts(lib: Path):
    mob: Counter = Counter()
    obj: Counter = Counter()
    mob_zone: Counter = Counter()
    obj_zone: Counter = Counter()
    for f in sorted((lib / "world" / "zon").glob("*.zon")):
        if not f.stem.isdigit():
            continue
        zone = Zone.parse(MudData(f.read_text().split("\n")))
        z = convert_zone_id(int(f.stem))
        for m in zone.resets.get("mob", []):
            mob[(z, m["id"], m["room"], m["max"] if m["max"] > 0 else 999)] += 1
            mob_zone[z] += 1
        for o in zone.resets.get("object", []):
            obj[(z, o["id"], o["room"], o["max"] if o["max"] > 0 else 999)] += 1
            obj_zone[z] += 1
    return mob, mob_zone, obj, obj_zone


def values(rows) -> str:
    return ",\n".join("  (" + ", ".join(str(v) for v in r) + ")" for r in rows)


def reset_block(table: str, ent: str, mob: Counter) -> str:
    multi = sorted((*k, n) for k, n in mob.items() if n > 1)
    mrows = values(multi) if multi else "  (-1, -1, -1, -1, 1)"
    return f"""-- {table}
WITH legacy_multi(zone_id, ent_vnum, room_vnum, max_instances, n) AS (VALUES
{mrows}
),
keyed AS (
  SELECT r.id, r.zone_id,
         r.{ent}_zone_id * 100 + r.{ent}_id AS ent_vnum,
         r.room_zone_id * 100 + r.room_id AS room_vnum,
         r.max_instances,
         COALESCE(lm.n, 1) AS n
  FROM "{table}" r
  LEFT JOIN legacy_multi lm
    ON lm.zone_id = r.zone_id
   AND lm.ent_vnum = r.{ent}_zone_id * 100 + r.{ent}_id
   AND lm.room_vnum = r.room_zone_id * 100 + r.room_id
   AND lm.max_instances = r.max_instances
),
per_key AS (
  SELECT zone_id, ent_vnum, room_vnum, max_instances, n, count(*) AS c
  FROM keyed GROUP BY 1, 2, 3, 4, 5
),
multiplied AS (          -- keys held m*n times, m >= 2: whole copies of the legacy set
  SELECT * FROM per_key WHERE c > n AND c % n = 0
),
zone_ok AS (             -- re-imported zones: ~all of their rows sit in multiplied keys
  SELECT zone_id FROM per_key
  GROUP BY zone_id
  HAVING sum(c) FILTER (WHERE c > n AND c % n = 0) * 10 >= sum(c) * 9
     AND count(*) FILTER (WHERE c > n AND c % n = 0) > 0
),
ranked AS (
  SELECT r.id,
         row_number() OVER (
           PARTITION BY r.zone_id, r.{ent}_zone_id, r.{ent}_id, r.room_zone_id, r.room_id,
                        r.max_instances, r.probability, r.reset_behavior, r.comment
           ORDER BY r.id) AS rn,
         k.n
  FROM "{table}" r
  JOIN keyed k ON k.id = r.id
  JOIN zone_ok z ON z.zone_id = r.zone_id
  JOIN multiplied m
    ON m.zone_id = k.zone_id AND m.ent_vnum = k.ent_vnum
   AND m.room_vnum = k.room_vnum AND m.max_instances = k.max_instances
)
DELETE FROM "{table}" WHERE id IN (SELECT id FROM ranked WHERE rn > n);
"""


def extras_block(table: str, ent: str) -> str:
    return f"""-- {table}
DELETE FROM "{table}" WHERE id IN (
  SELECT id FROM (
    SELECT id, row_number() OVER (
      PARTITION BY {ent}_zone_id, {ent}_id, keywords, description ORDER BY id) AS rn
    FROM "{table}"
  ) t WHERE rn > 1
);
"""


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lib", default="/home/strider/Code/mud/lib")
    ap.add_argument("--out", default=str(DEFAULT_OUT))
    args = ap.parse_args()

    mob, _mz, obj, _oz = legacy_counts(Path(args.lib))
    out = [
        "-- Remove the extra copies left by repeated `import-legacy --zone N` runs.",
        "--",
        "-- Generated by scripts/gen_dedupe_zone_reimport_sql.py from lib/world/zon/*.zon.",
        "-- Reset tables: only keys held m*n times (m >= 2) in zones where >= 90% of rows are such",
        "-- keys; exact duplicates keep the lowest ids, and keys that .zon itself repeats n times keep n. Extra descriptions: exact duplicates collapse to the",
        "-- lowest id (prod has none, so legacy has no genuine repeats). Cascades clear the deleted",
        "-- copies' equipment and contents. A second run deletes 0 rows.",
        "",
        reset_block("MobResets", "mob", mob),
        reset_block("ObjectResets", "object", obj),
        extras_block("RoomExtraDescriptions", "room"),
        extras_block("ObjectExtraDescriptions", "object"),
    ]
    Path(args.out).write_text("\n".join(out))
    print(f"wrote {args.out}: "
          f"{sum(1 for n in mob.values() if n > 1)} repeated mob keys, "
          f"{sum(1 for n in obj.values() if n > 1)} repeated object keys")


if __name__ == "__main__":
    main()
