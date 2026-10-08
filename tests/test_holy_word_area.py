"""Holy Word is an area spell like Unholy Word (issue fierymud-rs#81)."""

import json
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-holy-word-area.sql").read_text(encoding="utf-8")


def _ability(plain_name):
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == plain_name]
    return ability


def test_holy_word_is_an_area_spell_like_unholy_word():
    holy = _ability("HOLY_WORD")
    assert holy["isArea"] is True
    assert holy["violent"] is True
    assert holy["isArea"] == _ability("UNHOLY_WORD")["isArea"]


def test_holy_word_keeps_its_alignment_rules():
    holy = _ability("HOLY_WORD")
    assert holy["targetRestrictions"][0]["value"] == "evil"
    assert holy["casterRestrictions"][0]["value"] == "good"


def test_sql_patch_is_scoped_and_idempotent():
    assert "'HOLY_WORD'" in SQL
    assert SQL.count('UPDATE "Ability"') == 1
    assert "is_area = true" in SQL
    assert "'ROOM_ENEMIES'" in SQL
    assert "AND (is_area = false OR target_scope = 'SINGLE')" in SQL
