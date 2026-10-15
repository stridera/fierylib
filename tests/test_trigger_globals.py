"""Static hygiene scan of data/triggers/*.lua: reads of undefined globals.

The Rust engine (fierymud-rs crates/mud-script) runs each trigger body in a private `_ENV` whose
fallthrough is the sandboxed Lua stdlib plus the API below. Any other bare name that is READ and
never ASSIGNED as a global in the same script is nil at runtime: comparisons against it are
silently false, arithmetic/concatenation on it raises. Typical causes are converter artefacts
(DG `yes`/`no` literals, a `local` declared inside an if-branch and used after it, `%get.*%`).

The scan uses `luac -p -l` (GETTABUP/SETTABUP on `_ENV`), so it needs no Lua runtime state.
Run `python tests/test_trigger_globals.py` to print every finding.

DG `global <var>` state lives in the entity's `globals` table (see docs/SCRIPTING.md in
fierymud-rs): a variable another trigger on the same mob/item/room declared global is read as
`globals.name`. A bare name is a local or nil.

To fix a failure, correct the script (and the converter if the pattern comes from it). Only add
to the KNOWN_* tables when the fix needs a design call, with a comment saying why. Fixing a
listed script makes test_known_* fail until its entry is removed.
"""

import fnmatch
import re
import shutil
import subprocess
from pathlib import Path

import pytest

LUAC = shutil.which("luac5.4") or shutil.which("luac")
needs_luac = pytest.mark.skipif(LUAC is None, reason="luac not installed")

TRIGGER_DIR = Path(__file__).resolve().parent.parent / "data" / "triggers"

# Lua stdlib names left visible by the sandbox (sandbox_lua removes os, io, debug, package,
# require, load*, dofile; there is no 5.1 `unpack`/`table.getn`).
STDLIB = {
    "_G", "_ENV", "_VERSION", "assert", "collectgarbage", "coroutine", "error", "getmetatable",
    "ipairs", "math", "next", "pairs", "pcall", "print", "rawequal", "rawget", "rawlen", "rawset",
    "select", "setmetatable", "string", "table", "tonumber", "tostring", "type", "utf8", "xpcall",
}

# Bound by fierymud-rs crates/mud-script (lib.rs bind_globals/bind_api, api_extra.rs
# bind_globals) for every trigger.
ENGINE_API = {
    "actor", "self", "object", "globals", "speech", "event",
    "skills", "spells", "world", "combat", "mobiles", "objects", "time", "Effect", "zone",
    "wait", "wait_until", "wait_hours", "random", "percent_chance", "get_room",
    "run_room_trigger", "allow_command", "find_actor", "find_player", "get_obj_noadesc",
    "timestamp", "trigger_log", "wizard_notify",
}

# Per-event bindings supplied by fierymud-rs crates/mud-server/src/triggers.rs
# (extras / set_bindings). Present only for the events that fire with them.
EVENT_BINDINGS = {
    "arg", "args", "cmd", "damage", "destination", "direction", "hit", "location", "spell",
    "target", "trivial", "victim",
    # BRIBE (commands/info.rs bribe_bindings): total copper plus the coin split
    "value", "platinum", "gold", "silver", "copper",
}

# Trigger-return convention: scripts assign `_return_value` before reading it.
CONVENTION = {"_return_value"}

ALLOWED = STDLIB | ENGINE_API | EVENT_BINDINGS | CONVENTION

# --- Known, deliberately deferred findings ------------------------------------------------------
# The engine now keeps DG `global` variables in the per-entity `globals` table (see docs/SCRIPTING.md,
# "Script variables"), so a cross-trigger global is read as `globals.name`, never as a bare name. What
# is left here cannot be fixed by that: either the DG source never defined the name either (a design
# call), or the conversion itself is damaged beyond a local edit.

# Whole files: the ConnectFour / Hearts mini-games. Their state now has a home (`globals`), but the
# conversion mangled the logic (board rows glued into identifiers such as `a1a2a3a4a5a6a7`, dynamic
# names like `card%card%`, branch-scoped locals), so they need a rewrite, not a rename.
KNOWN_FILE_PATTERNS = (
    "060_6[1-9]_*",  # connect four
    "060_7[0-9]_*",  # hearts
    "060_8[0-9]_*",
)

KNOWN_NAMES: dict[str, set[str]] = {
    # Object trigger on the journal item: `macestep` is a mob-side global of the mace questmasters
    # and was never defined on the journal in the DG source either (legacy read it as empty).
    "004_53_spirit_maces_progress_journal.lua": {"macestep"},
    # Undefined in the DG source too (legacy rendered them as empty / compared them as ""): the
    # fix is a design call on what the value should be.
    "004_60_eye_of_the_tiger_progress_journal.lua": {"master"},
    "023_14_hell_trident_speech_trident_upgrades.lua": {"hellstage"},
    "188_70_smart_combat.lua": {"outside", "outdoors"},
    # `%get.*%` DG remnants (documented converter bug: there is no `get` global).
    "004_49_air_wand_progress_journal.lua": {"get", "place"},
    "004_50_fire_wand_progress_journal.lua": {"get"},
    "004_51_ice_wand_progress_journal.lua": {"get"},
    "004_52_acid_wand_progress_journal.lua": {"get"},
    # NEEDS_REVIEW rewrites: `person` was never assigned in the DG source either; the whole
    # reward block (expmod) is mid-rewrite, see the header TODO.
    "030_83_dragon_slayer_isilynor_receive.lua": {"person"},
    "053_13_beast_master_ranger_trophy_receive.lua": {"person"},
    "053_23_honus_order_receive.lua": {"person"},
    "053_38_elemental_chaos_hakujo_mission_receive.lua": {"person"},
}


def is_known(filename: str, name: str) -> bool:
    if name in KNOWN_NAMES.get(filename, ()):
        return True
    return any(fnmatch.fnmatch(filename, pat) for pat in KNOWN_FILE_PATTERNS)


_OP = re.compile(r'\[(\d+)\]\s+(GETTABUP|SETTABUP)\s.*;\s+_ENV "([^"]+)"')


def scan_script(path: Path) -> list[tuple[str, int]]:
    """Return [(name, line)] for global reads that no global assignment in the script covers."""
    out = subprocess.run(
        [LUAC, "-p", "-l", str(path)], capture_output=True, text=True, check=True
    ).stdout
    reads: list[tuple[str, int]] = []
    writes: set[str] = set()
    for m in _OP.finditer(out):
        line, op, name = int(m.group(1)), m.group(2), m.group(3)
        (reads.append((name, line)) if op == "GETTABUP" else writes.add(name))
    seen: set[str] = set()
    findings = []
    for name, line in reads:
        if name in ALLOWED or name in writes or name in seen:
            continue
        seen.add(name)
        findings.append((name, line))
    return findings


def scan_all() -> list[tuple[str, str, int]]:
    found = []
    for path in sorted(TRIGGER_DIR.rglob("*.lua")):
        for name, line in scan_script(path):
            found.append((path.name, name, line))
    return found


@needs_luac
def test_no_new_undefined_global_reads():
    new = [f for f in scan_all() if not is_known(f[0], f[1])]
    assert not new, "undefined global reads (file, name, first line):\n" + "\n".join(
        f"  {f}:{ln}  {name}" for f, name, ln in new
    )


@needs_luac
def test_known_names_still_exist():
    live = {(f, n) for f, n, _ in scan_all()}
    stale = sorted(
        (f, n) for f, names in KNOWN_NAMES.items() for n in names if (f, n) not in live
    )
    assert not stale, f"fixed or removed, drop these KNOWN_NAMES entries: {stale}"


@needs_luac
def test_known_file_patterns_still_match_something():
    files = {f for f, _, _ in scan_all()}
    dead = [p for p in KNOWN_FILE_PATTERNS if not any(fnmatch.fnmatch(f, p) for f in files)]
    assert not dead, f"patterns with no findings, drop them: {dead}"


# --- Arithmetic on booleans ---------------------------------------------------------------------
# DG evaluates `(a != 4) + (b != 4)` as 1 + 0; in Lua a comparison is a boolean and adding two of
# them raises at runtime. Detected from the bytecode: a register loaded by LFALSESKIP
# (a materialised comparison) or NOT that is then an operand of an arithmetic op. Literal
# `true`/`false` (LOADTRUE) is ignored: locals are reused across branches, so flow-insensitive
# tracking would flag them falsely.
_ARITH_RR = {"ADD", "SUB", "MUL", "DIV", "MOD", "POW", "IDIV"}
_ARITH_RK = {"ADDK", "SUBK", "MULK", "DIVK", "MODK", "POWK", "IDIVK", "ADDI"}
_ARITH_UNARY = {"UNM", "LEN"}
_BOOL_SOURCES = {"LFALSESKIP", "NOT"}
# ops that never overwrite their first operand register
_NO_WRITE = {
    "EQ", "LT", "LE", "EQK", "EQI", "LTI", "LEI", "GTI", "GEI", "TEST", "JMP", "TFORCALL",
    "SETTABUP", "SETTABLE", "SETFIELD", "SETI", "SETLIST", "CLOSE", "RETURN", "RETURN0",
    "RETURN1", "TBC", "FORLOOP", "FORPREP", "TFORLOOP", "TFORPREP", "EXTRAARG", "VARARGPREP",
    "MMBIN", "MMBINI", "MMBINK", "LOADTRUE",  # LOADTRUE closes the LFALSESKIP pair, keep tracking
}
_INSTR = re.compile(r"^\s*\d+\s+\[(\d+)\]\s+([A-Z0-9_]+)\s*(.*)$")


def scan_boolean_arithmetic(path: Path) -> list[tuple[int, str]]:
    out = subprocess.run(
        [LUAC, "-p", "-l", str(path)], capture_output=True, text=True, check=True
    ).stdout
    funcs: list[list[tuple[int, str, list[int]]]] = [[]]
    for line in out.split("\n"):
        if line.startswith(("main <", "function <")):
            funcs.append([])
        m = _INSTR.match(line)
        if m:
            operands = [int(x) for x in re.findall(r"-?\d+", m.group(3).split(";")[0])]
            funcs[-1].append((int(m.group(1)), m.group(2), operands))
    found = []
    for instrs in funcs:
        bools: set[int] = set()
        for line, op, a in instrs:
            if not a:
                continue
            if op in _ARITH_RR:
                srcs = a[1:3]
            elif op in _ARITH_RK or op in _ARITH_UNARY:
                srcs = a[1:2]
            else:
                srcs = []
            if srcs:
                if any(s in bools for s in srcs):
                    found.append((line, op))
                bools.discard(a[0])
            elif op in _BOOL_SOURCES:
                bools.add(a[0])
            elif op not in _NO_WRITE:
                bools.discard(a[0])
    return found


@needs_luac
def test_no_arithmetic_on_boolean_expressions():
    bad = [
        f"  {path.name}:{line}  {op}"
        for path in sorted(TRIGGER_DIR.rglob("*.lua"))
        for line, op in scan_boolean_arithmetic(path)
    ]
    assert not bad, (
        "arithmetic on a comparison/not result (use (cond and 1 or 0)):\n" + "\n".join(bad)
    )


@needs_luac
def test_boolean_arithmetic_detector_sees_the_bug(tmp_path):
    src = tmp_path / "t.lua"
    src.write_text(
        "local a, b = 1, 2\n"
        "local n = (a ~= 4) + (b ~= 4)\n"
        "local m = (not a) + 1\n"
        "local k = 1 + (a < 2)\n"
        "local ok = ((a == 1) and 1 or 0) + ((b == 2) and 1 or 0)\n"
        "print(n, m, k, ok)\n"
    )
    assert sorted({line for line, _ in scan_boolean_arithmetic(src)}) == [2, 3, 4]


def test_converter_counts_comparison_operands():
    from fierylib.converters.dg_to_lua import convert_command

    out = convert_command("eval n (%a% + %b% != 4) + (%c% != 4)", 0)
    assert "and 1 or 0" in out and out.count("and 1 or 0") == 2
    # plain conditions are untouched
    assert "and 1 or 0" not in convert_command("eval ok (%a% == 1) && (%b% == 2)", 0)


def test_converter_global_stores_the_local_in_the_entity_globals():
    from fierylib.converters.dg_to_lua import convert_script_body

    out = convert_script_body("set stage 3\nglobal stage\nglobal never_set\nunset stage\n")
    assert "globals.stage = stage" in out
    assert "or true" not in out
    assert "never_set" in out and "globals.never_set =" not in out
    assert "globals.stage = nil" in out


def test_converter_reads_unset_names_from_the_entity_globals():
    from fierylib.converters.dg_to_lua import convert_script_body

    out = convert_script_body(
        "eval round %round% + 1\nglobal round\nif %wandstep% > 3 && %victim_1.name% == %actor.name%\n"
        "say %round%\nendif\n"
    )
    assert "round = globals.round + 1" in out  # read before any local of that name exists
    assert "globals.wandstep > 3" in out
    assert "globals.victim_1.name" in out
    assert "tostring(round)" in out  # declared by then: the local
    assert "actor.name" in out and "globals.actor" not in out


def test_no_script_stores_the_old_or_true_artefact():
    pat = re.compile(r"globals\.(\w+) = globals\.\1 or true")
    bad = [
        f"{p.name}:{n}"
        for p in sorted(TRIGGER_DIR.rglob("*.lua"))
        for n, line in enumerate(p.read_text().splitlines(), 1)
        if pat.search(line) and not line.lstrip().startswith("--")
    ]
    assert not bad, "`globals.x = globals.x or true` stores `true`, not the value:\n" + "\n".join(bad)


def test_converter_literal_damage_assigns_damage_dealt():
    from fierylib.converters.dg_to_lua import convert_command

    assert convert_command("odamage %actor% 50 crush", 0).startswith("local damage_dealt = ")


if __name__ == "__main__":
    for f, name, ln in scan_all():
        print(f"{f}:{ln}  {name}")
    for path in sorted(TRIGGER_DIR.rglob("*.lua")):
        for line, op in scan_boolean_arithmetic(path):
            print(f"{path.name}:{line}  arithmetic on boolean ({op})")
