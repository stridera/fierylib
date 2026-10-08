"""Curse / Remove Curse on objects (fierymud-rs#77): JSON and SQL patch must agree."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-08-curse-objects.sql").read_text(encoding="utf-8")


def _ability(plain_name):
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    (ability,) = [a for a in abilities if a["plainName"] == plain_name]
    return ability


def _alter(plain_name):
    (effect,) = [e for e in _ability(plain_name)["effects"] if e["effect"] == "alter_object"]
    return effect


def _jsonb_literals():
    return [json.loads(m) for m in re.findall(r"'(\{.*?\})'::jsonb", SQL)]


def test_alter_object_effect_exists_in_effects_json():
    effects = json.loads((DATA / "effects.json").read_text(encoding="utf-8"))
    (effect,) = [e for e in effects if e["name"] == "alter_object"]
    assert effect["effectType"] == "alter_object"
    assert effect["defaultParams"]["restriction"] == "NO_DROP"


def test_curse_adds_no_drop_and_shrinks_weapon_dice():
    params = _alter("CURSE")["params"]
    assert (params["restriction"], params["mode"], params["weaponDiceSizeDelta"]) == (
        "NO_DROP",
        "add",
        -1,
    )


def test_remove_curse_lifts_no_drop_and_restores_the_die():
    params = _alter("REMOVE_CURSE")["params"]
    assert (params["restriction"], params["mode"], params["weaponDiceSizeDelta"]) == (
        "NO_DROP",
        "remove",
        1,
    )


def test_both_spells_target_objects_in_inventory_and_room():
    for name in ("CURSE", "REMOVE_CURSE"):
        valid = _ability(name)["targeting"]["validTargets"]
        assert "OBJECT_INV" in valid and "OBJECT_WORLD" in valid
    assert "ENEMY_NPC" in _ability("CURSE")["targeting"]["validTargets"]


def test_sql_param_literals_match_json():
    literals = _jsonb_literals()
    assert _alter("CURSE")["params"] in literals
    assert _alter("REMOVE_CURSE")["params"] in literals


def test_sql_is_guarded_for_idempotency():
    assert "WHERE NOT EXISTS (SELECT 1 FROM \"Effect\" WHERE name = 'alter_object')" in SQL
    assert SQL.count('ON CONFLICT (ability_id, effect_id, "order") DO NOTHING') == 2
    assert SQL.count("ON CONFLICT (ability_id) DO NOTHING") == 2
    assert "NOT LIKE '%impossible to drop%'" in SQL
