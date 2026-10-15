#!/usr/bin/env python3
"""Restore the keyword test on MOB SPEECH / SPEECH_TO scripts that lost it in conversion.

The DG-to-Lua converter only looked for the flag `SPEECH` (a list membership test), so a script whose
flags are `SPEECH_TO` (DG type `n`) got no keyword test and ran on every `say` in the room. The legacy
.trg arg holds the word list (num_arg != 0, word_check) or the phrase (num_arg 0, is_substring); this
script reads it from lib/world/trg and inserts the same test the converter now emits
(dg_to_lua.speech_gate_lines) right after the `-- Original:` header line.

Only MOB scripts whose flags are a subset of {SPEECH, SPEECH_TO, GLOBAL} and whose code never mentions
`speech` are touched. Anything else (WORLD speech, mixed RANDOM+SPEECH, args starting with `*`) is
reported and left alone.

Usage:
    python scripts/fix_speech_keyword_gates.py [--check] [--trg DIR] [PATH ...]
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))
sys.path.insert(0, str(ROOT / "scripts"))

import fix_percent_chance_zero as Z  # noqa: E402
from fierylib.converters.dg_to_lua import speech_gate_lines  # noqa: E402

HEADER_TYPE_RE = re.compile(r"^-- Type: (?P<attach>\w+), Flags: (?P<flags>.*)$", re.M)
ORIGINAL_RE = re.compile(r"^-- Original: [^\n]*\n", re.M)


def code_of(src: str) -> str:
    return "\n".join(ln for ln in src.split("\n") if not ln.lstrip().startswith("--"))


def rewrite(src: str, legacy: dict[int, Z.Legacy]) -> tuple[str, str]:
    """(action, new_src): action is fixed | skip:<why> | none."""
    h = HEADER_TYPE_RE.search(src)
    if h is None:
        return "none", src
    flags = {x.strip() for x in h["flags"].split(",") if x.strip()}
    if not flags & {"SPEECH", "SPEECH_TO"}:
        return "none", src
    if re.search(r"\bspeech\b", code_of(src)):
        return "none", src
    if h["attach"] != "MOB" or not flags <= {"SPEECH", "SPEECH_TO", "GLOBAL"}:
        return "skip:not a plain MOB speech trigger", src
    lg = Z.find_legacy(src, legacy)
    if lg is None:
        return "skip:no legacy source", src
    lines = speech_gate_lines(lg.arg, lg.narg)
    if not lines:
        return "skip:legacy arg is empty or *", src
    m = ORIGINAL_RE.search(src)
    if m is None:
        return "skip:no Original line", src
    return "fixed", src[: m.end()] + "\n".join(lines) + "\n" + src[m.end():]


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("paths", nargs="*", type=Path, default=[ROOT / "data" / "triggers"])
    ap.add_argument("--trg", type=Path, default=None, help="legacy lib/world/trg directory")
    ap.add_argument("--check", action="store_true", help="report only, write nothing")
    args = ap.parse_args()
    trg = args.trg or Z.find_dir("lib", "world", "trg")
    if trg is None:
        sys.exit("lib/world/trg not found; pass --trg")
    legacy = Z.parse_legacy(trg)
    files: list[Path] = []
    for p in args.paths:
        files += sorted(p.rglob("*.lua")) if p.is_dir() else [p]
    fixed = 0
    for f in files:
        src = f.read_text(encoding="utf-8")
        action, out = rewrite(src, legacy)
        if action == "fixed":
            fixed += 1
            if not args.check:
                f.write_text(out, encoding="utf-8")
        elif action.startswith("skip:"):
            print(f"skip: {f.name}: {action[5:]}")
    print(f"fixed: {fixed}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
