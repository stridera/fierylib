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


# --- Cooldowns (RaceAbilities.cooldown_hours / cooldown_stat / cooldown_phrase) -------------------
# Legacy do_innate SET_COOLDOWN(ch, CD_INNATE_*, n MUD_HR); do_create sets CD_INNATE_CREATE 1h.
LEGACY_HOURS = {
    "INN_SYLL": 7,
    "INN_BRILL": 7,
    "INN_STRENGTH": 7,  # chaz
    "INN_TASS": 7,
    "DARKNESS": 7,
    "ILLUMINATION": 7,
    "DIMENSION_DOOR": 7,  # faerie step
    "INN_ASCEN": 7,
    "INVISIBLE": 9,
    "FEATHER_FALL": 9,
    "HARNESS": 10,
    "STATUE": 10,
    "BLINDING_BEAUTY": 10,
    "BARKSKIN": 20,  # minus the CON skill_small bonus
    "MINOR_CREATION": 1,  # legacy `create` command
}

_COOLDOWN_ROW = re.compile(
    r"^\s+\('([A-Z_]+)', '([A-Z_]+)', (\d+), (NULL|'[A-Z]+'), '([^']+)'\)", re.M
)


def _sql_cooldowns() -> dict[tuple[str, str], tuple[int, str | None, str]]:
    return {
        (race, ability): (int(hours), None if stat == "NULL" else stat.strip("'"), phrase)
        for race, ability, hours, stat, phrase in _COOLDOWN_ROW.findall(SQL)
    }


def test_every_innate_row_gets_its_legacy_cooldown():
    cooldowns = _sql_cooldowns()
    assert set(cooldowns) == {(r, a) for r, abilities in EXPECTED.items() for a in abilities}
    for (race, ability), (hours, stat, phrase) in cooldowns.items():
        assert hours == LEGACY_HOURS[ability], (race, ability)
        assert phrase
        assert stat == ("CON" if ability == "BARKSKIN" else None), (race, ability)


def test_races_json_cooldowns_match_the_sql_patch():
    seen = {}
    for race in json.loads(RACES_JSON.read_text(encoding="utf-8"))["races"]:
        for s in race.get("skills", []):
            if "cooldownHours" in s:
                name = s["skillName"].removeprefix("SPELL_")
                seen[(race["name"].upper(), name)] = (
                    s["cooldownHours"],
                    s.get("cooldownStat"),
                    s["cooldownPhrase"],
                )
    assert seen == _sql_cooldowns()


def test_cooldown_patch_adds_columns_and_only_fills_missing_values():
    for col in ("cooldown_hours INTEGER", "cooldown_stat TEXT", "cooldown_phrase TEXT"):
        assert f'ALTER TABLE "RaceAbilities" ADD COLUMN IF NOT EXISTS {col};' in SQL
    assert "AND ra.cooldown_hours IS NULL" in SQL
    assert 'ra.race = v.race::"Race"' in SQL and "a.plain_name = v.ability" in SQL


def test_importer_passes_the_cooldown_fields_through():
    importer = ROOT / "src" / "fierylib" / "importers" / "race_importer.py"
    src = importer.read_text(encoding="utf-8")
    assert "'cooldownHours', 'cooldownStat', 'cooldownPhrase'" in src
    assert src.count("**cooldown_data") == 2  # update and create
