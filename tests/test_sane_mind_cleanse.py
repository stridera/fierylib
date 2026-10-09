"""Sane Mind cleanses only insanity, confusion and crown of madness (legacy magic.cpp:4808)."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-sane-mind-cleanse.sql").read_text(encoding="utf-8")
ABILITIES = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
BY_NAME = {a["plainName"]: a for a in ABILITIES}

CONDITIONS = ["insanity", "confusion", "crown_of_madness"]
MESSAGE = "Your mind comes back to reality."
ROOM_MESSAGE = "{target.name} regains {target.his} senses."


def _cleanse_rows(ability):
    return [e for e in ability.get("effects", []) if e["effect"] == "cleanse"]


def test_sane_mind_cleanses_the_three_legacy_conditions_only():
    (row,) = _cleanse_rows(BY_NAME["SANE_MIND"])
    params = row["params"]
    assert params["condition"] == CONDITIONS
    assert params["message"] == MESSAGE
    assert params["roomMessage"] == ROOM_MESSAGE
    assert len(BY_NAME["SANE_MIND"]["effects"]) == 1


def test_every_condition_names_an_ability_the_runtime_can_match():
    # remove_effects_for_condition matches the ability's plain name (punctuation-insensitive).
    plain = {re.sub(r"[^a-z0-9]", "", name.lower()) for name in BY_NAME}
    for condition in CONDITIONS:
        assert re.sub(r"[^a-z0-9]", "", condition) in plain, condition


def test_no_cleanse_row_strips_everything():
    for name, ability in BY_NAME.items():
        for row in _cleanse_rows(ability):
            condition = row["params"].get("condition")
            conditions = condition if isinstance(condition, list) else [condition]
            assert conditions and all(c and c != "all" for c in conditions), name


def test_catalog_no_longer_claims_to_dispel_magic():
    assert "messages" not in BY_NAME["SANE_MIND"]
    assert "confusion" in BY_NAME["SANE_MIND"]["description"]
    assert "insanity" in BY_NAME["SANE_MIND"]["description"]


def test_sql_literals_match_json():
    assert "'condition', jsonb_build_array('insanity', 'confusion', 'crown_of_madness')" in SQL
    assert f"'{MESSAGE}'" in SQL
    assert f"'{ROOM_MESSAGE}'" in SQL
    assert BY_NAME["SANE_MIND"]["description"] in SQL
    assert BY_NAME["SANE_MIND"]["notes"] in SQL


def test_sql_is_keyed_by_names_only_and_idempotent():
    for name in ("'SANE_MIND'", "'cleanse'"):
        assert name in SQL
    # Ability ids differ between dev and prod: nothing may hard-code one.
    assert not re.search(r"ability_id\s*=\s*\d", SQL)
    assert not re.search(r"\ba\.id\s*=\s*\d", SQL)
    # Each statement only rewrites rows still in the old shape.
    assert "ae.override_params->>'condition' = 'all'" in SQL
    assert SQL.count("UPDATE ") == 3
    assert "INSERT" not in SQL and "DELETE" not in SQL
