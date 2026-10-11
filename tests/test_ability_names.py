"""Ability display names follow one casing rule; the SQL patch and abilities.json agree."""

import json
import re
from pathlib import Path

from fierylib.converters.ability_names import (
    MINOR_WORDS,
    NAME_OVERRIDES,
    normalize_ability_name,
    title_case,
)

ROOT = Path(__file__).resolve().parents[1]
SQL = ROOT / "data" / "sql" / "2026-10-11-ability-name-case.sql"
ABILITIES = json.loads((ROOT / "data" / "abilities.json").read_text(encoding="utf-8"))


def _sql_rows():
    sql = SQL.read_text(encoding="utf-8")
    rows = re.findall(r"^  \('((?:[^']|'')*)', '((?:[^']|'')*)', '((?:[^']|'')*)'\)", sql, re.M)
    return [tuple(v.replace("''", "'") for v in row) for row in rows]


def test_minor_words_are_the_agreed_set():
    assert {"of", "the", "and", "a", "an", "in", "on", "to"} <= MINOR_WORDS


def test_title_case_lowercases_minor_words_except_first():
    assert title_case("Armor Of Gaia") == "Armor of Gaia"
    assert title_case("hellfire AND brimstone") == "Hellfire and Brimstone"
    assert title_case("THE ROOT of all") == "The Root of All"
    assert title_case("Speak In Tongues") == "Speak in Tongues"
    assert title_case("Protection from Earth") == "Protection from Earth"


def test_title_case_handles_hyphens_and_is_idempotent():
    assert title_case("anti-paladin charge") == "Anti-Paladin Charge"
    for a in ABILITIES:
        once = normalize_ability_name(a["name"], a["plainName"])
        assert normalize_ability_name(once, a["plainName"]) == once, a["plainName"]


def test_every_ability_name_in_abilities_json_is_normalised():
    bad = [
        (a["plainName"], a["name"])
        for a in ABILITIES
        if a["name"] != normalize_ability_name(a["name"], a["plainName"])
    ]
    assert not bad, bad


def test_armor_of_gaia_and_cloak_of_gaia_agree():
    names = {a["plainName"]: a["name"] for a in ABILITIES}
    assert names["ARMOR_OF_GAIA"] == "Armor of Gaia"
    assert names["CLOAK_OF_GAIA"] == "Cloak of Gaia"
    assert names["GAIAS_CLOAK"] == "Gaia's Cloak"


def test_overrides_all_name_real_abilities():
    plain = {a["plainName"] for a in ABILITIES}
    assert set(NAME_OVERRIDES) <= plain


def test_plain_names_are_untouched():
    for a in ABILITIES:
        assert re.fullmatch(r"[A-Z0-9_]+", a["plainName"]), a["plainName"]


def test_sql_patch_matches_normaliser_and_abilities_json():
    rows = _sql_rows()
    assert len(rows) == 33
    by_plain = {a["plainName"]: a["name"] for a in ABILITIES}
    for plain, old, new in rows:
        assert old != new, plain
        assert normalize_ability_name(old, plain) == new, plain
        assert by_plain[plain] == new, plain
    assert len({p for p, _, _ in rows}) == len(rows)


def test_sql_patch_is_idempotent_and_builder_safe_in_shape():
    sql = SQL.read_text(encoding="utf-8")
    assert "AND a.name = v.old_name" in sql
    assert "AND a.name <> v.new_name" in sql
    assert "plain_name =" not in sql.split("SET", 1)[1].split("FROM", 1)[0]
    assert "DELETE" not in sql and "TRUNCATE" not in sql
