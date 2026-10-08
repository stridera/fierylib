"""The prod patch's passive list must match the 'passive' tags in data/abilities.json (no DB)."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-passive-ability-tags.sql").read_text(encoding="utf-8")


def _json_passive():
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    return {a["plainName"] for a in abilities if "passive" in (a.get("tags") or [])}


def test_sql_list_matches_json_tags():
    block = SQL[SQL.index("ANY(ARRAY[") : SQL.index("\n])")]
    sql_names = set(re.findall(r"'([A-Z_]+)'", block))
    assert sql_names == _json_passive()
    assert len(sql_names) == 31


def test_only_skills_are_passive_and_sql_is_idempotent():
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    assert all(a["abilityType"] == "SKILL" for a in abilities if "passive" in (a.get("tags") or []))
    assert "NOT ('passive' = ANY(" in SQL
    assert "array_append" in SQL
