"""Static hygiene scan of data/triggers/*.lua: reads of undefined globals.

The Rust engine (fierymud-rs crates/mud-script) runs each trigger body in a private `_ENV` whose
fallthrough is the sandboxed Lua stdlib plus the API below. Any other bare name that is READ and
never ASSIGNED as a global in the same script is nil at runtime: comparisons against it are
silently false, arithmetic/concatenation on it raises. Typical causes are converter artefacts
(DG `yes`/`no` literals, a `local` declared inside an if-branch and used after it, `%get.*%`).

The scan uses `luac -p -l` (GETTABUP/SETTABUP on `_ENV`), so it needs no Lua runtime state.
Run `python tests/test_trigger_globals.py` to print every finding.

To fix a failure, correct the script (and the converter if the pattern comes from it). Only add
to the KNOWN_* tables when the fix needs engine support or a design call, with a comment saying
why. Fixing a listed script makes test_known_* fail until its entry is removed.
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
# Every entry below is a script that cannot be fixed by a local edit. Each needs either engine
# support (mob/object-scoped persistent variables, the DG `global`/`remote` family) or a design
# call, and is tracked by the TODO(parity) header inside the script. Do not add to these to make a
# new failure pass: fix the script (or the converter) instead.

# Whole files: broken mini-games and per-mob "paralysis" machinery whose state lives in DG
# `global` variables shared between triggers. The engine gives each fire a private _ENV, so these
# never see each other's state; they need a persistence design, not a patch.
KNOWN_FILE_PATTERNS = (
    "060_6[1-9]_*",  # connect four: board/turn state in object-scoped DG globals
    "060_7[0-9]_*",  # hearts: card/player state in object-scoped DG globals
    "060_8[0-9]_*",
    "484_1[3-6][0-9]_*",  # paralysis_prevent_* command blockers read the entangle victim slots
)

KNOWN_NAMES: dict[str, set[str]] = {
    # DG `global` state written by another trigger on the same mob/object (cross-trigger).
    "484_104_mighty_druid_random_paralysis-wear-off.lua": {f"paralysis_expire_{n}" for n in range(1, 5)},
    "004_53_spirit_maces_progress_journal.lua": {"macestep"},
    "185_26_sexton_greet.lua": {"macestep"},
    "185_28_phase_mace_sexton_speech_upgrade.lua": {"macestep", "maceattack"},
    "557_00_phase_armor_-_greet.lua": {"macestep"},
    "103_09_khysan-greet.lua": {"wandstep"},
    "123_13_megalith_quest_keeper_greet.lua": {"wandstep"},
    "481_153_mccabe_greet.lua": {"wandstep", "weapon"},
    "481_24_vulcera_greet1.lua": {"weapon"},
    "510_00_pawn_shop_nordus.lua": {"chosen"},
    "510_03_luchiaans_greeting.lua": {"magequest", "clericquest"},
    "510_05_want_to_help_luchiaans.lua": {"magequest", "clericquest"},
    "510_11_give_to_luchiaans.lua": {"magequest", "clericquest"},
    "510_07_open_display_case.lua": {"got_book"},
    "510_09_guardian_of_book.lua": {"alreadyrun"},
    "510_14_get_heart_of_phoenix.lua": {"already_got"},
    "580_100_exit_room_58196.lua": {"running"},
    "590_18_three_lever_pull.lua": {"first", "secnd", "last"},
    "557_06_guild_master_refuse.lua": {
        "maceitem2", "maceitem3", "maceitem4", "maceitem5", "mace_id",
        "hands_armor", "hands_gem", "feet_armor", "feet_gem", "wrist_armor", "wrist_gem",
        "head_armor", "head_gem", "arms_armor", "arms_gem", "legs_armor", "legs_gem",
        "body_armor", "body_gem",
    },
    "060_06_quest_timulos_training.lua": {"use_subclass"},
    "060_07_quest_timulos_merc.lua": {"use_subclass"},
    "060_08_quest_timulos_assassin.lua": {"use_subclass"},
    "060_09_quest_timulos_thief.lua": {"use_subclass"},
    # xcast is a helper trigger whose arguments (xname, xid, ...) are supplied by the caller's
    # `remote`/`global` variables; the call convention has no Lua equivalent yet.
    "188_20_xcast_xcast.lua": {"xname", "xmode", "xstars", "xmagic", "xeffect", "xamount", "xid"},
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


def test_converter_literal_damage_assigns_damage_dealt():
    from fierylib.converters.dg_to_lua import convert_command

    assert convert_command("odamage %actor% 50 crush", 0).startswith("local damage_dealt = ")


if __name__ == "__main__":
    for f, name, ln in scan_all():
        print(f"{f}:{ln}  {name}")
    for path in sorted(TRIGGER_DIR.rglob("*.lua")):
        for line, op in scan_boolean_arithmetic(path):
            print(f"{path.name}:{line}  arithmetic on boolean ({op})")
