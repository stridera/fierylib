"""The summon spells name their mob in abilities.json and the SQL patch."""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL = ROOT / "data" / "sql" / "2026-10-09-summon-mobs.sql"

# What fierymud-rs commands.rs hard-coded before the move.
EXPECTED = {
    "ANIMATE_DEAD": (54, 20),
    "CLONE": (163, 8),
    "MOUNT": (324, 21),
    "SIMULACRUM": (163, 8),
    "SPHERE_SUMMON": (52, 12),
    "SUMMON_DEMON": (510, 24),
    "SUMMON_DRACOLICH": (533, 11),
    "SUMMON_ELEMENTAL": (52, 12),
    "SUMMON_GREATER_DEMON": (160, 11),
    "SUMMON_MOUNT": (324, 21),
}


def _summon_params():
    abilities = json.loads((ROOT / "data" / "abilities.json").read_text(encoding="utf-8"))
    return {
        a["plainName"]: e["params"]
        for a in abilities
        for e in a.get("effects", [])
        if e["effect"] == "summon"
    }


def test_every_summon_effect_names_its_mob():
    params = _summon_params()
    assert set(params) == set(EXPECTED)
    for name, (zone, mob) in EXPECTED.items():
        assert (params[name]["mobZone"], params[name]["mobId"]) == (zone, mob), name


def test_sql_patch_matches_abilities_json():
    sql = SQL.read_text(encoding="utf-8")
    rows = re.findall(r"^\s+\('([A-Z_]+)', (\d+), (\d+)\)", sql, re.M)
    assert {n: (int(z), int(i)) for n, z, i in rows} == EXPECTED


def test_sql_patch_is_idempotent_in_shape():
    sql = SQL.read_text(encoding="utf-8")
    assert "?& ARRAY['mobZone', 'mobId']" in sql
    assert "COALESCE(ae.override_params, '{}'::jsonb)" in sql
    assert "DELETE" not in sql and "TRUNCATE" not in sql
