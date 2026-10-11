"""Ice Dagger conjures legacy object 1047 (zone 10, id 47) wielded: JSON, effects schema and SQL patch agree."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-10-ice-dagger-conjure.sql").read_text(encoding="utf-8")


def _ability():
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == "ICE_DAGGER"]
    return ability


def test_conjures_the_legacy_dagger_and_wields_it():
    (effect,) = _ability()["effects"]
    assert effect["effect"] == "create"
    # Legacy read_object(1047, VIRTUAL): composite zone 10, id 47.
    assert effect["params"]["objectZoneId"] == 10
    assert effect["params"]["objectId"] == 47
    assert effect["params"]["wield"] is True


def test_is_no_longer_a_targeted_attack():
    ability = _ability()
    assert ability["violent"] is False
    assert "savingThrows" not in ability
    assert "damage" not in json.dumps(ability["effects"])
    assert set(ability["messages"]) == {"successToCaster", "successToRoom"}


def test_sql_param_literal_matches_json():
    literals = [json.loads(m) for m in re.findall(r"'(\{.*?\})'::jsonb", SQL)]
    assert _ability()["effects"][0]["params"] in literals


def test_sql_messages_match_json():
    messages = _ability()["messages"]
    assert f"'{messages['successToCaster']}'" in SQL
    assert f"'{messages['successToRoom']}'" in SQL
    assert f"'{_ability()['description']}'" in SQL


def test_create_effect_documents_the_object_params():
    effects = json.loads((DATA / "effects.json").read_text(encoding="utf-8"))
    (effect,) = [e for e in effects if e["name"] == "create"]
    props = effect["paramSchema"]["properties"]
    assert {"objectZoneId", "objectId", "wield"} <= set(props)
    assert props["wield"]["type"] == "boolean"
    assert _ability()["effects"][0]["params"]["objectType"] in props["objectType"]["enum"]
