#!/usr/bin/env python3
"""Generate an idempotent SQL patch for trigger scripts changed since a git ref.

The importer is the source of truth for how a .lua file maps onto a Triggers
row (header stripped, body trimmed); this reuses its parser so the patch writes
exactly what a re-import would. Only rows whose body actually changes are
emitted, and the UPDATE skips rows already holding the new body, so rerunning
it is a no-op.

Usage:
    python scripts/gen_trigger_patch_sql.py BASE_REF OUT.sql [--description TEXT]
"""

from __future__ import annotations

import argparse
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


def build(base: str, description: str) -> str:
    rows = []
    for path in changed_files(base):
        new = parse((ROOT / path).read_text(encoding="utf-8"), path)
        old_src = old_text(base, path)
        if old_src is not None and parse(old_src, path).commands == new.commands:
            continue  # header-only change: nothing in the Triggers row moves
        if TAG in new.commands:
            raise SystemExit(f"{path}: body contains the {TAG} dollar-quote tag")
        rows.append((new.zone_id, new.local_id, new.commands, path))
    if not rows:
        return "-- no trigger bodies changed\n"
    values = ",\n".join(
        f"  -- {path}\n  ({z}, {i}, {TAG}{body}{TAG})" for z, i, body, path in rows
    )
    return (
        f"-- {description}\n"
        "--\n"
        "-- Idempotent: a row already holding the new body is left alone, so rerunning\n"
        "-- updates nothing. Keyed by the composite primary key (zone_id, id).\n\n"
        "BEGIN;\n\n"
        'UPDATE "Triggers" AS t\n'
        "SET commands = v.commands,\n"
        "    updated_at = now()\n"
        "FROM (VALUES\n"
        f"{values}\n"
        ") AS v(zone_id, id, commands)\n"
        "WHERE t.zone_id = v.zone_id\n"
        "  AND t.id = v.id\n"
        "  AND t.commands IS DISTINCT FROM v.commands;\n\n"
        "COMMIT;\n"
    )


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("base")
    ap.add_argument("out", type=Path)
    ap.add_argument("--description", default="Trigger script fixes.")
    args = ap.parse_args()
    args.out.write_text(build(args.base, args.description), encoding="utf-8")
    print(f"wrote {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
