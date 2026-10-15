"""Lint: a trigger must not compare an entity or room handle with a number.

DG scripts compared `%self.room%` and `%actor.room%` with the legacy room vnum
(`if %self.room% == 12018`). In Lua `self.room` / `actor.room` is a room handle, never a number,
so `self.room == 12018` is always false (druid 120:3 could never succeed). The same goes for
`self`, `actor`, `object`, `victim`... compared with a literal. Compare the composite key
instead:

    self.room.zone_id == 120 and self.room.local_id == 18

or turn the handle into a legacy number for a stored quest variable:

    require("dg").to_vnum(actor.room.zone_id, actor.room.local_id)

Checked: a handle expression (`self`, `actor`, `object`, `victim`, anything ending in `.room`,
`.worn_by`, `.fighting`, `.leader`, `.master`, or `get_room(...)`)
on one side of `==  ~=  <  <=  >  >=` and a number literal on the other, or a local that the file
only ever assigns number literals to (`local place = 4328 ... place == actor.room`).

Comments and string literals are blanked first, so prose and messages never trip it.
Run `python tests/test_trigger_handle_compare.py` to print every finding.
"""

import re
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parent.parent
SCAN_DIRS = (ROOT / "data" / "triggers", ROOT / "data" / "script_libraries")

# Scripts that still compare a handle with a number and need a full rewrite, not a one-line fix
# (their header says NEEDS_REVIEW / TODO(parity): branch-scoped locals, string-vs-int stage
# compares, ...). Fixing one makes test_known_findings_still_exist fail until it is removed.
KNOWN: dict[str, str] = {
    "053/053_42_monk_vision_command_read.lua":
        "monk vision: `place == actor.room` (place is a legacy room number); needs the DG #5342 rewrite",
    "188/188_80_ctf_armband_tag.lua":
        "capture the flag: `actor.room >= zone_a_start` (legacy room ranges); NEEDS_REVIEW, rewrite with 188:97",
    "188/188_97_fierytag_bat_capturetheflag.lua":
        "capture the flag: `actor.room >= zone_a_start` (legacy room ranges); NEEDS_REVIEW, rewrite with 188:80",
}

# Names the engine binds (always handles). Other names (`person`, `target`, `rnd`...) are loop
# counters or random rolls as often as handles, so they only count with a `.room`-style suffix.
HANDLE_WORDS = r"(?:self|actor|object|victim)"
HANDLE_SUFFIX = r"(?:\.(?:room|worn_by|fighting|leader|master))*+"
HANDLE = (
    rf"(?:(?<![\w.]){HANDLE_WORDS}{HANDLE_SUFFIX}"
    r"|[\w\]\)]+\.(?:room|worn_by|fighting|leader|master)"
    r"|(?<![\w.])get_room\s*\([^()]*\))"
)
NUMBER = r"-?\d+(?:\.\d+)?"
OP = r"(?:==|~=|<=|>=|<|>)"

ASSIGN = re.compile(r"^\s*(?:local\s+)?([A-Za-z_]\w*)\s*=\s*(.+?)\s*$")


def blank(src: str) -> str:
    """Replace comments and string literals with spaces (keeping newlines and positions)."""
    out = []
    i, n = 0, len(src)
    while i < n:
        c = src[i]
        if src.startswith("--", i):
            m = re.match(r"--\[(=*)\[", src[i:])
            if m:
                end = src.find("]" + m.group(1) + "]", i + m.end())
                end = n if end < 0 else end + len(m.group(1)) + 2
            else:
                end = src.find("\n", i)
                end = n if end < 0 else end
            out.append(re.sub(r"[^\n]", " ", src[i:end]))
            i = end
        elif c in "\"'":
            j = i + 1
            while j < n and src[j] != c and src[j] != "\n":
                j += 2 if src[j] == "\\" else 1
            out.append(c + " " * (j - i - 1) + (c if j < n and src[j] == c else ""))
            i = j + 1
        elif src.startswith("[[", i) or re.match(r"\[=+\[", src[i:]):
            m = re.match(r"\[(=*)\[", src[i:])
            end = src.find("]" + m.group(1) + "]", i + m.end())
            end = n if end < 0 else end + len(m.group(1)) + 2
            out.append(re.sub(r"[^\n]", " ", src[i:end]))
            i = end
        else:
            out.append(c)
            i += 1
    return "".join(out)


def numeric_names(code: str) -> set[str]:
    """Names the file only ever assigns number literals to."""
    numeric: set[str] = set()
    other: set[str] = set()
    for line in code.splitlines():
        m = ASSIGN.match(line)
        if not m or re.match(r"^\s*(?:local\s+)?\w+\s*==", line):
            continue
        name, value = m.groups()
        (numeric if re.fullmatch(NUMBER, value) else other).add(name)
    # `for i = 1, 3 do` and `local a, b = ...` forms are not matched above; treat a name that is
    # a loop variable or part of a multiple assignment as non-numeric.
    for m in re.finditer(r"\bfor\s+(\w+)\s*=", code):
        other.add(m.group(1))
    for m in re.finditer(r"\b(?:local\s+)?(\w+(?:\s*,\s*\w+)+)\s*=(?!=)", code):
        other.update(re.split(r"\s*,\s*", m.group(1)))
    for m in re.finditer(r"\bfunction\b[^(]*\(([^)]*)\)", code):
        other.update(a.strip() for a in m.group(1).split(",") if a.strip())
    return numeric - other


def findings(src: str) -> list[tuple[int, str]]:
    code = blank(src)
    names = numeric_names(code)
    num = NUMBER if not names else rf"(?:{NUMBER}|(?<![\w.])(?:{'|'.join(map(re.escape, sorted(names)))})\b)"
    pats = [
        re.compile(rf"({HANDLE})\s*{OP}\s*({num})(?![\w.(\[:])"),
        re.compile(rf"(?<![\w.:])({num})\s*{OP}\s*({HANDLE})(?![\w(\[:]|\.(?!room|worn_by|fighting|leader|master))"),
    ]
    found = []
    for lineno, line in enumerate(code.splitlines(), 1):
        for pat in pats:
            for m in pat.finditer(line):
                found.append((lineno, m.group(0).strip()))
    return found


def scan() -> dict[str, list[tuple[int, str]]]:
    result = {}
    for base in SCAN_DIRS:
        for path in sorted(base.rglob("*.lua")):
            hits = findings(path.read_text(encoding="utf-8", errors="replace"))
            if hits:
                result[path.relative_to(base).as_posix()] = hits
    return result


# --- the lint itself -------------------------------------------------------------------------

@pytest.mark.parametrize("src", [
    "if self.room == 12018 then end",
    "if actor.room ~= 18800 then end",
    "if (actor.room >= 5436 and actor.room <= 5440) then end",
    "if 12018 == self.room then end",
    "if person.room == 12103 then end",
    "if x.worn_by == 5 then end",
    "if get_room(1, 2) == 3 then end",
    "if actor == 0 then end",
    "if person.room == 5 then end",
    "local place = 4328\nif place == actor.room then end",
    "local place\nplace = 4328\nif actor.room == place then end",
])
def test_lint_flags_handle_vs_number(src):
    assert findings(src), src


@pytest.mark.parametrize("src", [
    "if self.room.zone_id == 120 and self.room.local_id == 18 then end",
    "if actor.level == 50 then end",
    "if actor.room == self.room then end",
    "if actor.room ~= get_room(489, 80) then end",
    "if object.val2 == 11 then end",
    "if self.zone_id == 60 and self.id == 61 then end",
    "-- if self.room == 12018 then",
    'actor:send("self.room == 12018")',
    "local s = [[ actor.room == 5 ]]",
    "if actor:get_quest_var('x') == require('dg').to_vnum(actor.room.zone_id, actor.room.local_id) then end",
    "local place = 4328\nplace = get_room(1, 2)\nif place == actor.room then end",
    "for i = 1, 3 do if i == actor.room then end end",
    "if actor.room:count() == 3 then end",
    "if #self.room.people == 0 then end",
    "if 3 == self.room.actor_count then end",
    "local person = 0\nwhile person < 1 do person = 1 end",
    "if rnd >= 90 then end",
])
def test_lint_allows_valid_compares(src):
    assert not findings(src), src


# --- the scan --------------------------------------------------------------------------------

def test_no_handle_compared_with_number():
    bad = {f: h for f, h in scan().items() if f not in KNOWN}
    assert not bad, "handle compared with a number (use zone_id/local_id):\n" + "\n".join(
        f"  {f}:{ln}: {txt}" for f, hits in bad.items() for ln, txt in hits
    )


def test_known_findings_still_exist():
    stale = [f for f in KNOWN if f not in scan()]
    assert not stale, f"fixed, remove from KNOWN: {stale}"


if __name__ == "__main__":
    for f, hits in scan().items():
        for ln, txt in hits:
            print(f"{f}:{ln}: {txt}")
