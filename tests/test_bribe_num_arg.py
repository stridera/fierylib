"""BRIBE minimum coin value: the `-- Num arg: N` header line becomes Triggers.num_args."""

from pathlib import Path

from fierylib.importers.trigger_importer import parse_lua_trigger_file

TRIGGERS = Path(__file__).resolve().parents[1] / "data" / "triggers"

# zone dir, file prefix, legacy narg (minimum copper) from lib/world/trg
LEGACY_MINIMUMS = [
    ("1000", "1000_11", 25),
    ("018", "018_60", 100),
    ("103", "103_15", 100000),
    ("188", "188_84", 100),
    ("324", "324_13", 42),
    ("324", "324_14", 30),
    ("580", "580_04", 100000),
]


def test_header_num_arg_is_parsed(tmp_path):
    f = tmp_path / "t.lua"
    f.write_text(
        "-- Trigger: t\n-- Zone: 1, ID: 2\n-- Type: MOB, Flags: BRIBE\n-- Status: CLEAN\n"
        "-- Num arg: 42\n--\n-- Original DG Script: #102\n\nself:say('hi')\n",
        encoding="utf-8",
    )
    t = parse_lua_trigger_file(f)
    assert t.num_args == 42
    assert t.commands == "self:say('hi')"


def test_missing_num_arg_is_zero(tmp_path):
    f = tmp_path / "t.lua"
    f.write_text(
        "-- Trigger: t\n-- Zone: 1, ID: 2\n-- Type: MOB, Flags: BRIBE\n-- Status: CLEAN\n\nself:say('hi')\n",
        encoding="utf-8",
    )
    assert parse_lua_trigger_file(f).num_args == 0


def test_bribe_scripts_carry_their_legacy_minimum():
    for zone, prefix, minimum in LEGACY_MINIMUMS:
        (path,) = (TRIGGERS / zone).glob(f"{prefix}_*.lua")
        parsed = parse_lua_trigger_file(path)
        assert "BRIBE" in parsed.flags, path.name
        assert parsed.num_args == minimum, path.name
