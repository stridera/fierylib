"""Legacy MAG_GROUP refusal (spell_parser.cpp:974/1068/1166): the 'grouped' restriction rule."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-09-group-required.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}

# Every legacy MAG_GROUP ability (skills.cpp), with its legacy refusal line by kind.
GROUP = {
    "DIVINE_ESSENCE": "You can't cast this spell if you're not in a group!",
    "GROUP_ARMOR": "You can't cast this spell if you're not in a group!",
    "GROUP_HEAL": "You can't cast this spell if you're not in a group!",
    "GROUP_RECALL": "You can't cast this spell if you're not in a group!",
    "INVIGORATE": "You can't cast this spell if you're not in a group!",
    "WAR_CRY": "You can't chant this song if you're not in a group!",
    "FREEDOM_SONG": "You can't perform this if you're not in a group!",
    "HEARTHSONG": "You can't perform this if you're not in a group!",
    "HEROIC_JOURNEY": "You can't perform this if you're not in a group!",
}


def test_every_group_ability_carries_the_grouped_rule_with_its_legacy_line():
    for name, line in GROUP.items():
        requirements = BY_NAME[name]["restrictions"]["requirements"]
        assert {"type": "grouped", "message": line} in requirements, name


def test_only_group_abilities_carry_the_grouped_rule():
    carriers = {
        a["plainName"]
        for a in ABILITIES
        if any(r.get("type") == "grouped" for r in a.get("restrictions", {}).get("requirements", []))
    }
    assert carriers == set(GROUP)


def test_refusal_line_matches_the_ability_kind():
    for name, line in GROUP.items():
        kind = BY_NAME[name]["abilityType"]
        word = {"SPELL": "cast this spell", "CHANT": "chant this song", "SONG": "perform this"}[kind]
        assert word in line, name


def test_sql_names_and_lines_match_the_json():
    pairs = re.findall(r"\('([A-Z_]+)',\s+'((?:[^']|'')*)'\)", SQL)
    parsed = {name: line.replace("''", "'") for name, line in pairs}
    # The UPDATE and the INSERT carry the same list.
    assert len(pairs) == 2 * len(GROUP)
    assert parsed == GROUP


def test_sql_is_keyed_by_plain_name_only_and_guarded():
    assert not re.search(r"\bid\s*=\s*\d", SQL)
    assert SQL.count("req->>'type' = 'grouped'") == 1
    assert "NOT EXISTS" in SQL
