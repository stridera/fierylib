"""The break-on-damage patch must match the breakOnDamage / flag values in data/abilities.json."""

import json
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-break-on-damage.sql").read_text(encoding="utf-8")


def _status_params(plain_name):
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == plain_name]
    (effect,) = [e for e in ability["effects"] if e["effect"] == "status"]
    return effect["params"]


def test_entangle_and_mesmerize_break_on_hit():
    assert _status_params("ENTANGLE") == {
        **_status_params("ENTANGLE"),
        "flag": "webbed",
        "breakOnDamage": True,
    }
    mesmerize = _status_params("MESMERIZE")
    assert mesmerize["flag"] == "mesmerized"
    assert mesmerize["breakOnDamage"] is True


def test_fear_and_confusion_do_not_break_on_hit():
    for name in ("FEAR", "DOOM", "HYSTERIA", "TERROR", "CONFUSION", "CROWN_OF_MADNESS"):
        assert _status_params(name)["breakOnDamage"] is False, name
        assert f"'{name}'" in SQL


def test_major_and_minor_paralysis_unchanged():
    assert _status_params("MAJOR_PARALYSIS")["breakOnDamage"] is False
    assert _status_params("MINOR_PARALYSIS")["breakOnDamage"] is True


def test_sql_targets_match_and_is_guarded():
    assert "'ENTANGLE'" in SQL and "'MESMERIZE'" in SQL
    assert SQL.count("UPDATE \"AbilityEffect\"") == 3
    # idempotency guards: each statement only matches rows not yet converted
    assert "<> 'true'" in SQL
    assert "->>'flag' = 'paralyzed'" in SQL
    assert "->>'breakOnDamage' = 'true'" in SQL
