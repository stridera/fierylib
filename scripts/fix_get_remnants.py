#!/usr/bin/env python3
"""Rewrite raw DG `%get.<func>[VNUM]%` text left inside trigger Lua strings as helper calls.

An older converter left `%get.obj_shortdesc[%necklace%]%` (and mob_shortdesc / obj_noadesc /
obj_pldesc) verbatim inside string literals, so players saw the raw text. This splices them
into the string as `proto_short(necklace)` etc. and adds the local helpers the converter now
emits (fierylib.converters.dg_to_lua.PROTO_HELPERS) after the header comments.

    python scripts/fix_get_remnants.py [--dry-run]
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))

from fierylib.converters.dg_to_lua import PROTO_GET_FUNCS, proto_helper_block  # noqa: E402

STRING = re.compile(r'"(?:[^"\\]|\\.)*"')
GET = re.compile(r"%get\.(\w+)\[(%(\w+)%|(\d+))\]%")


def splice(literal: str) -> str:
    """One `"..."` literal -> a `..` concatenation with the %get.*% pieces as calls."""
    inner = literal[1:-1]
    parts: list[str] = []
    pos = 0
    for m in GET.finditer(inner):
        func = m.group(1)
        if func not in PROTO_GET_FUNCS:
            return literal
        if m.start() > pos:
            parts.append('"' + inner[pos:m.start()] + '"')
        parts.append(f"{PROTO_GET_FUNCS[func]}({m.group(3) or m.group(4)})")
        pos = m.end()
    if pos < len(inner):
        parts.append('"' + inner[pos:] + '"')
    return " .. ".join(parts)


def rewrite_line(line: str) -> str:
    if line.lstrip().startswith("--") or "%get." not in line:
        return line
    return STRING.sub(lambda m: splice(m.group(0)) if "%get." in m.group(0) else m.group(0), line)


def insert_helpers(lines: list[str]) -> list[str]:
    block = proto_helper_block("\n".join(lines))
    if not block:
        return lines
    at = next((i for i, ln in enumerate(lines) if ln.strip() and not ln.lstrip().startswith("--")), len(lines))
    return lines[:at] + block.split("\n") + lines[at:]


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()
    changed = 0
    for path in sorted((ROOT / "data" / "triggers").rglob("*.lua")):
        text = path.read_text(encoding="utf-8")
        if "%get." not in text:
            continue
        lines = [rewrite_line(ln) for ln in text.split("\n")]
        new = "\n".join(insert_helpers(lines))
        if new != text:
            changed += 1
            print(path.relative_to(ROOT))
            if not args.dry_run:
                path.write_text(new, encoding="utf-8")
    print(f"{changed} files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
