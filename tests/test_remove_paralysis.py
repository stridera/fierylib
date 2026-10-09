"""Remove Paralysis lifts Minor Paralysis, Major Paralysis and Entangle (legacy magic.cpp:4837)."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-remove-paralysis.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}

CONDITIONS = ["minor_paralysis", "major_paralysis", "entangle"]
MESSAGE = "<b:yellow>Your body begins to move again.</>"
ROOM_MESSAGE = "<b:yellow>{target.name} begins to move again.</>"


def _key(name):
    # remove_effects_for_condition compares punctuation-insensitively.
    return re.sub(r"[^a-z0-9]", "", name.lower())


def _cleanse_rows(ability):
    return [e for e in ability.get("effects", []) if e["effect"] == "cleanse"]


def test_remove_paralysis_cleanses_the_three_legacy_conditions_only():
    ability = BY_NAME["REMOVE_PARALYSIS"]
    (row,) = _cleanse_rows(ability)
    params = row["params"]
    assert params["condition"] == CONDITIONS
    assert params["message"] == MESSAGE
    assert params["roomMessage"] == ROOM_MESSAGE
    assert len(ability["effects"]) == 1


def test_every_condition_names_an_ability_the_runtime_can_match():
    plain = {_key(name) for name in BY_NAME}
    for condition in CONDITIONS:
        assert _key(condition) in plain, condition


def test_conditions_do_not_name_web_bind_or_bone_cage():
    # Legacy leaves Web alone; Bind and Bone Cage are not in its list either.
    keys = {_key(c) for c in CONDITIONS}
    assert not keys & {"web", "bind", "bonecage", "paralyzed", "webbed", "paralysis"}


def test_entangle_and_both_paralyses_are_status_abilities_that_record_their_flag():
    # The status instance records its casting ability, so the plain-name match is what frees them.
    flags = {}
    for name in ("ENTANGLE", "MINOR_PARALYSIS", "MAJOR_PARALYSIS"):
        (status,) = [e for e in BY_NAME[name]["effects"] if e["effect"] == "status"]
        flags[name] = status["params"]["flag"]
    assert flags == {"ENTANGLE": "webbed", "MINOR_PARALYSIS": "paralyzed", "MAJOR_PARALYSIS": "paralyzed"}
    assert BY_NAME["ENTANGLE"]["effects"][0]["params"]["upgrade"]["flag"] == "paralyzed"


def test_catalog_no_longer_claims_to_dispel_magic():
    assert "messages" not in BY_NAME["REMOVE_PARALYSIS"]
    description = BY_NAME["REMOVE_PARALYSIS"]["description"]
    assert "Entangle" in description and "Major Paralysis" in description


def test_no_cleanse_row_strips_everything_or_names_nothing():
    for name, ability in BY_NAME.items():
        for row in _cleanse_rows(ability):
            condition = row["params"].get("condition")
            conditions = condition if isinstance(condition, list) else [condition]
            assert conditions and all(c and c != "all" for c in conditions), name


def test_sql_literals_match_json():
    assert "jsonb_build_array('minor_paralysis', 'major_paralysis', 'entangle')" in SQL
    assert BY_NAME["REMOVE_PARALYSIS"]["description"] in SQL
    assert BY_NAME["REMOVE_PARALYSIS"]["notes"] in SQL


def test_sql_is_keyed_by_names_only_and_idempotent():
    for name in ("'REMOVE_PARALYSIS'", "'cleanse'"):
        assert name in SQL
    # Ability ids differ between dev and prod: nothing may hard-code one.
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\ba\.id\s*=\s*\d", SQL)
    # Each statement only rewrites rows still in the old shape.
    assert "ae.override_params->>'condition' = 'paralysis'" in SQL
    assert SQL.count("UPDATE ") == 3
    assert "INSERT" not in SQL and "DELETE" not in SQL
