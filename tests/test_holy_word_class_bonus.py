"""Holy Word's priest/paladin 1.25x bonus is data, not a hard-coded class check."""

import json
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-holy-word-class-bonus.sql").read_text(encoding="utf-8")


def _damage_params(plain_name):
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == plain_name]
    (damage,) = [e for e in ability["effects"] if e["effect"] == "damage"]
    return damage["params"]


def test_holy_word_source_data_carries_the_class_multiplier():
    params = _damage_params("HOLY_WORD")
    assert params["casterClassMultiplier"] == {"priest": 1.25, "paladin": 1.25}
    # The existing lifeform multiplier is untouched.
    assert params["multipliers"][0]["max"] == 1.5


def test_class_keys_are_lowercase_plain_names():
    classes = json.loads((DATA / "classes.json").read_text(encoding="utf-8"))["classes"]
    names = {str(c["plainName"]).lower() for c in classes}
    for key in _damage_params("HOLY_WORD")["casterClassMultiplier"]:
        assert key == key.lower()
        assert key in names


def test_sql_patch_is_scoped_and_idempotent():
    assert "a.plain_name = 'HOLY_WORD'" in SQL
    assert "e.name = 'damage'" in SQL
    assert SQL.count('UPDATE "AbilityEffect"') == 1
    assert "'{\"casterClassMultiplier\": {\"priest\": 1.25, \"paladin\": 1.25}}'::jsonb" in SQL
    assert "NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'casterClassMultiplier')" in SQL
