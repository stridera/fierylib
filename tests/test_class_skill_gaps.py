"""The class-skill gap patch must agree with the legacy class.cpp data (no DB).

fierymud-rs gates steal / summon mount on ClassSkills rows. data/classes.json
is parsed from the legacy skill_assign() calls, so it is the reference.
"""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CLASSES_JSON = ROOT / "data" / "classes.json"
SQL = (ROOT / "data" / "sql" / "2026-10-09-class-skill-gaps.sql").read_text(encoding="utf-8")

GATED = {"STEAL", "SUMMON_MOUNT"}


def _legacy_rows() -> dict[tuple[str, str], int]:
    """(class plain name lower, skill) -> min level for the gated skills."""
    data = json.loads(CLASSES_JSON.read_text(encoding="utf-8"))
    by_id = {c["id"]: (c["plainName"] or c["className"]).lower() for c in data["classes"]}
    return {
        (by_id[r["classId"]], r["skillName"]): r["minLevel"]
        for r in data["classSkills"]
        if r["skillName"] in GATED
    }


def _sql_rows() -> dict[tuple[str, str], int]:
    return {
        (cls.lower(), skill): int(level)
        for cls, skill, level in re.findall(r"\('([A-Za-z-]+)',\s*'([A-Z_]+)',\s*(\d+)\)", SQL)
    }


def test_sql_rows_match_legacy_class_cpp():
    legacy = _legacy_rows()
    assert legacy == {
        ("thief", "STEAL"): 10,
        ("bard", "STEAL"): 10,
        ("paladin", "SUMMON_MOUNT"): 15,
        ("anti-paladin", "SUMMON_MOUNT"): 15,
    }
    assert _sql_rows() == legacy


def test_assassin_has_no_steal_in_legacy():
    assert ("assassin", "STEAL") not in _legacy_rows()


def test_claw_and_electrify_are_not_class_skills_in_legacy():
    data = json.loads(CLASSES_JSON.read_text(encoding="utf-8"))
    assert not {"CLAW", "ELECTRIFY"} & {r["skillName"] for r in data["classSkills"]}
    # So the patch must not invent rows for them.
    assert "'CLAW'" not in SQL and "'ELECTRIFY'" not in SQL


def test_patch_is_keyed_by_name_and_idempotent():
    assert "ON CONFLICT (class_id, ability_id) DO NOTHING" in SQL
    assert "c.plain_name" in SQL and "a.plain_name" in SQL
    # Never a numeric class / ability id literal.
    assert not re.search(r"\b(class_id|ability_id)\s*=\s*\d", SQL)
