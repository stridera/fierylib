"""Racial active abilities (`innate <ability>`, fierymud-rs #14): races.json <-> SQL patch <-> legacy table."""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RACES_JSON = ROOT / "data" / "races.json"
ABILITIES_JSON = ROOT / "data" / "abilities.json"
SQL = (ROOT / "data" / "sql" / "2026-10-10-race-innate-actives.sql").read_text(encoding="utf-8")

# Legacy do_innate (act.informative.cpp ~3962): race -> abilities cast by `innate <arg>`.
# `tren` (INN_TREN) is commented out in legacy, so no race has it.
EXPECTED = {
    "ELF": {"INN_SYLL", "HARNESS"},
    "GNOME": {"INN_BRILL", "MINOR_CREATION", "STATUE"},
    "SVERFNEBLIN": {"INN_BRILL", "STATUE"},
    "ORC": {"INN_STRENGTH"},
    "DWARF": {"INN_TASS"},
    "DUERGAR": {"INN_TASS", "INVISIBLE"},
    "DROW": {"DARKNESS", "FEATHER_FALL"},
    "FAERIE_SEELIE": {"HARNESS", "ILLUMINATION", "DIMENSION_DOOR"},
    "FAERIE_UNSEELIE": {"HARNESS", "DARKNESS", "DIMENSION_DOOR"},
    "NYMPH": {"INN_ASCEN", "BLINDING_BEAUTY"},
    "ARBOREAN": {"BARKSKIN"},
}

# Which stat each INN_* ability really modifies (legacy magic.cpp SPELL_INN_*).
INN_STAT = {
    "INN_STRENGTH": "str",
    "INN_SYLL": "dex",
    "INN_TASS": "wis",
    "INN_BRILL": "int",
    "INN_TREN": "con",
    "INN_ASCEN": "cha",
}


def _json_mapping() -> dict[str, set[str]]:
    out: dict[str, set[str]] = {}
    for race in json.loads(RACES_JSON.read_text(encoding="utf-8"))["races"]:
        for s in race.get("skills", []):
            name = s["skillName"].removeprefix("SPELL_").removeprefix("SKILL_")
            out.setdefault(race["name"].upper(), set()).add(name)
    return out


def _sql_mapping() -> dict[str, set[str]]:
    out: dict[str, set[str]] = {}
    for race, ability in re.findall(r"^\s+\('([A-Z_]+)', '([A-Z_]+)'\)", SQL, re.M):
        out.setdefault(race, set()).add(ability)
    return out


def test_races_json_has_the_legacy_innate_actives():
    got = _json_mapping()
    for race, abilities in EXPECTED.items():
        assert abilities <= got.get(race, set()), race


def test_sql_matches_the_legacy_table_exactly():
    assert _sql_mapping() == EXPECTED


def test_every_sql_row_is_in_races_json_so_reimport_agrees():
    got = _json_mapping()
    for race, abilities in _sql_mapping().items():
        assert abilities <= got[race], race


def test_abilities_exist_in_abilities_json():
    names = {a["plainName"] for a in json.loads(ABILITIES_JSON.read_text(encoding="utf-8"))}
    for abilities in EXPECTED.values():
        assert abilities <= names, abilities - names


def test_inn_abilities_modify_the_stat_the_legacy_innate_does():
    data = json.loads(ABILITIES_JSON.read_text(encoding="utf-8"))
    by_name = {a["plainName"]: a for a in data}
    for name, stat in INN_STAT.items():
        targets = [e["params"].get("target") for e in by_name[name]["effects"]]
        assert targets == [stat], (name, targets)


def test_sql_is_keyed_by_names_and_idempotent():
    assert "ON CONFLICT (race, ability_id) DO NOTHING" in SQL
    assert "a.plain_name = v.ability" in SQL
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
