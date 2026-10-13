#!/usr/bin/env python3
"""Fix DG-style truthiness tests on quest getters in the trigger corpus (data/triggers).

Legacy DG `if %actor.quest_stage[x]%` is false for 0 (an empty or '0'-leading
value is false, see `process_if` in dg_scripts.cpp). The Lua binding
`actor:get_quest_stage(name)` returns the integer 0 for "no quest" because most
scripts compare it numerically (`== 1`, `>= 2`, `< 1`), and 0 is truthy in Lua.
So every script that tests it directly never takes the "not started" branch:

    if not actor:get_quest_stage("dragon_slayer") then   -- never true
    elseif actor:get_quest_stage("dragon_slayer") then   -- always true

The same holds for `actor:get_quest_var("quest:var")` on a variable a script
stores as 0 (`set_quest_var(quest, var, 0)` reads back as the integer 0).

The engine's return type stays; the scripts are rewritten in condition position:

    not actor:get_quest_stage("q")      ->  actor:get_quest_stage("q") == 0
    actor:get_quest_stage("q") then     ->  actor:get_quest_stage("q") > 0 then
    not actor:get_quest_var("q:v")      ->  (actor:get_quest_var("q:v") or 0) == 0
    actor:get_quest_var("q:v") then     ->  (actor:get_quest_var("q:v") or 0) ~= 0 then

and the same for a local that holds the result (`local stage = actor:get_quest_stage(..)`
then `if not stage` / `elseif stage then`), written null-safe as `(stage or 0) == 0`.

Only calls that are tested bare in an `if` / `elseif` / `while` condition are
touched (comparisons, arithmetic, `or 0` defaults and plain assignments are
already correct). `get_quest_var` is only rewritten for (quest, var) literals
that some script stores as 0. Idempotent.

Usage:
    python scripts/fix_quest_stage_truthiness.py [--check] [PATH ...]

PATH may be files or directories (default: data/triggers). --check reports
without writing and exits 1 when something would change.
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

CALL_RE = re.compile(r"(?P<recv>\b\w+):(?P<fn>get_quest_stage|get_quest_var)\((?P<args>[^()]*)\)")
ASSIGN_RE = re.compile(
    r"^\s*(?:local\s+)?(?P<var>\w+)\s*=\s*\w+:(?P<fn>get_quest_stage|get_quest_var)\((?P<args>[^()]*)\)\s*$"
)
SET_ZERO_RE = re.compile(r"""set_quest_var\(\s*"([^":"]+)"\s*,\s*"([^"]+)"\s*,\s*(?:0|"0")\s*\)""")
SET_ZERO_JOINED_RE = re.compile(r"""set_quest_var\(\s*"([^":"]+):([^"]+)"\s*,\s*(?:0|"0")\s*\)""")
KEY_RE = re.compile(r'^\s*"([^":"]+):([^"]+)"\s*$')

CONDITION_START_RE = re.compile(r"^\s*(?:if|elseif|while|and|or|not)\b")
# A bare operand follows one of these keywords (or an opening group paren).
KEYWORD_END_RE = re.compile(r"(?:^|[^\w.:])(?:if|elseif|while|and|or|until)$")
# A bare operand is followed by the end of the condition or a boolean joiner.
SUFFIX_BARE_RE = re.compile(r"^\s*(?:$|then\b|and\b|or\b(?!\s+0\b)|\)|,)")


@dataclass
class Report:
    files_changed: int = 0
    rewrites: Counter = field(default_factory=Counter)  # kind -> count
    changed_paths: list[str] = field(default_factory=list)


def collect_zero_vars(paths: list[Path]) -> set[tuple[str, str]]:
    """(quest, var) literals that some script stores as 0."""
    zero: set[tuple[str, str]] = set()
    for path in paths:
        for line in path.read_text(encoding="utf-8").splitlines():
            for m in SET_ZERO_RE.finditer(line):
                zero.add((m.group(1), m.group(2)))
            for m in SET_ZERO_JOINED_RE.finditer(line):
                zero.add((m.group(1), m.group(2)))
    return zero


def is_tracked_getter(fn: str, args: str, zero: set[tuple[str, str]]) -> str | None:
    """'stage' / 'var' when the call can legitimately read back as 0, else None."""
    if fn == "get_quest_stage":
        return "stage"
    m = KEY_RE.match(args)
    if m and (m.group(1), m.group(2)) in zero:
        return "var"
    return None


def _polarity(prefix: str, suffix: str) -> str | None:
    """'pos' / 'neg' when the operand between `prefix` and `suffix` is a bare
    truthiness test in a condition, else None (comparison, arithmetic, `or 0`
    default, assignment, function argument)."""
    if not SUFFIX_BARE_RE.match(suffix):
        return None
    head = prefix.rstrip()
    negated = re.search(r"(?:^|[^\w.:])not$", head) is not None
    if negated:
        head = head[: -len("not")].rstrip()
    if head == "" or KEYWORD_END_RE.search(head):
        return "neg" if negated else "pos"
    if head.endswith("(") and not (len(head) > 1 and (head[-2].isalnum() or head[-2] == "_")):
        return "neg" if negated else "pos"
    return None


def fix_line(line: str, zero: set[tuple[str, str]], tracked: dict[str, str], rep: Report) -> str:
    code = line
    if code.lstrip().startswith("--") or not CONDITION_START_RE.match(code):
        return line

    def edit_calls(text: str) -> str:
        out: list[tuple[int, int, str, str]] = []
        for m in CALL_RE.finditer(text):
            kind = is_tracked_getter(m.group("fn"), m.group("args"), zero)
            if kind is None:
                continue
            polarity = _polarity(text[: m.start()], text[m.end() :])
            if polarity is None:
                continue
            call = m.group(0)
            if kind == "stage":
                repl = f"{call} == 0" if polarity == "neg" else f"{call} > 0"
            else:
                repl = f"({call} or 0) == 0" if polarity == "neg" else f"({call} or 0) ~= 0"
            out.append((m.start(), m.end(), polarity, repl))
            rep.rewrites[f"direct {m.group('fn')} {polarity}"] += 1
        # apply right to left so offsets stay valid
        for start, end, polarity, repl in reversed(out):
            head = text[:start]
            if polarity == "neg":
                head = re.sub(r"\bnot\s*$", "", head)
            text = head + repl + text[end:]
        return text

    def edit_vars(text: str) -> str:
        edits = []
        for var, kind in tracked.items():
            for m in re.finditer(rf"(?<![\w.:\"']){re.escape(var)}\b", text):
                polarity = _polarity(text[: m.start()], text[m.end() :])
                if polarity is None:
                    continue
                if kind == "stage":
                    repl = f"({var} or 0) == 0" if polarity == "neg" else f"({var} or 0) > 0"
                else:
                    repl = f"({var} or 0) == 0" if polarity == "neg" else f"({var} or 0) ~= 0"
                edits.append((m.start(), m.end(), polarity, repl))
                rep.rewrites[f"local {kind} {polarity}"] += 1
        edits.sort(reverse=True)
        for start, end, polarity, repl in edits:
            head = text[:start]
            if polarity == "neg":
                head = re.sub(r"\bnot\s*$", "", head)
            text = head + repl + text[end:]
        return text

    return edit_vars(edit_calls(code))


def fix_text(src: str, zero: set[tuple[str, str]], rep: Report) -> str:
    lines = src.split("\n")
    tracked: dict[str, str] = {}
    for line in lines:
        if line.lstrip().startswith("--"):
            continue
        m = ASSIGN_RE.match(line)
        if m:
            kind = is_tracked_getter(m.group("fn"), m.group("args"), zero)
            if kind:
                tracked[m.group("var")] = kind
    return "\n".join(fix_line(line, zero, tracked, rep) for line in lines)


def lua_files(targets: list[Path]) -> list[Path]:
    files: list[Path] = []
    for t in targets:
        files.extend(sorted(t.rglob("*.lua")) if t.is_dir() else [t])
    return files


def run(targets: list[Path], check: bool, zero_from: list[Path] | None = None) -> Report:
    files = lua_files(targets)
    zero = collect_zero_vars(lua_files(zero_from) if zero_from else files)
    rep = Report()
    for path in files:
        src = path.read_text(encoding="utf-8")
        new = fix_text(src, zero, rep)
        if new != src:
            rep.files_changed += 1
            rep.changed_paths.append(str(path))
            if not check:
                path.write_text(new, encoding="utf-8")
    return rep


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--check", action="store_true", help="report without writing")
    ap.add_argument("paths", nargs="*", type=Path)
    args = ap.parse_args(argv)
    targets = args.paths or [DEFAULT_DIR]
    # The set of vars stored as 0 comes from the whole corpus, whatever paths are fixed.
    rep = run(targets, args.check, zero_from=[DEFAULT_DIR])
    total = sum(rep.rewrites.values())
    print(f"{rep.files_changed} files, {total} rewrites")
    for kind, n in sorted(rep.rewrites.items()):
        print(f"  {kind}: {n}")
    return 1 if args.check and rep.files_changed else 0


if __name__ == "__main__":
    sys.exit(main())
