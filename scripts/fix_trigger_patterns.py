#!/usr/bin/env python3
"""Rewrite two broken-script patterns across the trigger corpus (data/triggers).

P1  `local x` declared inside an if/elseif/else branch and used after the chain.
    Lua scopes the local to the branch, so the later read sees nil. The declaration is
    hoisted to just before the outermost if statement that the use is after
    (`local x` there, `x = ...` in the branches). Uses a real (small) Lua parser with
    scope resolution, no regexes over source text.

P2  `.id` / `.vnum` compared against a legacy 4+ digit vnum literal. The runtime exposes
    the composite key as `.zone_id` and `.id` (the local id), so a vnum never matches.
    `X.id == 3045` becomes `(X.zone_id == 30 and X.id == 45)`; `~=` becomes
    `(X.zone_id ~= 30 or X.id ~= 45)`. The vnum is mapped to (zone, id) through the zone
    ranges in lib/world/zon (zone 30 spans 3000-3499, so 3123 is 30:123, not 31:23).
    `local v = X.id` followed by `v == 3045` is rewritten too (when `v` and `X` are never
    reassigned). `.vnum` is not a runtime property at all and becomes `.id`.

    The runtime (mud-script LuaActor/LuaRoom) exposes `.id` and `.zone_id` on actors, objects
    and rooms; `.local_id` exists on rooms only. Output therefore uses `.id`.

Everything the rewriter cannot do safely (ranges, arithmetic on vnums, vnums held in
variables or tables, shadowed outer locals, ...) is left untouched and listed as "manual".

Usage:
    python scripts/fix_trigger_patterns.py [--check] [--manual-out FILE] [--zon DIR] [PATH ...]

PATH may be files or directories (default: data/triggers). --check reports without writing.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "src"))

# --------------------------------------------------------------------------------------
# Tokenizer
# --------------------------------------------------------------------------------------

KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if",
    "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while",
}
OPS3 = {"..."}
OPS2 = {"..", "==", "~=", "<=", ">=", "//", "::", "<<", ">>"}
NUM_RE = re.compile(
    r"0[xX][0-9a-fA-F]*\.?[0-9a-fA-F]*(?:[pP][+-]?\d+)?|\d+\.?\d*(?:[eE][+-]?\d+)?|\.\d+(?:[eE][+-]?\d+)?"
)
NAME_RE = re.compile(r"[A-Za-z_][A-Za-z_0-9]*")
LONG_OPEN_RE = re.compile(r"\[(=*)\[")


@dataclass
class Tok:
    kind: str  # name kw num str op eof
    val: str
    start: int
    end: int
    line: int


class LuaSyntaxError(Exception):
    pass


def tokenize(src: str) -> list[Tok]:
    toks: list[Tok] = []
    i, n, line = 0, len(src), 1

    def long_end(pos: int, level: int) -> int:
        close = "]" + "=" * level + "]"
        j = src.find(close, pos)
        if j < 0:
            raise LuaSyntaxError(f"unterminated long bracket at line {line}")
        return j + len(close)

    while i < n:
        c = src[i]
        if c == "\n":
            line += 1
            i += 1
        elif c in " \t\r\f\v":
            i += 1
        elif src.startswith("--", i):
            m = LONG_OPEN_RE.match(src, i + 2)
            if m:
                j = long_end(m.end(), len(m.group(1)))
                line += src.count("\n", i, j)
                i = j
            else:
                j = src.find("\n", i)
                i = n if j < 0 else j
        elif c in "\"'":
            j = i + 1
            while j < n and src[j] != c:
                if src[j] == "\\":
                    if src[j + 1 : j + 2] == "z":  # \z skips following whitespace incl. newlines
                        j += 2
                        while j < n and src[j] in " \t\r\n\f\v":
                            j += 1
                        continue
                    j += 1
                if j < n and src[j] == "\n":
                    pass  # escaped newline inside a string
                j += 1
            if j >= n:
                raise LuaSyntaxError(f"unterminated string at line {line}")
            toks.append(Tok("str", src[i : j + 1], i, j + 1, line))
            line += src.count("\n", i, j + 1)
            i = j + 1
        elif c == "[" and (m := LONG_OPEN_RE.match(src, i)):
            j = long_end(m.end(), len(m.group(1)))
            toks.append(Tok("str", src[i:j], i, j, line))
            line += src.count("\n", i, j)
            i = j
        elif c.isdigit() or (c == "." and src[i + 1 : i + 2].isdigit()):
            m = NUM_RE.match(src, i)
            toks.append(Tok("num", m.group(0), i, m.end(), line))
            i = m.end()
        elif c.isalpha() or c == "_":
            m = NAME_RE.match(src, i)
            word = m.group(0)
            toks.append(Tok("kw" if word in KEYWORDS else "name", word, i, m.end(), line))
            i = m.end()
        else:
            if src.startswith("...", i):
                op = "..."
            elif src[i : i + 2] in OPS2:
                op = src[i : i + 2]
            else:
                op = c
            toks.append(Tok("op", op, i, i + len(op), line))
            i += len(op)
    toks.append(Tok("eof", "", n, n, line))
    return toks


# --------------------------------------------------------------------------------------
# Parser with scope resolution
# --------------------------------------------------------------------------------------


@dataclass(eq=False)
class Block:
    kind: str  # chunk func ifbranch loop do repeat
    start: int  # first token index inside the block
    end: int = 0  # token index of the closer (exclusive end of the block's tokens)
    parent: Block | None = None
    owner: Stmt | None = None
    names: dict[str, Decl] = field(default_factory=dict)
    stmts: list[Stmt] = field(default_factory=list)


@dataclass(eq=False)
class Stmt:
    kind: str  # local if while for repeat do function localfunction return break goto label expr assign
    start: int
    end: int = 0  # exclusive token index
    block: Block | None = None
    decls: list[Decl] = field(default_factory=list)  # local statements
    has_init: bool = False
    attribs: bool = False
    eq_tok: int = -1


@dataclass(eq=False)
class Decl:
    name: str
    tok: int
    kind: str  # local param for localfunction
    block: Block
    stmt: Stmt | None = None
    outer: Decl | None = None  # the binding this one shadows, if any


@dataclass(eq=False)
class Ref:
    name: str
    tok: int
    decl: Decl | None
    block: Block
    write: bool = False


class Parser:
    def __init__(self, toks: list[Tok]):
        self.t = toks
        self.i = 0
        self.blk: Block | None = None
        self.refs: list[Ref] = []
        self.decls: list[Decl] = []
        self.stmts: list[Stmt] = []

    # -- token helpers
    def cur(self) -> Tok:
        return self.t[self.i]

    def peek(self, k: int = 1) -> Tok:
        return self.t[min(self.i + k, len(self.t) - 1)]

    def is_(self, val: str) -> bool:
        t = self.cur()
        return t.val == val and t.kind in ("kw", "op")

    def accept(self, val: str) -> bool:
        if self.is_(val):
            self.i += 1
            return True
        return False

    def expect(self, val: str) -> None:
        if not self.accept(val):
            t = self.cur()
            raise LuaSyntaxError(f"expected {val!r} near {t.val!r} (line {t.line})")

    def name(self) -> int:
        t = self.cur()
        if t.kind != "name":
            raise LuaSyntaxError(f"expected name near {t.val!r} (line {t.line})")
        self.i += 1
        return self.i - 1

    # -- scopes
    def resolve(self, name: str) -> Decl | None:
        b = self.blk
        while b is not None:
            d = b.names.get(name)
            if d is not None:
                return d
            b = b.parent
        return None

    def declare(self, name: str, tok: int, kind: str, stmt: Stmt | None = None) -> Decl:
        d = Decl(name, tok, kind, self.blk, stmt, self.resolve(name))
        self.blk.names[name] = d
        self.decls.append(d)
        return d

    def ref(self, tok: int, write: bool = False) -> Ref:
        r = Ref(self.t[tok].val, tok, self.resolve(self.t[tok].val), self.blk, write)
        self.refs.append(r)
        return r

    def push(self, kind: str, owner: Stmt | None) -> Block:
        b = Block(kind, self.i, parent=self.blk, owner=owner)
        self.blk = b
        return b

    def pop(self) -> None:
        self.blk.end = self.i
        self.blk = self.blk.parent

    # -- blocks and statements
    def parse_chunk(self) -> Block:
        b = self.push("chunk", None)
        self.block_body(b)
        if self.cur().kind != "eof":
            t = self.cur()
            raise LuaSyntaxError(f"unexpected {t.val!r} (line {t.line})")
        b.end = len(self.t)
        self.blk = None
        return b

    def block_body(self, b: Block) -> None:
        while True:
            t = self.cur()
            if t.kind == "eof" or (t.kind == "kw" and t.val in ("end", "else", "elseif", "until")):
                return
            s = self.statement(b)
            if s is not None:
                b.stmts.append(s)
                self.stmts.append(s)
            if s is not None and s.kind == "return":
                return

    def statement(self, b: Block) -> Stmt | None:
        t = self.cur()
        start = self.i
        if t.kind == "op" and t.val == ";":
            self.i += 1
            return None
        s = Stmt("expr", start, block=b)
        if t.kind == "kw":
            v = t.val
            if v == "if":
                s.kind = "if"
                self.i += 1
                self.exp()
                self.expect("then")
                self.branch(s)
                while self.is_("elseif"):
                    self.i += 1
                    self.exp()
                    self.expect("then")
                    self.branch(s)
                if self.accept("else"):
                    self.branch(s)
                self.expect("end")
            elif v == "while":
                s.kind = "while"
                self.i += 1
                self.exp()
                self.expect("do")
                body = self.push("loop", s)
                self.block_body(body)
                self.pop()
                self.expect("end")
            elif v == "for":
                s.kind = "for"
                self.i += 1
                first = self.name()
                if self.is_("="):
                    self.i += 1
                    self.exp()
                    self.expect(",")
                    self.exp()
                    if self.accept(","):
                        self.exp()
                    names = [first]
                else:
                    names = [first]
                    while self.accept(","):
                        names.append(self.name())
                    self.expect("in")
                    self.explist()
                self.expect("do")
                body = self.push("loop", s)
                for n in names:
                    self.declare(self.t[n].val, n, "for")
                self.block_body(body)
                self.pop()
                self.expect("end")
            elif v == "repeat":
                s.kind = "repeat"
                self.i += 1
                body = self.push("repeat", s)
                self.block_body(body)
                self.expect("until")
                self.exp()  # sees the body's locals
                self.pop()
            elif v == "do":
                s.kind = "do"
                self.i += 1
                body = self.push("do", s)
                self.block_body(body)
                self.pop()
                self.expect("end")
            elif v == "function":
                s.kind = "function"
                self.i += 1
                n = self.name()
                dotted = False
                is_method = False
                self.ref(n, write=True)
                while self.is_(".") or self.is_(":"):
                    dotted = True
                    is_method = self.cur().val == ":"
                    self.i += 1
                    self.name()
                    if is_method:
                        break
                self.funcbody(is_method)
            elif v == "local":
                self.i += 1
                if self.accept("function"):
                    s.kind = "localfunction"
                    n = self.name()
                    d = self.declare(self.t[n].val, n, "localfunction", s)
                    s.decls.append(d)
                    self.funcbody(False)
                else:
                    s.kind = "local"
                    names = []
                    while True:
                        names.append(self.name())
                        if self.is_("<"):  # attribute <const> / <close>
                            self.i += 1
                            self.name()
                            self.expect(">")
                            s.attribs = True
                        if not self.accept(","):
                            break
                    if self.is_("="):
                        s.eq_tok = self.i
                        self.i += 1
                        s.has_init = True
                        self.explist()
                    for n in names:
                        s.decls.append(self.declare(self.t[n].val, n, "local", s))
            elif v == "return":
                s.kind = "return"
                self.i += 1
                c = self.cur()
                if not (c.kind == "eof" or (c.kind == "kw" and c.val in ("end", "else", "elseif", "until"))
                        or (c.kind == "op" and c.val == ";")):
                    self.explist()
                self.accept(";")
            elif v == "break":
                s.kind = "break"
                self.i += 1
            elif v == "goto":
                s.kind = "goto"
                self.i += 1
                self.name()
            else:
                raise LuaSyntaxError(f"unexpected {t.val!r} (line {t.line})")
        elif t.kind == "op" and t.val == "::":
            s.kind = "label"
            self.i += 1
            self.name()
            self.expect("::")
        else:
            targets = [self.suffixed(want_ref_write=True)]
            if self.is_("=") or self.is_(","):
                s.kind = "assign"
                while self.accept(","):
                    targets.append(self.suffixed(want_ref_write=True))
                self.expect("=")
                self.explist()
            elif not targets[0][2]:
                t0 = self.cur()
                raise LuaSyntaxError(f"syntax error near {t0.val!r} (line {t0.line})")
            for ref, is_bare, _call in targets:
                if s.kind == "assign" and is_bare and ref is not None:
                    ref.write = True
        s.end = self.i
        return s

    def branch(self, s: Stmt) -> None:
        body = self.push("ifbranch", s)
        self.block_body(body)
        self.pop()

    def funcbody(self, is_method: bool) -> None:
        body = self.push("func", None)
        if is_method:
            self.declare("self", self.i, "param")
        self.expect("(")
        if not self.is_(")"):
            while True:
                if self.accept("..."):
                    break
                n = self.name()
                self.declare(self.t[n].val, n, "param")
                if not self.accept(","):
                    break
        self.expect(")")
        self.block_body(body)
        self.pop()
        self.expect("end")

    # -- expressions
    def explist(self) -> None:
        self.exp()
        while self.accept(","):
            self.exp()

    BINOPS = {"+", "-", "*", "/", "//", "%", "^", "..", "==", "~=", "<", "<=", ">", ">=", "&", "|", "~", "<<", ">>"}

    def exp(self) -> None:
        while True:
            t = self.cur()
            if (t.kind == "kw" and t.val == "not") or (t.kind == "op" and t.val in ("-", "#", "~")):
                self.i += 1
            else:
                break
        self.simple()
        while True:
            t = self.cur()
            if (t.kind == "op" and t.val in self.BINOPS) or (t.kind == "kw" and t.val in ("and", "or")):
                self.i += 1
                while True:
                    u = self.cur()
                    if (u.kind == "kw" and u.val == "not") or (u.kind == "op" and u.val in ("-", "#", "~")):
                        self.i += 1
                    else:
                        break
                self.simple()
            else:
                return

    def simple(self) -> None:
        t = self.cur()
        if t.kind in ("num", "str") or (t.kind == "kw" and t.val in ("nil", "true", "false")) or (
            t.kind == "op" and t.val == "..."
        ):
            self.i += 1
        elif t.kind == "kw" and t.val == "function":
            self.i += 1
            self.funcbody(False)
        elif t.kind == "op" and t.val == "{":
            self.table()
        else:
            self.suffixed()

    def table(self) -> None:
        self.expect("{")
        while not self.is_("}"):
            if self.is_("["):
                self.i += 1
                self.exp()
                self.expect("]")
                self.expect("=")
                self.exp()
            elif self.cur().kind == "name" and self.peek().kind == "op" and self.peek().val == "=":
                self.i += 2  # key, not a variable reference
                self.exp()
            else:
                self.exp()
            if not (self.accept(",") or self.accept(";")):
                break
        self.expect("}")

    def suffixed(self, want_ref_write: bool = False):
        """Parse a primary expression with suffixes. Returns (ref, is_bare_name, ends_in_call)."""
        t = self.cur()
        ref = None
        bare = False
        call = False
        if t.kind == "name":
            ref = self.ref(self.i)
            self.i += 1
            bare = True
        elif t.kind == "op" and t.val == "(":
            self.i += 1
            self.exp()
            self.expect(")")
        else:
            raise LuaSyntaxError(f"unexpected symbol near {t.val!r} (line {t.line})")
        while True:
            t = self.cur()
            if t.kind == "op" and t.val == ".":
                self.i += 1
                self.name()
                bare, call = False, False
            elif t.kind == "op" and t.val == "[":
                self.i += 1
                self.exp()
                self.expect("]")
                bare, call = False, False
            elif t.kind == "op" and t.val == ":":
                self.i += 1
                self.name()
                self.args()
                bare, call = False, True
            elif (t.kind == "op" and t.val in ("(", "{")) or t.kind == "str":
                self.args()
                bare, call = False, True
            else:
                return (ref, bare, call)

    def args(self) -> None:
        t = self.cur()
        if t.kind == "str":
            self.i += 1
        elif t.kind == "op" and t.val == "(":
            self.i += 1
            if not self.is_(")"):
                self.explist()
            self.expect(")")
        elif t.kind == "op" and t.val == "{":
            self.table()
        else:
            raise LuaSyntaxError(f"function arguments expected near {t.val!r} (line {t.line})")


@dataclass
class Parsed:
    src: str
    toks: list[Tok]
    chunk: Block
    refs: list[Ref]
    decls: list[Decl]
    stmts: list[Stmt]
    ref_at: dict[int, Ref]  # token index -> variable reference


def parse(src: str) -> Parsed:
    toks = tokenize(src)
    p = Parser(toks)
    chunk = p.parse_chunk()
    return Parsed(src, toks, chunk, p.refs, p.decls, p.stmts, {r.tok: r for r in p.refs})


# --------------------------------------------------------------------------------------
# Edits
# --------------------------------------------------------------------------------------


def apply_edits(src: str, edits: list[tuple[int, int, str]]) -> str:
    last = len(src) + 1
    for start, end, text in sorted(edits, key=lambda e: (e[0], e[1]), reverse=True):
        if end > last:
            raise ValueError(f"overlapping edits near offset {start}")
        src = src[:start] + text + src[end:]
        last = start
    return src


def line_bounds(src: str, pos: int) -> tuple[int, int]:
    ls = src.rfind("\n", 0, pos) + 1
    le = src.find("\n", pos)
    return ls, (len(src) if le < 0 else le + 1)


# --------------------------------------------------------------------------------------
# P2: vnum literals compared against .id / .vnum
# --------------------------------------------------------------------------------------

ZoneRanges = list[tuple[int, int, int]]
ARITH = {"+", "-", "*", "/", "//", "%", "^", "..", "#", "~", "&", "|", "<<", ">>"}
ORDER = {"<", "<=", ">", ">="}
INT_RE = re.compile(r"\d+$")


def vnum_to_composite(v: int, ranges: ZoneRanges) -> tuple[int, int] | None:
    for base, top, zone in ranges:
        if base <= v <= top:
            return zone, v - base
    return None


@dataclass
class P1Stats:
    statements: int = 0  # `local` statements turned into assignments
    hoisted_names: int = 0  # variables now declared before an if chain
    shadow_assigns: int = 0  # statements that now assign a visible outer local


@dataclass
class Manual:
    path: str
    line: int
    kind: str
    text: str


@dataclass
class Result:
    src: str
    p3: int = 0
    p2: int = 0
    p2_vnum_reads: int = 0
    p1: P1Stats = field(default_factory=P1Stats)
    manual: list[Manual] = field(default_factory=list)


def is_vnum_literal(t: Tok) -> bool:
    return t.kind == "num" and INT_RE.match(t.val) is not None and len(t.val) >= 4


def chain_left(toks: list[Tok], dot_idx: int) -> tuple[int, str] | None:
    """Given the index of the '.' before `id`/`vnum`, find the start of the receiver chain.

    Returns (start_tok_index, kind) with kind 'ok', or None when the receiver is not a plain
    Name(.Name | [simple])* chain (calls, parenthesised expressions, ...).
    """
    j = dot_idx - 1
    while True:
        t = toks[j]
        if t.kind == "name":
            prev = toks[j - 1] if j > 0 else None
            if prev is not None and prev.kind == "op" and prev.val == ".":
                j -= 2
                continue
            if prev is not None and prev.kind == "op" and prev.val == ":":
                return None
            return j, "ok"
        if t.kind == "op" and t.val == "]":
            # [simple] where simple is one Name/num/str token
            if (
                j >= 3
                and toks[j - 1].kind in ("name", "num", "str")
                and toks[j - 2].kind == "op" and toks[j - 2].val == "["
            ):
                j -= 3
                continue
            return None
        return None


def rewrite_p2(src: str, ranges: ZoneRanges, path: str) -> tuple[str, int, int, list[Manual]]:
    """Return (new_src, instances, vnum_reads, manual)."""
    pr = parse(src)
    toks = pr.toks
    n = len(toks)
    edits: list[tuple[int, int, str]] = []
    manual: list[Manual] = []
    count = 0

    def tv(i: int) -> str:
        return toks[i].val if 0 <= i < n else ""

    def tk(i: int) -> str:
        return toks[i].kind if 0 <= i < n else ""

    def blocked_before(i: int) -> bool:
        """The operand starting at token i is the right operand of a tighter-binding operator."""
        t = toks[i - 1] if i > 0 else None
        if t is None:
            return False
        if t.kind == "op" and t.val in ARITH:
            return True
        return t.kind == "kw" and t.val == "not"

    def after_blocked(i: int) -> bool:
        t = toks[i] if i < n else None
        if t is None:
            return False
        if t.kind == "op" and t.val in ARITH | {".", "[", "(", ":"}:
            return True
        return t.kind == "str"

    def zone_local(tok: Tok):
        z = vnum_to_composite(int(tok.val), ranges)
        if z is None:
            manual.append(Manual(path, tok.line, "no-zone-range", _line_text(src, tok.start)))
        return z

    # Value variables: `local v = chain.id` with v, chain root never reassigned.
    idvars: dict[Decl, tuple[str, str]] = {}  # decl -> (chain text, property)
    written = {r.decl for r in pr.refs if r.write and r.decl is not None}
    written_globals = {r.name for r in pr.refs if r.write and r.decl is None}
    for s in pr.stmts:
        if s.kind != "local" or len(s.decls) != 1 or not s.has_init or s.attribs:
            continue
        e = s.eq_tok + 1
        # tokens: e .. s.end must be chain . (id|vnum)
        if s.end - e < 3 or tv(s.end - 2) != "." or tv(s.end - 1) not in ("id", "vnum"):
            continue
        cl = chain_left(toks, s.end - 2)
        if cl is None or cl[0] != e:
            continue
        root = toks[e]
        root_ref = pr.ref_at.get(e)
        if root_ref is None:
            continue
        if root_ref.decl is not None:
            if root_ref.decl in written:
                continue
        elif root.val in written_globals or any(d.name == root.val for d in pr.decls):
            continue  # the receiver name is reassigned or shadowed somewhere in the file
        d = s.decls[0]
        if d in written:
            continue
        idvars[d] = (pr.src[toks[e].start : toks[s.end - 2].start], toks[s.end - 1].val)

    covered_literals: set[int] = set()

    def emit_eq(chain_text: str, prop_text: str, op: str, lit: Tok, lo: int, hi: int):
        """Replace tokens lo..hi (a `prop op NUM` comparison) with the composite test."""
        nonlocal count
        zl = zone_local(lit)
        if zl is None:
            return
        zone, local_id = zl
        if op == "==":
            new = f"{chain_text}.zone_id == {zone} and {prop_text} == {local_id}"
        else:
            new = f"{chain_text}.zone_id ~= {zone} or {prop_text} ~= {local_id}"
        if not (tv(lo - 1) == "(" and tv(hi + 1) == ")"):  # already parenthesised: `(X.id == N)`
            new = f"({new})"
        edits.append((toks[lo].start, toks[hi].end, new))
        covered_literals.add(id(lit))
        count += 1

    vnum_reads = 0
    for i, t in enumerate(toks):
        # --- X.id|vnum  ==|~=  NUM        (property on the left)
        if (
            t.kind == "name" and t.val in ("id", "vnum") and tv(i - 1) == "." and tk(i - 1) == "op"
        ):
            op_i, lit_i = i + 1, i + 2
            if tk(op_i) == "op" and tv(op_i) in ("==", "~=") and lit_i < n and is_vnum_literal(toks[lit_i]):
                cl = chain_left(toks, i - 1)
                if cl is None or blocked_before(cl[0]) or after_blocked(lit_i + 1):
                    manual.append(Manual(path, t.line, "complex-comparison", _line_text(src, t.start)))
                    continue
                chain_text = pr.src[toks[cl[0]].start : toks[i - 1].start]
                emit_eq(chain_text, f"{chain_text}.id", tv(op_i), toks[lit_i], cl[0], lit_i)
        # --- NUM ==|~= X.id|vnum          (property on the right)
        if is_vnum_literal(t) and tk(i + 1) == "op" and tv(i + 1) in ("==", "~=") and i + 2 < n:
            # find chain starting at i+2 ending in .id/.vnum
            j = i + 2
            if toks[j].kind == "name":
                k = j
                while tv(k + 1) == "." and tk(k + 2) == "name" and tv(k + 2) not in ("id", "vnum"):
                    k += 2
                if tv(k + 1) == "." and tv(k + 2) in ("id", "vnum") and tk(k + 2) == "name":
                    end_i = k + 2
                    chain_text = pr.src[toks[j].start : toks[k + 1].start]
                    if blocked_before(i) or after_blocked(end_i + 1):
                        manual.append(Manual(path, t.line, "complex-comparison", _line_text(src, t.start)))
                    else:
                        emit_eq(chain_text, f"{chain_text}.id", tv(i + 1), t, i, end_i)
        # --- v ==|~= NUM  /  NUM ==|~= v   for `local v = X.id`
        if t.kind == "name":
            ref = pr.ref_at.get(i)
            if ref is not None and ref.decl in idvars and not ref.write:
                if tv(i - 1) in (".", ":") and tk(i - 1) == "op":
                    pass
                else:
                    chain_text, prop = idvars[ref.decl]
                    if tk(i + 1) == "op" and tv(i + 1) in ("==", "~=") and i + 2 < n and is_vnum_literal(toks[i + 2]):
                        if blocked_before(i) or after_blocked(i + 3):
                            manual.append(Manual(path, t.line, "complex-comparison", _line_text(src, t.start)))
                        else:
                            emit_eq(chain_text, t.val, tv(i + 1), toks[i + 2], i, i + 2)
                    elif (
                        i >= 2 and tk(i - 1) == "op" and tv(i - 1) in ("==", "~=") and is_vnum_literal(toks[i - 2])
                        and id(toks[i - 2]) not in covered_literals
                    ):
                        if blocked_before(i - 2) or after_blocked(i + 1):
                            manual.append(Manual(path, t.line, "complex-comparison", _line_text(src, t.start)))
                        else:
                            emit_eq(chain_text, t.val, tv(i - 1), toks[i - 2], i - 2, i)

    # --- remaining `.vnum` property reads (not a runtime property) -> `.id`
    covered_spans = [(e[0], e[1]) for e in edits]

    def in_edit(pos: int) -> bool:
        return any(a <= pos < b for a, b in covered_spans)

    for i, t in enumerate(toks):
        if t.kind == "name" and t.val == "vnum" and tv(i - 1) == "." and tk(i - 1) == "op" and not in_edit(t.start):
            cl = chain_left(toks, i - 1)
            # an assignment target (`x.vnum = ...`) is not a read of the runtime property
            if tv(i + 1) == "=" and tk(i + 1) == "op":
                continue
            if cl is None:
                manual.append(Manual(path, t.line, "vnum-property", _line_text(src, t.start)))
                continue
            edits.append((t.start, t.end, "id"))
            vnum_reads += 1

    new_src = apply_edits(src, edits) if edits else src
    return new_src, count, vnum_reads, manual


def _line_text(src: str, pos: int) -> str:
    a, b = line_bounds(src, pos)
    return src[a:b].strip()


# --------------------------------------------------------------------------------------
# P2 leftovers: things we only list
# --------------------------------------------------------------------------------------


def scan_manual_p2(src: str, path: str) -> list[Manual]:
    """List vnum-related constructs the rewriter does not touch (run on the rewritten source)."""
    pr = parse(src)
    toks = pr.toks
    n = len(toks)
    out: list[Manual] = []
    seen: set[tuple[int, str]] = set()

    def add(line: int, kind: str, text: str) -> None:
        if (line, kind) not in seen:
            seen.add((line, kind))
            out.append(Manual(path, line, kind, text))

    def tv(i: int) -> str:
        return toks[i].val if 0 <= i < n else ""

    idprops = {i for i, t in enumerate(toks) if t.kind == "name" and t.val in ("id", "vnum") and tv(i - 1) == "."}
    # variables holding a vnum literal anywhere in the file
    literal_vars = set()
    for i, t in enumerate(toks):
        if t.kind == "name" and tv(i + 1) == "=" and toks[i + 1].kind == "op" and i + 2 < n and is_vnum_literal(toks[i + 2]):
            if tv(i - 1) not in (".",):
                literal_vars.add(t.val)
    # multi-assignment `a, b = "x", 55577` : crude, names on the left whose value is a literal
    for i, t in enumerate(toks):
        if t.kind == "op" and t.val == "=" and i > 0 and toks[i - 1].kind == "name":
            lhs = []
            j = i - 1
            while j >= 0 and toks[j].kind == "name":
                lhs.append(toks[j].val)
                if j - 1 >= 0 and tv(j - 1) == ",":
                    j -= 2
                else:
                    break
            lhs.reverse()
            rhs = []
            j = i + 1
            while j < n:
                if toks[j].kind in ("num", "str", "name") or toks[j].val in ("true", "false", "nil"):
                    rhs.append(toks[j])
                    if tv(j + 1) == ",":
                        j += 2
                        continue
                break
            if len(lhs) == len(rhs) > 1:
                for nm, rv in zip(lhs, rhs):
                    if is_vnum_literal(rv):
                        literal_vars.add(nm)

    for i in sorted(idprops):
        line = toks[i].line
        t = toks[i]
        # range comparisons
        nxt, nxt2 = tv(i + 1), tv(i + 2)
        if nxt in ORDER and i + 2 < n and toks[i + 2].kind == "num" and len(toks[i + 2].val) >= 4:
            add(line, "range", _line_text(src, t.start))
        # arithmetic with a vnum-sized literal (or zone_id * 100 + id)
        if nxt in ARITH and i + 2 < n and toks[i + 2].kind == "num" and len(toks[i + 2].val) >= 4:
            add(line, "arithmetic", _line_text(src, t.start))
        # X.id == name / name == X.id  where the name holds a vnum literal
        if nxt in ("==", "~=") and i + 2 < n and toks[i + 2].kind == "name" and toks[i + 2].val in literal_vars:
            add(line, "var-compare", _line_text(src, t.start))
    # id-variable comparisons left over (range, arithmetic, var holding a vnum)
    idvars = set()
    for s in pr.stmts:
        if s.kind == "local" and len(s.decls) == 1 and s.has_init and s.end - s.eq_tok == 4 and tv(s.end - 2) == "." and tv(s.end - 1) in ("id", "vnum"):
            idvars.add(s.decls[0])
    for r in pr.refs:
        if r.decl in idvars:
            i = r.tok
            nxt = tv(i + 1)
            line = toks[i].line
            if nxt in ORDER and i + 2 < n and toks[i + 2].kind == "num" and len(toks[i + 2].val) >= 4:
                add(line, "range", _line_text(src, toks[i].start))
            if nxt in ("==", "~=") and i + 2 < n and toks[i + 2].kind == "name" and toks[i + 2].val in literal_vars:
                add(line, "var-compare", _line_text(src, toks[i].start))
            if nxt in ("==", "~=") and i + 2 < n and is_vnum_literal(toks[i + 2]):
                add(line, "unconverted-compare", _line_text(src, toks[i].start))
    # tables keyed by vnums: `{ id = 16105, ... }` / `{ vnum = ... }`
    for i, t in enumerate(toks):
        if t.kind == "name" and t.val in ("id", "vnum") and tv(i + 1) == "=" and toks[i + 1].kind == "op" and i + 2 < n and is_vnum_literal(toks[i + 2]) and tv(i - 1) in ("{", ","):
            add(t.line, "vnum-table", _line_text(src, t.start))
    # quest variables read into a local, then compared with a vnum literal while the file also
    # stores/compares `.id` in quest vars (those hold the local id only)
    qvars = set()
    for s in pr.stmts:
        if s.kind == "local" and len(s.decls) == 1 and s.has_init and tv(s.eq_tok + 1) == "actor" and "get_quest_var" in "".join(tv(k) for k in range(s.eq_tok + 1, s.end)):
            qvars.add(s.decls[0])
    stores_id = any(
        t.kind == "name" and t.val in ("set_quest_var", "get_quest_var") for t in toks
    ) and any(i in idprops for i in range(n))
    if stores_id:
        for r in pr.refs:
            if r.decl in qvars:
                i = r.tok
                if tv(i + 1) in ("==", "~=") and i + 2 < n and is_vnum_literal(toks[i + 2]):
                    add(toks[i].line, "quest-var-vnum", _line_text(src, toks[i].start))
                elif i >= 2 and tv(i - 1) in ("==", "~=") and is_vnum_literal(toks[i - 2]):
                    add(toks[i].line, "quest-var-vnum", _line_text(src, toks[i].start))
    return out


# --------------------------------------------------------------------------------------
# P1: branch-scoped locals used after the chain
# --------------------------------------------------------------------------------------


def if_path(d_block: Block) -> tuple[list[Stmt], Block]:
    """If statements from the declaring branch outwards, and the first non-branch block."""
    out: list[Stmt] = []
    blk = d_block
    while blk.kind == "ifbranch":
        s = blk.owner
        out.append(s)
        blk = s.block
    return out, blk


def rewrite_p1(src: str, path: str) -> tuple[str, P1Stats, list[Manual]]:
    """Hoist branch-scoped locals that are used after the chain.

    Two cases, both the converter's "DG variables are script-wide" mistake:
      * no visible binding of the name: `local x` is hoisted before the outermost if statement
        that a later use follows, and the branch declarations become plain assignments;
      * an outer local of the same name is visible and the later use reads *that* one: the
        branch `local` shadows it, so it just becomes an assignment to the outer variable.
    Returns (new_src, stats, manual).
    """
    pr = parse(src)
    toks = pr.toks
    manual: list[Manual] = []
    cands = [d for d in pr.decls if d.kind == "local" and d.block.kind == "ifbranch"]
    hoist: dict[Stmt, Stmt] = {}  # local stmt -> if stmt the declaration is hoisted before
    assign: set[Stmt] = set()  # local stmts whose names are assigned to a visible outer local

    for d in cands:
        stmt = d.stmt
        path_stmts, _ = if_path(d.block)
        chosen = None
        shadow_use = False
        for s in path_stmts:  # innermost -> outermost; keep the outermost with a use
            a = s.block
            for r in pr.refs:
                if r.name != d.name or not (s.end <= r.tok < a.end):
                    continue
                if r.decl is None and d.outer is None:
                    chosen = s
                    break
                if r.decl is not None and r.decl is d.outer:
                    shadow_use = True
        if chosen is None and not shadow_use:
            continue
        if stmt.attribs:
            manual.append(Manual(path, toks[stmt.start].line, "local-attrib", _line_text(src, toks[stmt.start].start)))
            continue
        if chosen is not None:
            prev = hoist.get(stmt)
            if prev is None or path_stmts.index(chosen) > path_stmts.index(prev):
                hoist[stmt] = chosen
        else:
            assign.add(stmt)

    # a declaration inside a statement that is hoisted for the same name becomes an assignment too
    changed = True
    while changed:
        changed = False
        for stmt in pr.stmts:
            if stmt.kind != "local" or stmt.attribs or stmt.block.kind != "ifbranch":
                continue
            path_stmts, _ = if_path(stmt.block)
            names = {d.name for d in stmt.decls}
            for s in reversed(path_stmts):  # outermost first
                if any(hs is s and names & {d.name for d in o.decls} for o, hs in hoist.items()):
                    if hoist.get(stmt) is not s:
                        hoist[stmt] = s
                        assign.discard(stmt)
                        changed = True
                    break

    # multi-name statements: names without an outer binding need a hoisted declaration
    per_if: dict[Stmt, list[str]] = {}
    for stmt, s in sorted(hoist.items(), key=lambda kv: kv[0].start):
        names = per_if.setdefault(s, [])
        for d in stmt.decls:
            if d.name not in names:
                names.append(d.name)
    for stmt in list(assign):
        if any(d.outer is None for d in stmt.decls):
            manual.append(Manual(path, toks[stmt.start].line, "mixed-shadow-local", _line_text(src, toks[stmt.start].start)))
            assign.discard(stmt)

    edits: list[tuple[int, int, str]] = []
    for s, names in per_if.items():
        first = toks[s.start].start
        ls, _ = line_bounds(src, first)
        indent = src[ls:first]
        decl = "local " + ", ".join(names)
        if indent.strip() == "":
            edits.append((ls, ls, f"{indent}{decl}\n"))
        else:
            edits.append((first, first, f"{decl}; "))
    for stmt in list(hoist) + list(assign):
        a = toks[stmt.start].start
        if stmt.has_init:
            edits.append((a, toks[stmt.start + 1].start, ""))  # drop `local `
        elif stmt in assign:
            names = ", ".join(d.name for d in stmt.decls)
            edits.append((a, toks[stmt.end - 1].end, f"{names} = nil"))
        else:
            b = toks[stmt.end - 1].end
            ls, le = line_bounds(src, a)
            if src[ls:a].strip() == "" and src[b:le].strip() == "":
                edits.append((ls, le, ""))
            else:
                a2 = a
                while a2 > ls and src[a2 - 1] in " \t":
                    a2 -= 1
                edits.append((a2, b, ""))
    new_src = apply_edits(src, edits) if edits else src
    stats = P1Stats(
        statements=len(hoist) + len(assign),
        hoisted_names=sum(len(v) for v in per_if.values()),
        shadow_assigns=len(assign),
    )
    return new_src, stats, manual


# --------------------------------------------------------------------------------------
# P3 (opt-in): `.local_id` on actors/objects
# --------------------------------------------------------------------------------------


def rewrite_local_id(src: str, path: str) -> tuple[str, int, list[Manual]]:
    """`X.local_id` -> `X.id`.

    mud-script exposes `.local_id` on rooms only; on mobs, objects and actors it reads as nil
    while `.id` is the local id on all of them (rooms accept both). Opt-in: pass
    --local-id-to-id (or run the runtime with a `local_id` alias instead).
    """
    pr = parse(src)
    toks = pr.toks
    keyed = any(
        t.kind == "name" and t.val == "local_id" and toks[i + 1].val == "=" and toks[i + 1].kind == "op"
        and (toks[i - 1].val in ("{", ",", ";", ".") if i > 0 else True)
        for i, t in enumerate(toks[:-1])
    )
    if keyed:
        first = next(t for t in toks if t.kind == "name" and t.val == "local_id")
        return src, 0, [Manual(path, first.line, "local-id-field", "table field/assignment named local_id; left alone")]
    edits = [
        (t.start, t.end, "id")
        for i, t in enumerate(toks)
        if t.kind == "name" and t.val == "local_id" and i > 0 and toks[i - 1].kind == "op" and toks[i - 1].val == "."
    ]
    return (apply_edits(src, edits) if edits else src), len(edits), []


# --------------------------------------------------------------------------------------
# Driver
# --------------------------------------------------------------------------------------


def process(src: str, ranges: ZoneRanges, path: str = "<mem>", local_id_to_id: bool = False) -> Result:
    res = Result(src)
    try:
        s1, p2, vreads, man2 = rewrite_p2(src, ranges, path)
    except LuaSyntaxError as e:
        res.manual.append(Manual(path, 0, "parse-error", str(e)))
        return res
    res.p2, res.p2_vnum_reads = p2, vreads
    res.manual += man2
    s2, p1, man1 = rewrite_p1(s1, path)
    res.p1 = p1
    res.manual += man1
    if local_id_to_id:
        s2, res.p3, man3 = rewrite_local_id(s2, path)
        res.manual += man3
    res.src = s2
    res.manual += scan_manual_p2(s2, path)
    # the same site can be found by both rewriters and scanners; keep unique entries
    uniq: dict[tuple[int, str, str], Manual] = {}
    for m in res.manual:
        uniq.setdefault((m.line, m.kind, m.text), m)
    res.manual = list(uniq.values())
    return res


def find_zon_dir() -> Path | None:
    for p in ROOT.parents:
        if (p / "lib" / "world" / "zon").is_dir():
            return p / "lib" / "world" / "zon"
    return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("paths", nargs="*", type=Path, default=[ROOT / "data" / "triggers"])
    ap.add_argument("--zon", type=Path, default=None, help="lib/world/zon directory")
    ap.add_argument("--check", action="store_true", help="report only, write nothing")
    ap.add_argument(
        "--local-id-to-id", action="store_true",
        help="also rewrite X.local_id to X.id (local_id is nil on mobs/objects/actors in mud-script)",
    )
    ap.add_argument("--manual-out", type=Path, default=None, help="write the manual list here")
    args = ap.parse_args()

    from fierylib.converters.dg_to_lua import build_zone_ranges

    zon = args.zon or find_zon_dir()
    if zon is None:
        sys.exit("lib/world/zon not found; pass --zon")
    ranges = build_zone_ranges(zon)
    if not ranges:
        sys.exit(f"no zone ranges under {zon}")

    files: list[Path] = []
    for p in args.paths:
        files += sorted(p.rglob("*.lua")) if p.is_dir() else [p]

    changed = 0
    tot_p2 = tot_vreads = tot_p3 = 0
    tot_p1 = P1Stats()
    p2_files = p1_files = 0
    manual: list[Manual] = []
    for f in files:
        src = f.read_text(encoding="utf-8")
        res = process(
            src, ranges, str(f.relative_to(ROOT)) if f.is_relative_to(ROOT) else str(f), args.local_id_to_id
        )
        manual += res.manual
        tot_p2 += res.p2
        tot_p1.statements += res.p1.statements
        tot_p1.hoisted_names += res.p1.hoisted_names
        tot_p1.shadow_assigns += res.p1.shadow_assigns
        tot_vreads += res.p2_vnum_reads
        tot_p3 += res.p3
        p2_files += 1 if (res.p2 or res.p2_vnum_reads) else 0
        p1_files += 1 if res.p1.statements else 0
        if res.src != src:
            changed += 1
            if not args.check:
                f.write_text(res.src, encoding="utf-8")
    print(
        f"files scanned {len(files)}, changed {changed} | "
        f"P2: {tot_p2} comparisons in {p2_files} files (+{tot_vreads} .vnum reads) | "
        f"P1: {tot_p1.statements} locals de-localised ({tot_p1.hoisted_names} hoisted declarations, "
        f"{tot_p1.shadow_assigns} shadow-to-assign) in {p1_files} files | "
        + (f"local_id->id: {tot_p3} | " if args.local_id_to_id else "")
        + f"manual: {len(manual)}"
    )
    by_kind: dict[str, int] = {}
    for m in manual:
        by_kind[m.kind] = by_kind.get(m.kind, 0) + 1
    for k, c in sorted(by_kind.items(), key=lambda kv: -kv[1]):
        print(f"  manual {k}: {c}")
    if args.manual_out:
        lines = [
            "# Trigger scripts that need manual work after fix_trigger_patterns.py",
            "",
            "Generated by `scripts/fix_trigger_patterns.py --check --manual-out`. Kinds:",
            "- `range`: `.id` compared with `<`/`>` against legacy vnums (`id >= 55300 and id <= 55383`). Usually one",
            "  zone, so `zone_id == 553 and id >= 0 and id <= 83`; left alone on purpose.",
            "- `var-compare`: `.id` compared with a variable that holds a legacy vnum.",
            "- `quest-var-vnum`: a quest variable that stores `.id` (the local id only) is compared with a vnum.",
            "- `vnum-table`: a table keyed by legacy vnums, matched in another trigger.",
            "- `no-zone-range`: the vnum falls outside every zone range in lib/world/zon.",
            "- `mixed-shadow-local` and `local-attrib` (P1): shapes the hoisting does not handle.",
            "",
        ]
        by_file: dict[str, list[Manual]] = {}
        for m in manual:
            by_file.setdefault(m.path, []).append(m)
        for path, ms in sorted(by_file.items(), key=lambda kv: (-len(kv[1]), kv[0])):
            lines.append(f"## {path} ({len(ms)})")
            for m in sorted(ms, key=lambda m: m.line):
                lines.append(f"- L{m.line} [{m.kind}] `{m.text[:140]}`")
            lines.append("")
        args.manual_out.write_text("\n".join(lines), encoding="utf-8")
    return 0


if __name__ == "__main__":
    sys.exit(main())
