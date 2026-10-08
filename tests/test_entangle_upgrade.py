"""The Entangle upgrade patch must match the `upgrade` object in data/abilities.json."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-entangle-upgrade.sql").read_text(encoding="utf-8")


def _entangle_status_params():
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == "ENTANGLE"]
    (effect,) = [e for e in ability["effects"] if e["effect"] == "status"]
    return effect["params"]


def test_json_carries_legacy_upgrade():
    assert _entangle_status_params()["upgrade"] == {
        "minSkill": 40,
        "chance": "2 + skill / 14",
        "flag": "paralyzed",
        "duration": "2 + skill / 96",
    }


def test_sql_literal_matches_json():
    (literal,) = re.findall(r"'(\{\"minSkill\".*?\})'::jsonb", SQL)
    assert json.loads(literal) == _entangle_status_params()["upgrade"]


def test_sql_targets_entangle_and_is_guarded():
    assert "'ENTANGLE'" in SQL
    assert SQL.count('UPDATE "AbilityEffect"') == 1
    assert "'{upgrade}'" in SQL
    assert "NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'upgrade')" in SQL
