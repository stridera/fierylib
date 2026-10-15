#!/usr/bin/env python3
"""Give SPEECH / SPEECH_TO keyword gates the legacy word-boundary semantics.

Older conversions tested the speech with a plain `string.find(string.lower(speech), "needle")`, which
matches inside longer words ("me" in "menu", "heal" in "healer") and, in phrase mode, split the phrase
into a loose OR of its words. dg_triggers.cpp is stricter:

  num_arg != 0  word_check   one of the arg's words / "quoted phrases" must occur as a whole word
  num_arg == 0  is_substring the whole arg must occur as a phrase

and "whole" means the neighbours are whitespace, punctuation or the edge of the speech. This script
replaces the gate block (and only that block) of every plain-`string.find` gate with the lines the
converter now emits (dg_to_lua.speech_gate_lines), taking the word list from the legacy .trg source.

A gate block is: an optional `-- Speech keywords:` / `-- Speech phrase:` comment, an optional
`local speech_lower = string.lower(speech)`, then one `if not (<string.find ...>) then return true end`
whose tests are all literal-needle `string.find` calls on the speech. Anything else (hand-written
`has()` helpers, extra conditions) is reported and left alone, as are gates that already use
`speech_padded` with a whole-word word list.

Usage:
    python scripts/fix_speech_word_boundaries.py [--check] [--trg DIR] [PATH ...]
"""

from __future__ import annotations

import argparse
import re
import string
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))
sys.path.insert(0, str(ROOT / "scripts"))

import fix_percent_chance_zero as Z  # noqa: E402
from fierylib.converters.dg_to_lua import dg_word_list, speech_gate_lines  # noqa: E402

HEADER_TYPE_RE = re.compile(r"^-- Type: (?P<attach>\w+), Flags: (?P<flags>.*)$", re.M)
COMMENT_RE = re.compile(r"^-- (?:Speech keywords?|Speech phrase|DG word list)[^\n]*\n", re.M)
LIT = r'"(?P<{n}>(?:[^"\\]|\\.)*)"'
DEF_RE = re.compile(r'^local (?P<var>\w+) = string\.lower\(speech(?P<orempty> or "")?\)[ \t]*\n', re.M)
HAS_DEF_RE = re.compile(r"^local function has\(word\) return string\.find\(\w+, word, 1, true\) ~= nil end[ \t]*\n", re.M)
GATE_RE = re.compile(
    r"^if not (?P<cond>(?:(?!\bthen\b).)*?) then\n[ \t]+return true[^\n]*\nend\n",
    re.M | re.S,
)
OVERRIDES = {
    # hand-curated: the builder's arg is a word list written as a phrase (num_arg 0), never matches as a phrase
    (533, 13): ("status progress", 1),
}


def parse_cond(cond: str, vars_: set[str]) -> tuple[list[str], str] | None:
    """(needles, joiner) of an `a or b or ...` / `a and b` chain of literal tests on the speech, else None."""
    cond = re.sub(r"\s+", " ", cond.strip())
    if cond.startswith("(") and cond.endswith(")"):
        cond = cond[1:-1].strip()
    subject = "|".join(sorted({re.escape(v) for v in vars_} | {r'string\.lower\(speech(?: or "")?\)', r'speech'}))
    term = re.compile(
        rf'string\.find\((?:{subject}), {LIT.format(n="a")}(?:, 1, true)?\)|has\({LIT.format(n="b")}\)'
    )
    needles: list[str] = []
    joiners: set[str] = set()
    pos = 0
    while True:
        m = term.match(cond, pos)
        if m is None:
            return None
        lit = m["a"] if m["a"] is not None else m["b"]
        needles.append(lit.replace('\\"', '"').replace("\\\\", "\\"))
        pos = m.end()
        if pos == len(cond):
            break
        j = re.match(r" (or|and) ", cond[pos:])
        if j is None:
            return None
        joiners.add(j[1])
        pos += j.end()
    if len(joiners) > 1:
        return None
    return needles, (joiners.pop() if joiners else "or")


def rewrite(src: str, legacy: dict[int, Z.Legacy]) -> tuple[str, str]:
    """(action, new_src): action is fixed | skip:<why> | none."""
    h = HEADER_TYPE_RE.search(src)
    if h is None:
        return "none", src
    flags = {x.strip() for x in h["flags"].split(",") if x.strip()}
    if not flags & {"SPEECH", "SPEECH_TO"}:
        return "none", src
    m = GATE_RE.search(src)
    if m is None:
        return "none", src
    before = src[: m.start()]
    defs = list(DEF_RE.finditer(before))
    parsed = parse_cond(m["cond"], {d["var"] for d in defs})
    if parsed is None:
        return "none", src  # padded whole-word gate, hand-written logic, extra conditions
    needles, joiner = parsed
    # the gate must be the first statement: only comments, blanks, the speech_lower definitions and has() before it
    rest = DEF_RE.sub("", HAS_DEF_RE.sub("", before))
    if [ln for ln in rest.split("\n") if ln.strip() and not ln.lstrip().startswith("--")]:
        return "skip:code before the gate", src
    zi = Z.HEADER_RE.search(src)
    key = (int(zi["zone"]), int(zi["id"])) if zi else None
    lg = Z.find_legacy(src, legacy)
    arg, narg = (lg.arg, lg.narg) if lg else (" ".join(needles), 1)
    if key in OVERRIDES:
        arg, narg = OVERRIDES[key]
    note = ""
    if narg == 0:
        if len(needles) == 1:
            arg = needles[0]  # a single hand-written phrase stays (it is the legacy phrase or a curated part of it)
        else:
            words = {w.strip(string.punctuation) for w in arg.lower().split()}
            if not {n.strip(string.punctuation) for n in needles} <= words:
                return f"skip:needles {needles} are not words of the legacy phrase {arg!r}", src
    else:
        if joiner == "and":
            return "skip:AND of words in word-list mode", src
        expect = {v for w in dg_word_list(arg) for v in (w, w.rstrip(string.punctuation)) if v}
        if lg is None or not set(needles) <= expect:
            arg = " ".join(f'"{n}"' if " " in n else n for n in needles)  # keep the hand-written needles
            note = " (kept the script's own needles)"
    lines = speech_gate_lines(arg, narg)
    if not lines:
        return "skip:legacy arg is empty or *", src
    after = src[m.end():]
    if any(d["orempty"] for d in defs) or 'speech or ""' in m["cond"]:
        lines = [ln.replace("string.lower(speech)", 'string.lower(speech or "")') for ln in lines]
    keep = [d.group(0) for d in defs if re.search(rf"\b{d['var']}\b", after)]
    keep += [x.group(0) for x in HAS_DEF_RE.finditer(before) if re.search(r"\bhas\(", after)]
    head = COMMENT_RE.sub("", rest).rstrip("\n")
    head = head + "\n\n" if head.strip() else ""
    block = "".join(keep) + ("\n" if keep else "") + "\n".join(lines).rstrip("\n") + "\n"
    return ("fixed" + note), head + block + after


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
        if action.startswith("fixed"):
            fixed += 1
            if action != "fixed":
                print(f"note: {f.parent.name}/{f.name}{action[5:]}")
            if not args.check:
                f.write_text(out, encoding="utf-8")
        elif action.startswith("skip:"):
            print(f"skip: {f.parent.name}/{f.name}: {action[5:]}")
    print(f"fixed: {fixed}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
