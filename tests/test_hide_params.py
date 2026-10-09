"""Hide / Sneak tuning is data on the status AbilityEffect, kept in step with the SQL patch."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-hide-params.sql").read_text(encoding="utf-8")

HIDE = {
    "lowerCubic": -0.0008,
    "lowerQuadratic": 0.1668,
    "lowerLinear": -3.225,
    "dexWeight": 3,
    "intWeight": 1,
    "divisor": 40,
    "waitTicks": 40,
    "thiefWaitTicks": 20,
    "halflingGroupLevelDivisor": 30,
    "stealthRollMax": 101,
}
SNEAK = {"decayMin": 2, "decayMax": 5, "failBase": 15, "levelDivisor": 2}


def _status_params(plain_name):
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == plain_name]
    (status,) = [e for e in ability["effects"] if e["effect"] == "status"]
    return status["params"]


def test_source_data_carries_the_tuning():
    assert _status_params("HIDE")["hide"] == HIDE
    assert _status_params("SNEAK")["sneak"] == SNEAK
    # The existing status flags are untouched.
    assert _status_params("HIDE")["flag"] == "hidden"
    assert _status_params("SNEAK")["flag"] == "sneak"


def test_sql_patch_matches_source_data_and_is_keyed_by_plain_name():
    blobs = re.findall(r"'(\{\"(?:hide|sneak)\".*?\}\})'::jsonb", SQL)
    assert len(blobs) == 2
    merged = {}
    for blob in blobs:
        merged.update(json.loads(blob))
    assert merged == {"hide": HIDE, "sneak": SNEAK}
    assert "a.plain_name = 'HIDE'" in SQL
    assert "a.plain_name = 'SNEAK'" in SQL
    assert SQL.count('UPDATE "AbilityEffect"') == 2
    # Ability ids differ between dev and prod.
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\bid\s*=\s*\d", SQL)


def test_sql_patch_is_idempotent():
    assert "NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'hide')" in SQL
    assert "NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'sneak')" in SQL
