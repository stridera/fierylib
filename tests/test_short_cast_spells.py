"""Spells legacy casts at CAST_SPEED1 carry the 'short_cast' tag (no DB)."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-09-instant-spells.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))


def _tagged():
    return {a["plainName"] for a in ABILITIES if "short_cast" in (a.get("tags") or [])}


def test_sql_list_matches_json_tags():
    block = SQL[SQL.index("ANY(ARRAY[") : SQL.index("\n])")]
    assert set(re.findall(r"'([A-Z_]+)'", block)) == _tagged()
    assert len(_tagged()) == 18


def test_only_sub_round_spells_are_tagged_and_true_instants_are_not():
    by_name = {a["plainName"]: a for a in ABILITIES}
    for name in _tagged():
        assert by_name[name]["abilityType"] == "SPELL"
        assert by_name[name]["castTimeRounds"] == 0.5
    # Word of Recall is the one class spell among them.
    assert "WORD_OF_RECALL" in _tagged()
    # Not castable in legacy (no spello): they stay instant.
    assert "short_cast" not in (by_name["PYRE_RECOIL"].get("tags") or [])
    assert "short_cast" not in (by_name["FRACTURE_SHRAPNEL"].get("tags") or [])


def test_sql_is_idempotent_and_keyed_by_plain_name():
    assert "NOT ('short_cast' = ANY(" in SQL
    assert "array_append" in SQL
    assert "WHERE plain_name = ANY" in SQL
