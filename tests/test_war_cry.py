"""Legacy CHANT_WAR_CRY (magic.cpp:3206): a non-violent group buff, hitroll and damroll skill / 25 + 1."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-09-war-cry.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
WAR_CRY = next(a for a in ABILITIES if a["plainName"] == "WAR_CRY")


def test_war_cry_is_a_non_violent_group_chant():
    assert WAR_CRY["abilityType"] == "CHANT"
    assert WAR_CRY["violent"] is False
    # Non-violent isArea is what the importer turns into targetScope ROOM_ALLIES.
    assert WAR_CRY["isArea"] is True
    assert "targetScope" not in WAR_CRY
    assert "damage" not in WAR_CRY["tags"]
    assert "savingThrows" not in WAR_CRY


def test_war_cry_effects_are_hitroll_x2_and_damroll_x5_for_skill_over_25_plus_1_hours():
    rows = WAR_CRY["effects"]
    assert [r["effect"] for r in rows] == ["modify", "modify"]
    assert all(r["trigger"] == "on_cast" for r in rows)
    by_target = {r["params"]["target"]: r["params"] for r in rows}
    assert by_target["accuracy"]["amount"] == "(skill / 25 + 1) * 2"
    assert by_target["attack_power"]["amount"] == "(skill / 25 + 1) * 5"
    for params in by_target.values():
        assert params["duration"] == "skill / 25 + 1"
        assert params["durationUnit"] == "hours"


def test_war_cry_uses_the_legacy_messages():
    messages = WAR_CRY["messages"]
    assert messages["successToVictim"] == "You feel more determined than ever!"
    assert messages["successToRoom"] == "{target.name} looks more determined than ever!"
    assert messages["wearoffToTarget"] == "Your determination level returns to normal."


def test_sql_matches_the_json():
    assert WAR_CRY["description"].replace("'", "''") in SQL
    assert WAR_CRY["notes"].replace("'", "''") in SQL
    for row in WAR_CRY["effects"]:
        literal = "'" + json.dumps(row["params"]).replace("'", "''") + "'"
        assert literal in SQL
    for key in ("successToVictim", "successToRoom", "successToSelf", "successSelfRoom", "wearoffToTarget"):
        assert WAR_CRY["messages"][key].replace("'", "''") in SQL, key


def test_sql_is_keyed_by_plain_name_only_and_guarded():
    assert not re.search(r"\bid\s*=\s*\d", SQL)
    assert "AND a.violent;" in SQL  # the Ability update only touches the old violent shape
    assert "e.name = 'damage'" in SQL and "ae.trigger = 'on_hit'" in SQL
    assert "NOT EXISTS" in SQL
    assert "s.on_save_action = '\"HALF_DAMAGE\"'" in SQL
    assert "m.success_to_caster = 'You begin chanting War Cry" in SQL
