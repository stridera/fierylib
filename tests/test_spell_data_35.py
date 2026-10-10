"""Dimension Door / Farsee / Waterform data (fierymud-rs #35); see data/sql/2026-10-10-spell-data-35.sql."""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
SQL = (DATA / "sql" / "2026-10-10-spell-data-35.sql").read_text(encoding="utf-8")
BY_NAME = {a["plainName"]: a for a in json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))}
LINKER = (ROOT / "src" / "fierylib" / "seeders" / "ability_effects_linker.py").read_text(encoding="utf-8")


def _params(plain_name, effect):
    (row,) = [e for e in BY_NAME[plain_name]["effects"] if e["effect"] == effect]
    return row["params"]


def _statements():
    return [s for s in SQL.split(";") if 'UPDATE "AbilityEffect"' in s]


def test_dimension_door_teleports_to_a_target_in_the_same_zone():
    dd = _params("DIMENSION_DOOR", "teleport")
    assert dd == {"type": "self", "destination": "target", "scope": "self", "range": "zone"}
    # Same shape as Relocate, which has no zone limit in legacy.
    relocate = _params("RELOCATE", "teleport")
    assert {k: v for k, v in dd.items() if k != "range"} == relocate


def test_farsee_is_its_own_flag_not_detect_hidden():
    assert _params("FARSEE", "status")["flag"] == "farsee"
    assert '"EFF_FARSEE": ("status", {"flag": "farsee"})' in LINKER


def test_waterform_is_not_water_breathing():
    assert _params("WATERFORM", "status")["flag"] == "waterform"


def test_sql_patch_is_keyed_by_plain_name_and_effect_name_only():
    stmts = _statements()
    assert len(stmts) == 3
    for plain, effect in (("DIMENSION_DOOR", "teleport"), ("FARSEE", "status"), ("WATERFORM", "status")):
        (stmt,) = [s for s in stmts if f"a.plain_name = '{plain}'" in s]
        assert f"e.name = '{effect}'" in stmt
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\bid\s*=\s*\d", SQL)


def test_sql_patch_matches_source_data():
    (dd,) = [s for s in _statements() if "DIMENSION_DOOR" in s]
    blob = json.loads(re.findall(r"'(\{[^}]+\})'::jsonb", dd)[-1])
    assert blob == {k: v for k, v in _params("DIMENSION_DOOR", "teleport").items() if k != "type"}
    for plain, old, new in (("FARSEE", "detect_hidden", "farsee"), ("WATERFORM", "waterbreath", "waterform")):
        (stmt,) = [s for s in _statements() if f"a.plain_name = '{plain}'" in s]
        assert f"'\"{new}\"'::jsonb" in stmt
        assert f"->>'flag' = '{old}'" in stmt


def test_sql_patch_is_idempotent():
    (dd,) = [s for s in _statements() if "DIMENSION_DOOR" in s]
    assert "NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'destination')" in dd
    # The flag swaps only match the old flag, so a second run matches no rows.
    assert SQL.count("->>'flag' = ") == 2
