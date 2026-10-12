#!/usr/bin/env python3
"""Lowercase the class names fed to string.find() in trigger scripts.

The Lua engine exposes `actor.class` as the LOWERCASE class plain name ("cleric", "anti-paladin",
"priest"). The converter kept the legacy DG spelling, so checks such as

    string.find(actor.class, "Cleric")

never match. Legacy `%actor.class% /= Cleric` was a case-insensitive substring test against the
one-class plain name (CLASS_PLAINNAME, so "Priest" is a real class, not a group), so the faithful
translation is the same substring test with a lowercase needle. Two shapes are rewritten, only
when one argument is a class expression (anything containing `.class`, e.g. `actor.class`,
`tostring(victim.class)`, `string.lower(actor.class or "")`) or a local alias of one (bare or
wrapped, e.g. `tostring(class)`):

  needle form   string.find(<class>, "Cleric")       -> string.find(<class>, "cleric")
  list form     string.find(classes, <class>)        -> string.find(string.lower(classes), <class>, 1, true)
                (a string-literal list is lowercased in place instead of wrapped)

A needle with Lua pattern magic ("Anti-Paladin": `-` is a lazy quantifier) also gets `, 1, true`
so it is matched literally. Calls with extra arguments, a non-literal needle, or comments are left
alone; non-literal needles are reported.

Usage:
    python scripts/fix_class_find_checks.py [--check] [--trg DIR] [PATH ...]
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_TRG = ROOT / "data" / "triggers"

CALL = re.compile(r"\bstring\.find\(")
CLASS_REF = re.compile(r"\.class\b")
COMPARE = re.compile(r"==|~=|<=|>=")
ALIAS = re.compile(r"^\s*(?:local\s+)?([A-Za-z_]\w*)\s*=(?!=)\s*(.+)$")
MAGIC = set("^$()%.[]*+-?")


def class_aliases(text: str) -> set[str]:
    """Names assigned directly from an expression that reads `.class` (not a comparison)."""
    out: set[str] = set()
    for line in text.splitlines():
        if line.lstrip().startswith("--"):
            continue
        m = ALIAS.match(line)
        if not m:
            continue
        rhs = m.group(2)
        if CLASS_REF.search(rhs) and not COMPARE.search(rhs):
            out.add(m.group(1))
    return out


def is_class_expr(arg: str, aliases: set[str]) -> bool:
    arg = arg.strip()
    if COMPARE.search(arg):
        return False
    if re.fullmatch(r"[A-Za-z_]\w*", arg):
        return arg in aliases
    if CLASS_REF.search(arg):
        return True
    # wrapper around an alias, e.g. tostring(class) / string.lower(class or "")
    return any(re.search(rf"(?<![\w.]){re.escape(a)}\b(?!\s*[(=.:\[])", arg) for a in aliases)


def split_call(text: str, open_idx: int):
    """Return ([(start, end) of each top-level arg], close_idx) for the call opened at open_idx."""
    depth = 0
    i = open_idx
    start = open_idx + 1
    args: list[tuple[int, int]] = []
    quote = None
    while i < len(text):
        c = text[i]
        if quote:
            if c == "\\":
                i += 1
            elif c == quote:
                quote = None
        elif c in "\"'":
            quote = c
        elif c in "([{":
            depth += 1
        elif c in ")]}":
            depth -= 1
            if depth == 0:
                args.append((start, i))
                return args, i
        elif c == "," and depth == 1:
            args.append((start, i))
            start = i + 1
        elif c == "\n" and quote:
            return None, i
        i += 1
    return None, i


def string_literal(arg: str):
    m = re.fullmatch(r'\s*(["\'])((?:\\.|(?!\1).)*)\1\s*', arg)
    return (m.group(1), m.group(2)) if m else None


def in_comment(text: str, idx: int) -> bool:
    line_start = text.rfind("\n", 0, idx) + 1
    prefix = text[line_start:idx]
    return "--" in prefix


def rewrite(text: str):
    """Return (new_text, edits, unhandled) where edits/unhandled are lists of description strings."""
    aliases = class_aliases(text)
    edits: list[str] = []
    unhandled: list[str] = []
    out: list[str] = []
    pos = 0
    for m in CALL.finditer(text):
        if m.start() < pos or in_comment(text, m.start()):
            continue
        args, close = split_call(text, m.end() - 1)
        if not args:
            continue
        raw = [text[a:b] for a, b in args]
        lineno = text.count("\n", 0, m.start()) + 1
        replacement = None
        if len(raw) >= 2 and is_class_expr(raw[0], aliases):
            lit = string_literal(raw[1])
            if lit is None:
                if not is_class_expr(raw[1], aliases):
                    unhandled.append(f"line {lineno}: non-literal needle {raw[1].strip()}")
                continue
            quote, needle = lit
            lowered = needle.lower()
            new_args = list(raw)
            if lowered != needle:
                new_args[1] = f" {quote}{lowered}{quote}" if raw[1].startswith(" ") else f"{quote}{lowered}{quote}"
            if len(raw) == 2 and any(ch in MAGIC for ch in lowered):
                new_args += [" 1", " true"]
            if new_args != raw:
                replacement = new_args
        elif len(raw) == 2 and is_class_expr(raw[1], aliases) and not is_class_expr(raw[0], aliases):
            lit = string_literal(raw[0])
            if lit is not None:
                quote, body = lit
                first = f"{quote}{body.lower()}{quote}"
            else:
                first = f"string.lower({raw[0].strip()})"
            replacement = [first, raw[1] if raw[1].startswith(" ") else " " + raw[1], " 1", " true"]
        if replacement is not None:
            out.append(text[pos:args[0][0]])
            out.append(",".join(replacement))
            pos = close
            edits.append(f"line {lineno}")
    out.append(text[pos:])
    return "".join(out), edits, unhandled


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("paths", nargs="*", type=Path)
    ap.add_argument("--trg", type=Path, default=DEFAULT_TRG)
    ap.add_argument("--check", action="store_true", help="report only, do not write")
    args = ap.parse_args(argv)

    files = []
    for p in args.paths or [args.trg]:
        files += sorted(p.rglob("*.lua")) if p.is_dir() else [p]

    changed = 0
    total = 0
    for f in files:
        text = f.read_text(encoding="utf-8")
        new, edits, unhandled = rewrite(text)
        for u in unhandled:
            print(f"UNHANDLED {f}: {u}")
        if new != text:
            changed += 1
            total += len(edits)
            print(f"{'WOULD FIX' if args.check else 'fixed'} {f.name}: {len(edits)} call(s)")
            if not args.check:
                f.write_text(new, encoding="utf-8")
    print(f"{changed} file(s), {total} call(s)")
    return 1 if (args.check and changed) else 0


if __name__ == "__main__":
    sys.exit(main())
