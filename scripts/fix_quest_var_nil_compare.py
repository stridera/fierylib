#!/usr/bin/env python3
"""Make quest-variable comparisons in the trigger corpus (data/triggers) nil-safe.

fierymud-rs `quest_var_to_lua` returns `nil` for an unset (or empty) quest variable, an integer for
a numeric one and a string otherwise. So every script that compares the getter against a number
without a default misbehaves on a var nobody has stored yet:

    actor:get_quest_var("q:v") == 0     -- nil == 0 is false: the "not started" branch never runs
    actor:get_quest_var("q:v") ~= 0     -- nil ~= 0 is true: "already started" runs for everyone
    actor:get_quest_var("q:v") < 3      -- error: attempt to compare nil with number
    actor:get_quest_var("q:v") == ""    -- DG: an unset variable expands to "" ; nil == "" is false

Rewritten (only when the compared operand is the getter call itself, or a local that was assigned
directly from one and never reassigned, in the same function scope):

    <call> <op> N        ->  (<call> or 0) <op> N        N a numeric literal, op in == ~= < > <= >=
    <call> ==/~= ""      ->  (<call> or "") ==/~= ""
    <local> <op> N       ->  (<local> or 0) <op> N       (and the same for "")

Left alone: string comparisons other than "" (`== "x"` is already right for nil), comparisons whose
other side is not a literal, operands buried in arithmetic / concatenation / `not`, getter calls
that are already followed by `or` (so the pass is idempotent), and locals that are reassigned or
shadowed. The script tokenises the Lua (strings and comments are never touched) and tracks block
scopes for the locals.

Usage:
    python scripts/fix_quest_var_nil_compare.py [--check] [PATH ...]

PATH may be files or directories (default: data/triggers). --check reports without writing and
exits 1 when something would change.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_DIR = ROOT / "data" / "triggers"

KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in",
    "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while",
}
CMP_OPS = {"==", "~=", "<", ">", "<=", ">="}
# Operators that bind tighter than a comparison: a getter call on their right is only part of the
# left operand of the comparison, so rewriting it would change the meaning.
TIGHT_PREV = {"+", "-", "*", "/", "%", "^", "..", "#", "//", "not", "~", "&", "|", "<<", ">>"}
# After a direct `local x = <call>` the statement is over: the next token starts a new statement.
STATEMENT_START_KW = {
    "end", "else", "elseif", "until", "local", "if", "for", "while", "return", "break", "function",
    "do", "repeat", "goto",
}

TOKEN_RE = re.compile(
    r"""
    (?P<ws>\s+)
  | (?P<lcomment>--\[(?P<lc_eq>=*)\[)
  | (?P<comment>--[^\n]*)
  | (?P<lstring>\[(?P<ls_eq>=*)\[)
  | (?P<string>"(?:\\.|[^"\\\n])*"|'(?:\\.|[^'\\\n])*')
  | (?P<number>0[xX][0-9a-fA-F]+|(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)
  | (?P<name>[A-Za-z_]\w*)
  | (?P<op>\.\.\.|\.\.|==|~=|<=|>=|::|//|<<|>>|[-+*/%^#&~|<>=(){}\[\];:,.])
    """,
    re.VERBOSE,
)


@dataclass
class Tok:
    kind: str  # name | kw | number | string | op
    text: str
    start: int
    end: int


def tokenize(src: str) -> list[Tok]:
    toks: list[Tok] = []
    pos = 0
    n = len(src)
    while pos < n:
        m = TOKEN_RE.match(src, pos)
        if not m:
            pos += 1  # unknown byte: skip, never fail on odd corpus text
            continue
        kind = m.lastgroup
        if kind in ("lc_eq", "ls_eq"):
            kind = "lcomment" if m.group("lcomment") else "lstring"
        if m.group("lcomment") or m.group("lstring"):
            eq = m.group("lc_eq") if m.group("lcomment") else m.group("ls_eq")
            close = "]" + eq + "]"
            idx = src.find(close, m.end())
            end = n if idx < 0 else idx + len(close)
            if m.group("lstring"):
                toks.append(Tok("string", src[m.start():end], m.start(), end))
            pos = end
            continue
        if m.group("ws") or m.group("comment"):
            pos = m.end()
            continue
        text = m.group()
        if m.group("name"):
            kind = "kw" if text in KEYWORDS else "name"
        elif m.group("number"):
            kind = "number"
        elif m.group("string"):
            kind = "string"
        else:
            kind = "op"
        toks.append(Tok(kind, text, m.start(), m.end()))
        pos = m.end()
    return toks


def match_paren(toks: list[Tok], i: int) -> int:
    """Index of the `)` closing the `(` at toks[i], or -1."""
    depth = 0
    for j in range(i, len(toks)):
        t = toks[j]
        if t.kind == "op" and t.text in "([{":
            depth += 1
        elif t.kind == "op" and t.text in ")]}":
            depth -= 1
            if depth == 0:
                return j if t.text == ")" else -1
    return -1


def call_at(toks: list[Tok], i: int):
    """If toks[i] starts `recv(.name)*:get_quest_var(...)`, return (start_idx, end_idx) of the call
    (end_idx is the closing paren), else None. toks[i] must be the receiver's first name."""
    j = i
    if toks[j].kind != "name":
        return None
    j += 1
    while j + 1 < len(toks) and toks[j].text == "." and toks[j + 1].kind == "name":
        j += 2
    if not (j + 2 < len(toks) and toks[j].text == ":" and toks[j + 1].text == "get_quest_var"
            and toks[j + 2].text == "("):
        return None
    close = match_paren(toks, j + 2)
    if close < 0:
        return None
    return i, close


def chain_start(toks: list[Tok], i: int) -> int:
    """Walk back from a name token over `name.name.` to the first name of the chain."""
    while i >= 2 and toks[i - 1].text == "." and toks[i - 2].kind == "name":
        i -= 2
    return i


@dataclass
class Decl:
    name: str
    visible_from: int  # token index from which uses resolve to this declaration
    eligible: bool = False  # assigned directly from a get_quest_var call
    tainted: bool = False  # reassigned somewhere in its scope
    uses: list[int] = field(default_factory=list)  # token indices of name uses


def analyse_locals(toks: list[Tok]) -> list[Decl]:
    """Scope-aware pass: every `local` / parameter / loop variable becomes a Decl; later name tokens
    are resolved to the innermost visible Decl, collecting uses and reassignments."""
    decls: list[Decl] = []
    stack: list[dict[str, Decl]] = [{}]  # block scopes, innermost last
    pending_for: list[str] = []
    n = len(toks)

    def declare(name: str, visible_from: int, eligible: bool = False) -> Decl:
        d = Decl(name, visible_from, eligible)
        decls.append(d)
        stack[-1][name] = d
        return d

    def lookup(name: str) -> Decl | None:
        for scope in reversed(stack):
            if name in scope:
                return scope[name]
        return None

    i = 0
    while i < n:
        t = toks[i]
        if t.kind == "kw":
            w = t.text
            if w in ("if", "repeat"):
                stack.append({})
            elif w == "do":
                stack.append({})
                for name in pending_for:
                    declare(name, i)
                pending_for = []
            elif w in ("elseif", "else"):
                stack[-1] = {}
            elif w in ("end", "until"):
                if len(stack) > 1:
                    stack.pop()
            elif w == "for":
                j = i + 1
                pending_for = []
                while j < n and not (toks[j].kind == "kw" and toks[j].text == "in") and toks[j].text != "=":
                    if toks[j].kind == "name":
                        pending_for.append(toks[j].text)
                    j += 1
            elif w == "function":
                stack.append({})
                j = i + 1
                while j < n and toks[j].text != "(":
                    j += 1
                close = match_paren(toks, j) if j < n else -1
                if close > 0:
                    for k in range(j + 1, close):
                        if toks[k].kind == "name":
                            declare(toks[k].text, k)
                    i = close
            elif w == "local":
                j = i + 1
                if j < n and toks[j].kind == "kw" and toks[j].text == "function":
                    if j + 1 < n and toks[j + 1].kind == "name":
                        declare(toks[j + 1].text, j + 1)
                    # the `function` keyword is processed on the next iteration
                else:
                    names = []
                    while j < n and toks[j].kind == "name":
                        names.append(toks[j].text)
                        j += 1
                        # skip attribs <const> / <close>
                        if j + 2 < n and toks[j].text == "<" and toks[j + 2].text == ">":
                            j += 3
                        if j < n and toks[j].text == ",":
                            j += 1
                            continue
                        break
                    eligible = False
                    vis = j
                    if len(names) == 1 and j < n and toks[j].text == "=":
                        call = call_at(toks, j + 1) if j + 1 < n else None
                        if call:
                            nxt = call[1] + 1
                            ok = nxt >= n or toks[nxt].text == ";" or toks[nxt].kind == "name" \
                                or (toks[nxt].kind == "kw" and toks[nxt].text in STATEMENT_START_KW)
                            if ok:
                                eligible = True
                                vis = call[1] + 1
                        else:
                            vis = j + 1
                    for name in names:
                        declare(name, vis, eligible and len(names) == 1)
                    i = j - 1
        elif t.kind == "name":
            prev = toks[i - 1].text if i else ""
            if prev not in (".", ":"):
                d = lookup(t.text)
                if d is not None and i >= d.visible_from:
                    nxt = toks[i + 1].text if i + 1 < n else ""
                    if nxt == "=":
                        d.tainted = True
                    else:
                        d.uses.append(i)
        i += 1
    return decls


def literal_kind(toks: list[Tok], j: int):
    """Classify the right-hand side of a comparison starting at toks[j]: ("num", last_idx),
    ("empty", idx) for "" / '', or None."""
    if j >= len(toks):
        return None
    t = toks[j]
    if t.kind == "op" and t.text == "-" and j + 1 < len(toks) and toks[j + 1].kind == "number":
        return "num", j + 1
    if t.kind == "number":
        return "num", j
    if t.kind == "string" and t.text in ('""', "''"):
        return "empty", j
    if t.kind == "string":
        return "str", j
    return None


def guarded_by_truthiness(toks: list[Tok], u: int) -> bool:
    """True when the same expression already tests the local for truthiness first
    (`v and v ~= 0`), so the use can never see nil."""
    name = toks[u].text
    depth = 0
    j = u - 1
    while j >= 0:
        t = toks[j]
        if t.kind == "op" and t.text == ")":
            depth += 1
        elif t.kind == "op" and t.text == "(":
            if depth == 0:
                return False
            depth -= 1
        elif depth == 0 and (
            (t.kind == "kw" and t.text in ("if", "elseif", "while", "until", "return", "then", "do", "else"))
            or (t.kind == "op" and t.text in ("=", ",", ";", "{", "}"))
        ):
            return False
        elif (depth == 0 and t.kind == "name" and t.text == name and j + 1 < len(toks)
              and toks[j + 1].text == "and"
              and not (j and (toks[j - 1].text in CMP_OPS or toks[j - 1].text in TIGHT_PREV))):
            return True
        j -= 1
    return False


@dataclass
class Report:
    files_changed: int = 0
    rewrites: Counter = field(default_factory=Counter)
    skipped: Counter = field(default_factory=Counter)
    changed_paths: list[str] = field(default_factory=list)


def _operand_edit(toks, src, first, last, report: Counter, kind: str):
    """Common checks for an operand spanning toks[first..last] followed by `<cmp> literal`.
    Returns (start, end, replacement) or None."""
    n = len(toks)
    k = last + 1
    if k >= n or toks[k].kind != "op" or toks[k].text not in CMP_OPS:
        return None
    # The operand must be the whole left operand of the comparison.
    if first > 0:
        p = toks[first - 1]
        if p.text in TIGHT_PREV and p.kind in ("op", "kw"):
            return None
        if p.text in (".", ":"):
            return None
    lit = literal_kind(toks, k + 1)
    if lit is None:
        report[f"skipped:{kind}:non-literal rhs"] += 1
        return None
    litkind, lit_last = lit
    if litkind == "str":
        # `== "x"` is already right for nil. A digits-only string never equals the integer the
        # engine returns for a numeric var: not touched here, but counted so it is not lost.
        if re.fullmatch(r"""["']-?\d+(\.\d+)?["']""", toks[lit_last].text) and toks[k].text in ("==", "~="):
            report[f"skipped:{kind}:compared with a numeric string"] += 1
        return None
    nxt = toks[lit_last + 1].text if lit_last + 1 < n else ""
    if nxt in ("..", "."):
        return None
    op = toks[k].text
    if litkind == "empty" and op not in ("==", "~="):
        return None
    default = "0" if litkind == "num" else '""'
    text = src[toks[first].start:toks[last].end]
    return toks[first].start, toks[last].end, f"({text} or {default})", f"{kind}-{'num' if litkind == 'num' else 'empty'}"


def fix_source(src: str) -> tuple[str, Counter]:
    """Return (new_source, counts). Counts keys: call-num, call-empty, local-num, local-empty plus
    skipped:* entries (from the first pass)."""
    total: Counter = Counter()
    for npass in range(8):  # an edit nested in another is redone on the next pass
        toks = tokenize(src)
        edits: list[tuple[int, int, str, str]] = []
        skips: Counter = Counter()

        # 1. direct getter calls
        for i, t in enumerate(toks):
            if t.kind != "name" or (i and toks[i - 1].text in (".", ":")):
                continue
            call = call_at(toks, i)
            if call and (res := _operand_edit(toks, src, call[0], call[1], skips, "call")):
                edits.append(res)

        # 2. locals assigned directly from a getter and never reassigned
        for d in analyse_locals(toks):
            if d.eligible and not d.tainted:
                for u in d.uses:
                    if guarded_by_truthiness(toks, u):
                        continue
                    if res := _operand_edit(toks, src, u, u, skips, "local"):
                        edits.append(res)

        if npass == 0:
            total.update(skips)
        if not edits:
            break
        # Drop edits nested inside another one (outermost first); they are found again next pass.
        edits.sort(key=lambda e: (e[0], -(e[1] - e[0])))
        kept: list[tuple[int, int, str, str]] = []
        for e in edits:
            if kept and e[0] < kept[-1][1]:
                continue
            kept.append(e)
        for s, e_, rep, kind in reversed(kept):
            src = src[:s] + rep + src[e_:]
        total.update(kind for _, _, _, kind in kept)
    return src, total


def lua_files(paths: list[Path]) -> list[Path]:
    out: list[Path] = []
    for p in paths:
        out.extend(sorted(p.rglob("*.lua")) if p.is_dir() else [p])
    return out


def process(paths: list[Path], write: bool) -> Report:
    report = Report()
    for path in lua_files(paths):
        src = path.read_text(encoding="utf-8")
        new, counts = fix_source(src)
        for k, v in counts.items():
            if k.startswith("skipped:"):
                report.skipped[k] += v
        applied = {k: v for k, v in counts.items() if not k.startswith("skipped:")}
        if new != src:
            report.files_changed += 1
            report.changed_paths.append(str(path))
            for k, v in applied.items():
                report.rewrites[k] += v
            if write:
                path.write_text(new, encoding="utf-8")
    return report


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("paths", nargs="*", type=Path)
    ap.add_argument("--check", action="store_true", help="report only; exit 1 if anything would change")
    args = ap.parse_args()
    report = process(args.paths or [DEFAULT_DIR], write=not args.check)
    verb = "would change" if args.check else "changed"
    print(f"{verb} {report.files_changed} files; rewrites {sum(report.rewrites.values())}")
    for k, v in sorted(report.rewrites.items()):
        print(f"  {k}: {v}")
    for k, v in sorted(report.skipped.items()):
        print(f"  {k}: {v}")
    return 1 if args.check and report.files_changed else 0


if __name__ == "__main__":
    sys.exit(main())
