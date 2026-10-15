"""Mob RECEIVE triggers: the legacy item filter and the `return 0` refusal survive the conversion.

Legacy receive_mtrigger (dg_triggers.cpp) runs a script for a given item only when the item vnum
passes the trigger's arg list: a non-zero num_arg means "only these items", num_arg 0 means "every
item except these" (the paired *_refuse triggers). Neither lives in the Lua files unless the script
tests `object` itself, and the importer stores no arg_list for Lua files, so a trigger without the
check fires for every item (30:30 handed out a prize for any junk).

A script's `return 0` means the give is cancelled and the giver keeps the item. The converter used
to turn it into `_return_value = true` (accept). The engine (docs/SCRIPTING.md, RECEIVE) cancels the
give when the body returns false before its first wait(); once a wait() has run the item counts as
accepted. A refusal that talks first therefore has to `return false` before the wait, or hand the
item back itself (dg.give / give_back) when the story needs the pause.

tests/receive_triggers.json is the facts this needs from the legacy DG source (which is not in this
repo): per mob RECEIVE trigger its arg list as (zone, id) item keys, num_arg, how many `return 0`
it has and whether it reads %object.%. Regenerate it with
`python tests/test_receive_filters.py write [LEGACY_TRG_DIR]` (default ../../lib/world/trg).
"""

import json
import re
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

TRIGGER_DIR = ROOT / "data" / "triggers"
MANIFEST = Path(__file__).with_name("receive_triggers.json")
LEGACY_TRG = ROOT.parent / "lib" / "world" / "trg"
LUA = shutil.which("lua5.4") or shutil.which("lua")

# DG vnum -> (zone, id) for objects, the same rule as data/script_libraries/dg.lua: the zone files
# that run past 99 entries come first, anything else splits vnum // 100 (zone 0 is stored as 1000).
OBJ_RANGES = [
    (200, 399, 2), (400, 599, 4), (2300, 2408, 23), (3000, 3306, 30), (11700, 11812, 117),
    (12000, 12158, 120), (12300, 12499, 123), (30000, 30128, 300), (32400, 32573, 324),
    (48100, 48252, 481), (48400, 48503, 484), (50000, 50106, 500), (53400, 53506, 534),
    (58000, 58299, 580),
]

# Scripts whose `return 0` is intentionally not a refusal, or that cannot refuse yet.
EXEMPT_RETURN_0 = {
    # `return 0` comes after `wait 5` in both branches, so legacy had already taken the item; the
    # script drops it afterwards.
    (1000, 9): "return 0 follows wait 5: the item is taken, then dropped",
    # The four `return 0` sit in the type_wand quest branches that were never ported (see the
    # TODO in 052_15); the Lua only handles the flameball path and consumes the item.
    (52, 14): "type_wand refusal branches are not ported",
}

# `return false` that runs after a wait(): the engine ignores it. Each is on a path that consumes
# the item (or hands it back with a give) anyway, so nothing is lost. Do not add new entries; make
# the refusal return before the first wait().
KNOWN_RETURN_AFTER_WAIT = {
    "051_02": "the statue quest consumes the ring",
    "120_03": "the tree quest consumes the item",
    "300_07": "both branches consume the item",
}


def split_obj(vnum: int) -> tuple[int, int]:
    for lo, hi, zone in OBJ_RANGES:
        if lo <= vnum <= hi:
            return zone, vnum - zone * 100
    zone = vnum // 100
    return (zone or 1000), vnum % 100


def lua_files() -> dict[tuple[int, int], Path]:
    out = {}
    for path in sorted(TRIGGER_DIR.glob("*/*.lua")):
        head = path.read_text(encoding="utf-8")
        z = re.search(r"^-- Zone: (\d+), ID: (\d+)$", head, re.M)
        if z and re.search(r"^-- Type: MOB, Flags:.*\bRECEIVE\b", head, re.M):
            out[(int(z.group(1)), int(z.group(2)))] = path
    return out


def code_of(path: Path) -> str:
    """The script without comment lines."""
    return "\n".join(
        line for line in path.read_text(encoding="utf-8").split("\n") if not line.lstrip().startswith("--")
    )


def is_stub(code: str) -> bool:
    return re.sub(r"\s", "", code) == "returntrue"


def build_manifest(trg_dir: Path) -> list[dict]:
    from fierylib.parsers.trigger_parser import ScriptType, parse_trigger_file

    rows = []
    for trg in sorted(trg_dir.glob("*.trg")):
        for t in parse_trigger_file(trg):
            if t.script_type != ScriptType.MOB or "RECEIVE" not in t.flags:
                continue
            vnums = [int(w) for w in t.arg_string.split() if w.isdigit()]
            rows.append({
                "vnum": t.vnum,
                "key": [(0 if t.zone_id == 0 else t.zone_id) or 1000, t.local_id],
                "num_arg": t.probability,
                "items": [list(split_obj(v)) for v in vnums],
                "return_0": len(re.findall(r"\breturn\s+0\b", t.commands)),
                "reads_object": bool(re.search(r"%object[.%]", t.commands)),
            })
    return sorted(rows, key=lambda r: r["vnum"])


def manifest() -> list[dict]:
    return json.loads(MANIFEST.read_text(encoding="utf-8"))


def lua_for(row, files):
    """The Lua file of a manifest row. Trigger vnum 302 is stored as 2:102, so look it up by the
    `Zone/ID` header of the file whose zone * 100 + id is the DG vnum."""
    for (z, i), path in files.items():
        if (0 if z == 1000 else z * 100) + i == row["vnum"]:
            return path
    return None


def item_checked(code: str, zone: int, item: int) -> bool:
    pair = rf"object\.zone_id\s*==\s*{zone}\s+and\s+object\.(?:local_)?id\s*==\s*{item}\b"
    flipped = rf"object\.(?:local_)?id\s*==\s*{item}\s+and\s+object\.zone_id\s*==\s*{zone}\b"
    return bool(re.search(pair, code) or re.search(flipped, code))


def item_mentioned(code: str, zone: int, item: int) -> bool:
    """The script compares `object` with the item: zone/id pair, `is_obj(object, vnum)` or a local
    `obj_is(zone, id)` helper."""
    vnum = zone * 100 + item
    return bool(
        item_checked(code, zone, item)
        or re.search(rf"is_obj\(object,\s*{vnum}\)", code)
        or re.search(rf"\bobj_is\(\s*{zone}\s*,\s*{item}\s*\)", code)
    )


def test_manifest_matches_legacy_source():
    if not LEGACY_TRG.is_dir():
        pytest.skip("legacy lib/world/trg not checked out")
    assert manifest() == build_manifest(LEGACY_TRG), "regenerate: python tests/test_receive_filters.py write"


def test_every_manifest_trigger_has_a_lua_file():
    files = lua_files()
    missing = [r["vnum"] for r in manifest() if lua_for(r, files) is None]
    assert not missing, f"no RECEIVE Lua file for DG triggers {missing}"


def test_arg_list_item_filter_is_in_the_script():
    files = lua_files()
    bad = []
    for row in manifest():
        if not row["items"]:
            continue
        path = lua_for(row, files)
        code = code_of(path)
        if is_stub(code):
            continue
        if not re.search(r"\bobject\b", code):
            bad.append(f"{path.name}: has an arg list but never reads `object`")
            continue
        missing = [i for i in row["items"] if not item_mentioned(code, *i)]
        if missing:
            bad.append(f"{path.name}: never mentions item(s) {missing}")
    assert not bad, "\n".join(bad)


def test_scripts_that_read_the_object_reference_it():
    files = lua_files()
    bad = []
    for row in manifest():
        if not row["reads_object"]:
            continue
        code = code_of(lua_for(row, files))
        if not is_stub(code) and not re.search(r"\bobject\b", code):
            bad.append(lua_for(row, files).name)
    assert not bad, f"DG reads %object.% but the Lua never mentions object: {bad}"


GIVE_BACK = re.compile(r"give_back|dg\.give\(self, object|\"give \"[^\n]*object\.(?:alias|name)")


def test_return_0_refusals_return_false_or_hand_the_item_back():
    files = lua_files()
    bad = []
    for row in manifest():
        if not row["return_0"] or tuple(row["key"]) in EXEMPT_RETURN_0:
            continue
        path = lua_for(row, files)
        code = code_of(path)
        if is_stub(code):
            continue
        if "return false" not in code and not GIVE_BACK.search(code):
            bad.append(f"{path.name}: DG has {row['return_0']} `return 0` but the Lua never returns false")
    assert not bad, "\n".join(bad)


def test_exempt_return_0_entries_still_apply():
    rows = {tuple(r["key"]): r for r in manifest()}
    for key in EXEMPT_RETURN_0:
        assert key in rows and rows[key]["return_0"], f"{key} no longer has a `return 0`; drop the exemption"


def _indent(line: str) -> int:
    return len(line) - len(line.lstrip())


def returns_after_wait(path: Path) -> list[int]:
    """1-based lines of `return false` that a wait() on the same path precedes (walking up the
    enclosing blocks: earlier statements at the same or an outer indent)."""
    lines = path.read_text(encoding="utf-8").split("\n")
    hits = []
    for n, line in enumerate(lines):
        if not re.match(r"^\s*return false\b", line):
            continue
        cur = _indent(line)
        for k in range(n - 1, -1, -1):
            prev = lines[k]
            if not prev.strip() or prev.strip().startswith("--") or _indent(prev) > cur:
                continue
            cur = min(cur, _indent(prev))
            if re.match(r"^\s*(elseif|else)\b", prev):
                continue
            if re.match(r"^\s*(wait|wait_until|wait_hours)\(", prev):
                hits.append(n + 1)
                break
    return hits


# Scripts that return an item with a give command on purpose: the item goes back after a quest step
# (the wand/mace/cup is checked and returned, not refused), or the story waits first. A refusal must
# not do this: the engine returns the item itself on `return false`.
KNOWN_GIVE_BACK = {
    "002_102": "wand accepted as a match, handed back",
    "002_108": "primed staff/wand handed back",
    "028_02": "waterform cup handed back after the sample check",
    "185_22": "legacy returns the item on every path; the success path waits",
}


def test_refusals_do_not_queue_a_give_back():
    bad = []
    for path in lua_files().values():
        code = code_of(path)
        if "return false" in code and GIVE_BACK.search(code) and re.match(r"\d+_\d+", path.name).group(0) not in KNOWN_GIVE_BACK:
            bad.append(path.name)
    assert not bad, f"a refusal returns false, the engine hands the item back; drop the give command: {bad}"


def test_refusals_return_before_the_first_wait():
    bad = {}
    for (z, i), path in lua_files().items():
        stem = re.match(r"\d+_\d+", path.name).group(0)
        hits = returns_after_wait(path)
        if hits and stem not in KNOWN_RETURN_AFTER_WAIT:
            bad[path.name] = hits
    assert not bad, f"`return false` after a wait() is ignored by the engine: {bad}"


def test_known_return_after_wait_entries_still_apply():
    by_stem = {re.match(r"\d+_\d+", p.name).group(0): p for p in lua_files().values()}
    for stem in KNOWN_RETURN_AFTER_WAIT:
        assert stem in by_stem and returns_after_wait(by_stem[stem]), f"{stem} is fixed; drop the entry"


# ---- converter -------------------------------------------------------------------------------


def run_gate(lines, zone, item):
    assert LUA, "lua not installed"
    chunk = (
        f"local object = {{zone_id = {zone}, id = {item}}}\n(function()\n"
        + "\n".join(lines)
        + "\nprint('RAN')\nend)()"
    )
    r = subprocess.run([LUA, "-"], input=chunk, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return "RAN" in r.stdout


@pytest.mark.skipif(LUA is None, reason="lua not installed")
def test_receive_gate_whitelists_with_a_num_arg():
    from fierylib.converters.dg_to_lua import receive_gate_lines

    gate = receive_gate_lines("16023", 100)
    assert run_gate(gate, 160, 23)
    assert not run_gate(gate, 160, 24)
    assert not run_gate(gate, 30, 23)


@pytest.mark.skipif(LUA is None, reason="lua not installed")
def test_receive_gate_blacklists_with_num_arg_zero():
    from fierylib.converters.dg_to_lua import receive_gate_lines

    gate = receive_gate_lines("16023 340", 0)
    assert not run_gate(gate, 160, 23)
    assert not run_gate(gate, 3, 40)
    assert run_gate(gate, 30, 23)


def test_receive_gate_is_empty_without_an_arg_list():
    from fierylib.converters.dg_to_lua import receive_gate_lines

    assert receive_gate_lines("", 100) == []
    assert receive_gate_lines("(null)", 0) == []


def test_converter_turns_receive_return_0_into_a_refusal():
    from fierylib.converters.dg_to_lua import convert_script_body

    body = textwrap.dedent("""
        return 0
        say No thanks.
    """).strip()
    assert "_return_value = false" in convert_script_body(body, receive_trigger=True)
    # COMMAND/other triggers keep the old meaning (`return 0` lets the typed command through).
    assert "_return_value = true" in convert_script_body(body)
    # The flag does not leak into the next conversion.
    assert "_return_value = true" in convert_script_body(body)


def test_converter_receive_trigger_gets_the_item_gate_and_no_chance_gate():
    from fierylib.converters.dg_to_lua import convert_trigger
    from fierylib.parsers.trigger_parser import DGTrigger, ScriptType

    dg = DGTrigger(
        vnum=3030, name="x", script_type=ScriptType.MOB, flags=["RECEIVE"], probability=0,
        arg_string="16023", commands="return 0\nsay no\n",
    )
    out = convert_trigger(dg).commands
    assert "object.zone_id == 160 and object.id == 23" in out
    assert "percent_chance" not in out
    assert "_return_value = false" in out


if __name__ == "__main__":
    if sys.argv[1:2] != ["write"]:
        raise SystemExit(__doc__)
    src = Path(sys.argv[2]) if len(sys.argv) > 2 else LEGACY_TRG
    rows = build_manifest(src)
    MANIFEST.write_text(
        "[\n" + ",\n".join(json.dumps(r, sort_keys=True) for r in rows) + "\n]\n", encoding="utf-8"
    )
    print(f"wrote {MANIFEST}")
