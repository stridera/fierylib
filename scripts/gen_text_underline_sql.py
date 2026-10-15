#!/usr/bin/env python3
"""Generate the legacy `&8` (underline) text repair (data/sql/2026-10-15-text-underline-bg.sql).

The shared importer colour converter (converters/color_converter.py) used to drop `&8`. Legacy
screen.cpp maps both `8` and `u` to AUND (underline), so `&8` now converts to the underline style,
exactly like `&u`. Background codes (`&R &G &Y &B &M &C &W &L &K` -> `<bg-red>` etc.) were already
converted by the shared converter; only `&8` was lost.

This script re-reads lib/world/{wld,mob,obj}/*.{wld,mob,obj}, converts every text field once with
the old behaviour (`&8` dropped) and once with the fixed converter, and emits a guarded UPDATE for
every field where the two differ. A row is rewritten only while it still holds the OLD converted
text, so anything edited in Muditor since the import is left alone, and a rerun matches nothing.

The plain_* columns are untouched: strip_markup removes the tags, so the plain text is the same.

Usage:
    python scripts/gen_text_underline_sql.py --lib /path/to/lib [--out PATH]
"""

from __future__ import annotations

import argparse
import sys
from contextlib import contextmanager
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from mud.mudfile import MudData  # noqa: E402
from mud.types.mob import Mob  # noqa: E402
from mud.types.object import Object  # noqa: E402
from mud.types.world import World  # noqa: E402

from fierylib.converters import color_converter, strip_articles  # noqa: E402
from fierylib.importers.object_importer import ObjectImporter  # noqa: E402

DEFAULT_OUT = Path(__file__).resolve().parent.parent / "data" / "sql" / "2026-10-15-text-underline-bg.sql"
TAG = "$d$"


def lit(text: str) -> str:
    assert TAG not in text, "text contains the dollar-quote tag"
    return f"{TAG}{text}{TAG}"


def new_convert(text: str) -> str:
    return color_converter.convert_legacy_colors(text)


@contextmanager
def _without_eight():
    saved = color_converter.RELATIVE_STYLE_CODES.pop("8")
    try:
        yield
    finally:
        color_converter.RELATIVE_STYLE_CODES["8"] = saved


def old_convert(text: str) -> str:
    """The converter before the fix: `&8` fell through every table and was dropped."""
    with _without_eight():
        return color_converter.convert_legacy_colors(text)


def changed(text: str | None) -> tuple[str, str] | None:
    if not text:
        return None
    old, new = old_convert(text), new_convert(text)
    return (old, new) if old != new else None


def _read(path: Path) -> MudData:
    return MudData(path.read_text(encoding="latin-1").split("\n"))


def _numeric(files):
    return sorted((p for p in files if p.stem.isdigit()), key=lambda p: int(p.stem))


def collect(lib: Path):
    """Return (rows, failed); rows are (table, key tuple, column, old, new)."""
    rows: list[tuple[str, tuple, str, str, str]] = []
    failed: list[tuple[str, str]] = []

    for f in _numeric(lib.glob("world/wld/*.wld")):
        zone = int(f.stem)
        try:
            rooms = World.parse(_read(f))
        except Exception as e:  # noqa: BLE001
            failed.append((f.name, str(e)))
            continue
        for room in rooms:
            rid = int(room["id"]) - zone * 100
            for col, text in (("name", room["name"]), ("room_description", room["description"])):
                if (pair := changed(text)):
                    rows.append(("Room", (zone, rid), col, *pair))
            for extra in room.get("extras") or []:
                if (pair := changed(extra.text)):
                    kws = " ".join(extra.keywords).split()
                    rows.append(("RoomExtraDescriptions", (zone, rid, tuple(kws)), "description", *pair))

    for f in _numeric(lib.glob("world/mob/*.mob")):
        zone = int(f.stem)
        try:
            mobs = Mob.parse(_read(f))
        except Exception as e:  # noqa: BLE001
            failed.append((f.name, str(e)))
            continue
        for mob in mobs:
            mid = mob.id - zone * 100
            if changed(mob.short_desc):
                raise SystemExit(f"mob {zone}:{mid} name uses &8; name/base_name columns are not handled")
            for col, text in (("room_description", mob.long_desc), ("examine_description", mob.desc)):
                if (pair := changed(text)):
                    rows.append(("Mobs", (zone, mid), col, *pair))

    for f in _numeric(lib.glob("world/obj/*.obj")):
        zone = int(f.stem)
        try:
            objs = Object.parse(_read(f))
        except Exception as e:  # noqa: BLE001
            failed.append((f.name, str(e)))
            continue
        for obj in objs:
            oid = obj.id - zone * 100
            if changed(obj.short):
                raise SystemExit(f"object {zone}:{oid} name uses &8; name/base_name columns are not handled")
            for col, text in (("room_description", obj.ground), ("action_desc", obj.action_description)):
                if (pair := changed(text)):
                    rows.append(("Objects", (zone, oid), col, *pair))
            # Same selection as ObjectImporter: the extra matching the object's own keywords is the
            # examine description, the rest are ObjectExtraDescriptions rows.
            obj_kw = [k.lower() for k in (obj.keywords or [])]
            matching, others = [], []
            for extra in obj.extras or []:
                if any(k.lower() in obj_kw for k in extra.keywords or []):
                    matching.append(extra)
                else:
                    others.append(extra)
            selected = None
            preferred = ObjectImporter.EXTRA_DESCRIPTION_OVERRIDES.get((zone, oid))
            if preferred:
                for extra in matching:
                    kws = [k.lower() for k in extra.keywords]
                    if all(p.lower() in kws for p in preferred):
                        selected = extra
                        break
            if selected is None and matching:
                selected = matching[0]
            if selected is not None and (pair := changed(selected.text)):
                rows.append(("Objects", (zone, oid), "examine_description", *pair))
            for extra in others:
                if (pair := changed(extra.text)):
                    rows.append(
                        ("ObjectExtraDescriptions", (zone, oid, tuple(strip_articles(extra.keywords))),
                         "description", *pair)
                    )
    return rows, failed


HEADER = """-- Legacy `&8` is underline (screen.cpp maps '8' and 'u' to AUND). The shared importer colour
-- converter dropped it, so imported room / mob / object text lost the underline.
-- Background codes (&R &G &Y &B &M &C &W &L &K -> <bg-red> etc.) were already converted; none of
-- the imported text needed a change for them.
--
-- {n} text fields: {summary}.
-- plain_* columns are unchanged (the markup is stripped).
--
-- Guarded: a field is rewritten only while it still holds the OLD converted text (`&8` dropped), so
-- text edited in Muditor since the import is left alone. Idempotent: after a run the field holds the
-- new text, so a rerun matches nothing.
-- Generated by scripts/gen_text_underline_sql.py from lib/world/{{wld,mob,obj}}.

BEGIN;
"""

# table -> (zone column, id column or None, id join) used to build the UPDATE
SIMPLE = {
    "Room": ("zone_id", "id"),
    "Mobs": ("zone_id", "id"),
    "Objects": ("zone_id", "id"),
}
EXTRA = {
    "RoomExtraDescriptions": ("room_zone_id", "room_id"),
    "ObjectExtraDescriptions": ("object_zone_id", "object_id"),
}


def _kw(kws) -> str:
    return "ARRAY[" + ", ".join("'" + k.replace("'", "''") + "'" for k in kws) + "]::text[]"


def build(lib: Path) -> str:
    rows, failed = collect(lib)
    for name, err in failed:
        print(f"skipped {name}: {err}", file=sys.stderr)
    out_rows = {}
    for table, key, col, old, new in rows:
        out_rows.setdefault((table, col), []).append((key, old, new))
    summary = ", ".join(f"{t}.{c} x{len(v)}" for (t, c), v in sorted(out_rows.items())) or "none"
    out = [HEADER.format(n=len(rows), summary=summary)]
    for (table, col), items in sorted(out_rows.items()):
        if table in SIMPLE:
            values = ",\n".join(f"  ({k[0]}, {k[1]}, {lit(o)}, {lit(n)})" for k, o, n in items)
            out.append(
                f'\nUPDATE "{table}" AS t\nSET {col} = v.new_txt,\n    updated_at = now()\n'
                f"FROM (VALUES\n{values}\n) AS v(zone_id, id, old_txt, new_txt)\n"
                f"WHERE t.zone_id = v.zone_id AND t.id = v.id\n  AND t.{col} = v.old_txt;\n"
            )
        else:
            zc, ic = EXTRA[table]
            values = ",\n".join(
                f"  ({k[0]}, {k[1]}, {_kw(k[2])}, {lit(o)}, {lit(n)})" for k, o, n in items
            )
            out.append(
                f'\nUPDATE "{table}" AS t\nSET {col} = v.new_txt\n'
                f"FROM (VALUES\n{values}\n) AS v(zone_id, id, kw, old_txt, new_txt)\n"
                f"WHERE t.{zc} = v.zone_id AND t.{ic} = v.id AND t.keywords = v.kw\n"
                f"  AND t.{col} = v.old_txt;\n"
            )
    out.append("\nCOMMIT;\n")
    return "".join(out)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--lib", type=Path, required=True)
    ap.add_argument("--out", type=Path, default=DEFAULT_OUT)
    args = ap.parse_args()
    args.out.write_text(build(args.lib), encoding="utf-8")
    print(f"wrote {args.out}")


if __name__ == "__main__":
    main()
