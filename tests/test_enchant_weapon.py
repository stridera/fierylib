"""Enchant Weapon (alter_object enchant mode): JSON, linker and SQL patch must agree."""

import json
import re
from pathlib import Path

from fierylib.seeders.ability_effects_linker import ENCHANT_WEAPON_PARAMS

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-09-enchant-weapon.sql").read_text(encoding="utf-8")


def _ability():
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == "ENCHANT_WEAPON"]
    return ability


def test_enchant_weapon_uses_the_enchant_mode_not_item_bonus():
    (effect,) = _ability()["effects"]
    assert effect["effect"] == "alter_object"
    assert effect["params"]["mode"] == "enchant"
    assert "item_bonus" not in json.dumps(_ability())


def test_legacy_bonus_tiers():
    # hitroll 1 + (skill >= 18) -> accuracy x2; damroll 1 + (skill >= 20) -> attack_power x5
    params = _ability()["effects"][0]["params"]
    assert params["requireType"] == "WEAPON"
    assert params["setFlags"] == ["MAGIC"]
    acc, ap = params["applies"]
    assert (acc["target"], acc["amount"]) == ("accuracy", "2 + 2 * clamp(skill - 17, 0, 1)")
    assert (ap["target"], ap["amount"]) == ("attack_power", "5 + 5 * clamp(skill - 19, 0, 1)")


def test_alignment_bars_and_glow_messages():
    params = _ability()["effects"][0]["params"]
    assert (params["goodCasterBars"], params["evilCasterBars"]) == ("EVIL", "GOOD")
    assert params["messageToCasterGood"] == "{item} glows blue."
    assert params["messageToCasterEvil"] == "{item} glows red."
    assert params["messageToCasterNeutral"] == "{item} glows yellow."


def test_targets_carried_or_worn_objects_only():
    assert _ability()["targeting"]["validTargets"] == ["OBJECT_INV"]


def test_linker_params_match_json():
    assert ENCHANT_WEAPON_PARAMS == _ability()["effects"][0]["params"]


def test_sql_param_literal_matches_json():
    literals = [json.loads(m) for m in re.findall(r"'(\{.*?\})'::jsonb", SQL)]
    assert _ability()["effects"][0]["params"] in literals


def test_alter_object_effect_documents_the_enchant_mode():
    effects = json.loads((DATA / "effects.json").read_text(encoding="utf-8"))
    (effect,) = [e for e in effects if e["name"] == "alter_object"]
    assert "enchant" in effect["paramSchema"]["properties"]["mode"]["enum"]
    assert "restriction" not in effect["paramSchema"].get("required", [])


def test_sql_is_guarded_for_idempotency():
    assert "override_params->>'target' = 'item_bonus'" in SQL
    assert 'ON CONFLICT (ability_id, effect_id, "order") DO NOTHING' in SQL
    assert "ON CONFLICT (ability_id) DO NOTHING" in SQL
    assert "NOT LIKE '%enchant mode%'" in SQL
