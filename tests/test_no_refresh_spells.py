"""Legacy no-refresh spells (mag_affect `refresh = false`): data/sql/2026-10-11-no-refresh-spells.sql + abilities.json."""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SQL = (ROOT / "data" / "sql" / "2026-10-11-no-refresh-spells.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((ROOT / "data" / "abilities.json").read_text(encoding="utf-8"))
SQL_NAMES = set(re.findall(r"^\s+'([A-Z_]+)',?$", SQL, re.M))


def test_sql_lists_the_seventeen_legacy_spells():
    assert len(SQL_NAMES) == 17
    assert {"STONE_SKIN", "FIRESHIELD", "SLEEP", "WEB"} <= SQL_NAMES


def test_sql_is_keyed_by_plain_name_and_guarded():
    assert "a.plain_name = ANY(ARRAY[" in SQL
    assert "NOT (COALESCE(ae.override_params, '{}'::jsonb) ? 'refresh')" in SQL
    assert not re.search(r"\bid\s*=\s*\d", SQL)


def test_json_carries_refresh_false_for_exactly_those_spells():
    flagged = {
        a["plainName"]
        for a in ABILITIES
        if any(e["params"].get("refresh") is False for e in a.get("effects", []))
    }
    assert flagged == SQL_NAMES
