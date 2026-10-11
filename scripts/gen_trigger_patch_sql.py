#!/usr/bin/env python3
"""Generate an idempotent SQL patch for trigger scripts changed since a git ref.

The importer is the source of truth for how a .lua file maps onto a Triggers
row (header stripped, body trimmed); this reuses its parser so the patch writes
exactly what a re-import would. Only rows whose body actually changes are
emitted, and the UPDATE skips rows already holding the new body, so rerunning
it is a no-op.

Usage:
    python scripts/gen_trigger_patch_sql.py BASE_REF OUT.sql [--description TEXT] [--guard-md5]

--guard-md5 also requires the row to still hold the BASE_REF body (matched by
md5), so rows since edited in Muditor are not overwritten.
"""

from __future__ import annotations

import argparse
import hashlib
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))

TAG = "$trig$"


def parse(text: str, name: str):
    from fierylib.importers.trigger_importer import parse_lua_trigger_file

    with tempfile.NamedTemporaryFile("w", suffix=".lua", delete=False, encoding="utf-8") as f:
        f.write(text)
        tmp = Path(f.name)
    try:
        return parse_lua_trigger_file(tmp)
    finally:
        tmp.unlink()


def changed_files(base: str) -> list[str]:
    out = subprocess.run(
        ["git", "diff", "--name-only", "--diff-filter=AM", base, "--", "data/triggers"],
        cwd=ROOT, check=True, capture_output=True, text=True,
    ).stdout
    return sorted(p for p in out.splitlines() if p.endswith(".lua"))


def old_text(base: str, path: str) -> str | None:
    r = subprocess.run(["git", "show", f"{base}:{path}"], cwd=ROOT, capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None


def build(base: str, description: str, guard_md5: bool = False) -> str:
    rows = []
    for path in changed_files(base):
        new = parse((ROOT / path).read_text(encoding="utf-8"), path)
        old_src = old_text(base, path)
        if old_src is not None and parse(old_src, path).commands == new.commands:
            continue  # header-only change: nothing in the Triggers row moves
        if TAG in new.commands:
            raise SystemExit(f"{path}: body contains the {TAG} dollar-quote tag")
        old_md5 = None
        if guard_md5:
            if old_src is None:
                raise SystemExit(f"{path}: --guard-md5 needs an existing body at {base}")
            old_md5 = hashlib.md5(parse(old_src, path).commands.encode("utf-8")).hexdigest()
        rows.append((new.zone_id, new.local_id, new.commands, path, old_md5))
    if not rows:
        return "-- no trigger bodies changed\n"
    values = ",\n".join(
        f"  -- {path}\n  ({z}, {i}, {TAG}{body}{TAG}"
        + (f", '{md5}'" if guard_md5 else "")
        + ")"
        for z, i, body, path, md5 in rows
    )
    guard_cols = ", old_md5" if guard_md5 else ""
    guard_where = "  AND md5(t.commands) = v.old_md5\n" if guard_md5 else ""
    guard_note = (
        "-- Guarded: a row is only touched while it still holds the previous committed\n"
        "-- body (md5), so rows edited in Muditor since then are left alone.\n"
        if guard_md5
        else ""
    )
    return (
        f"-- {description}\n"
        "--\n"
        "-- Idempotent: a row already holding the new body is left alone, so rerunning\n"
        "-- updates nothing. Keyed by the composite primary key (zone_id, id).\n"
        f"{guard_note}\n"
        "BEGIN;\n\n"
        'UPDATE "Triggers" AS t\n'
        "SET commands = v.commands,\n"
        "    updated_at = now()\n"
        "FROM (VALUES\n"
        f"{values}\n"
        f") AS v(zone_id, id, commands{guard_cols})\n"
        "WHERE t.zone_id = v.zone_id\n"
        "  AND t.id = v.id\n"
        f"{guard_where}"
        "  AND t.commands IS DISTINCT FROM v.commands;\n\n"
        "COMMIT;\n"
    )


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("base")
    ap.add_argument("out", type=Path)
    ap.add_argument("--description", default="Trigger script fixes.")
    ap.add_argument("--guard-md5", action="store_true")
    args = ap.parse_args()
    args.out.write_text(build(args.base, args.description, args.guard_md5), encoding="utf-8")
    print(f"wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
