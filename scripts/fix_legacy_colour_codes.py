#!/usr/bin/env python3
"""Convert legacy `&N` colour codes left inside string literals of data/triggers/*.lua.

Two converter defects left them behind:
  * `set var &3&bTEXT&0` assignments never went through the colour converter, so the codes reached
    the player verbatim (519:80 "You are taking lessons on &3&bCOMBAT&0.").
  * the old table read `&b` as blue, so `&9&b` / `&b&9` (bold black) became the stray `&9<blue>` /
    `<blue>&9`, and `&2&b&uTitle` became `<b:green>&uTitle`.
The text is converted the way the importer converts room and mob text
(fierylib.converters.color_converter via dg_to_lua.convert_colors).

Only double-quoted string literals on non-comment lines are touched.

Usage:
    python scripts/fix_legacy_colour_codes.py [--check] [PATH ...]
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))

from fierylib.converters.dg_to_lua import convert_colors  # noqa: E402

STRING_RE = re.compile(r'"((?:[^"\\]|\\.)*)"')
RESIDUE_RE = re.compile(r"&[0-9bud]")


def repair_literal(lit: str) -> str:
    """The body of one Lua string literal with legacy colour residue converted."""
    if not RESIDUE_RE.search(lit):
        return lit
    # `<b:green>&u` is the old `&2&b&u`: bold green underlined.
    lit = re.sub(r"<b:(\w+)>&u", r"<b:u:\1>", lit)
    # `&9<blue>` / `<blue>&9` is the old `&9&b` / `&b&9`: bold black.
    lit = lit.replace("&9<blue>", "<b:black>").replace("<blue>&9", "<b:black>")
    if RESIDUE_RE.search(lit):
        lit = convert_colors(lit, carry=True)
    return lit


def repair_source(src: str) -> str:
    out = []
    for line in src.split("\n"):
        if line.lstrip().startswith("--") or "&" not in line:
            out.append(line)
            continue
        out.append(STRING_RE.sub(lambda m: '"' + repair_literal(m.group(1)) + '"', line))
    return "\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("paths", nargs="*", type=Path, default=[ROOT / "data" / "triggers"])
    ap.add_argument("--check", action="store_true", help="report only, write nothing")
    args = ap.parse_args()
    files: list[Path] = []
    for p in args.paths:
        files += sorted(p.rglob("*.lua")) if p.is_dir() else [p]
    changed = 0
    for f in files:
        src = f.read_text(encoding="utf-8")
        new = repair_source(src)
        if new != src:
            changed += 1
            if not args.check:
                f.write_text(new, encoding="utf-8")
    print(f"files changed: {changed}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
