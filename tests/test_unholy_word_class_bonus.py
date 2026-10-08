"""Unholy Word's diabolist/anti-paladin 1.25x bonus is data, not a hard-coded class check."""

import json
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-unholy-word-class-bonus.sql").read_text(encoding="utf-8")
EXPECTED = {"diabolist": 1.25, "anti-paladin": 1.25}


def _damage_params(plain_name):
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == plain_name]
    (damage,) = [e for e in ability["effects"] if e["effect"] == "damage"]
    return damage["params"]


def test_unholy_word_source_data_carries_the_class_multiplier():
    params = _damage_params("UNHOLY_WORD")
    assert params["casterClassMultiplier"] == EXPECTED
    # The existing lifeform multiplier is untouched.
    assert params["multipliers"][0]["max"] == 1.5


def test_class_keys_are_lowercase_plain_names():
    classes = json.loads((DATA / "classes.json").read_text(encoding="utf-8"))["classes"]
    names = {str(c["plainName"]).lower() for c in classes}
    for key in _damage_params("UNHOLY_WORD")["casterClassMultiplier"]:
        assert key == key.lower()
        assert key in names


def test_sql_patch_is_scoped_idempotent_and_never_keyed_by_class_id():
    assert "a.plain_name = 'UNHOLY_WORD'" in SQL
    assert "e.name = 'damage'" in SQL
    assert SQL.count('UPDATE "AbilityEffect"') == 1
    assert (
        "'{\"casterClassMultiplier\": {\"diabolist\": 1.25, \"anti-paladin\": 1.25}}'::jsonb" in SQL
    )
    assert "NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'casterClassMultiplier')" in SQL
    # Ids differ between dev and prod: the patch must not reference Class ids.
    assert "class_id" not in SQL.lower()
    assert '"Class"' not in SQL


def test_sql_multiplier_matches_source_data():
    import re

    blob = re.search(r"'(\{\"casterClassMultiplier\".*?\}\})'::jsonb", SQL)
    assert blob
    assert json.loads(blob.group(1))["casterClassMultiplier"] == EXPECTED
