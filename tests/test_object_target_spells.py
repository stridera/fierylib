"""Object-target uses of twelve spells: abilities.json, effects.json and the SQL patch must agree."""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-12-object-target-spells.sql").read_text(encoding="utf-8")

MODES = {
    "BLESS": "flags",
    "INVISIBLE": "flags",
    "DISPEL_MAGIC": "flags",
    "POISON": "poison",
    "REMOVE_POISON": "poison",
    "CREATE_WATER": "liquid",
    "PRESERVE": "corpse_timer",
    "DARK_FEAST": "corpse_feed",
    "DARKNESS": "light",
    "ILLUMINATION": "light",
}
TARGET_ONLY = ("ANIMATE_DEAD", "SUMMON_DRACOLICH")


def _abilities():
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    return {a["plainName"]: a for a in abilities}


def _alter(name):
    (effect,) = [e for e in _abilities()[name]["effects"] if e["effect"] == "alter_object"]
    return effect


def test_each_spell_has_one_alter_object_row_in_its_mode():
    for name, mode in MODES.items():
        assert _alter(name)["params"]["mode"] == mode, name
        assert _alter(name)["trigger"] == "on_cast"


# Preserve is a corpse-timer manual spell: it has no character effect, only the alter row.
ALTER_ONLY = ("PRESERVE",)


def test_alter_only_spells_have_just_the_alter_row():
    for name in ALTER_ONLY:
        effects = _abilities()[name]["effects"]
        assert [e["effect"] for e in effects] == ["alter_object"], name


def test_character_effect_is_kept_ahead_of_the_alter_row():
    for name in MODES:
        if name in ALTER_ONLY:
            continue
        effects = _abilities()[name]["effects"]
        assert len(effects) >= 2, name
        assert effects[-1]["effect"] == "alter_object", name
        orders = [e["order"] for e in effects]
        assert orders == sorted(set(orders)), name


def test_targeting_reaches_objects_and_keeps_the_character_targets():
    abilities = _abilities()
    for name in (*MODES, *TARGET_ONLY):
        valid = abilities[name]["targeting"]["validTargets"]
        assert "SELF" in valid, name
        assert any(t.startswith("OBJECT_") for t in valid), name
    # Legacy TAR_OBJ_INV vs TAR_OBJ_ROOM.
    assert "OBJECT_WORLD" in abilities["PRESERVE"]["targeting"]["validTargets"]
    assert "OBJECT_WORLD" in abilities["ANIMATE_DEAD"]["targeting"]["validTargets"]
    assert "OBJECT_WORLD" in abilities["INVISIBLE"]["targeting"]["validTargets"]
    assert "OBJECT_INV" in abilities["CREATE_WATER"]["targeting"]["validTargets"]
    assert "OBJECT_WORLD" not in abilities["BLESS"]["targeting"]["validTargets"]


def test_hostile_spells_stay_hostile():
    # ability_is_hostile reads ENEMY_* from the targeting row once there is one.
    for name in ("DISPEL_MAGIC", "POISON"):
        assert _abilities()[name]["violent"] is True
        valid = _abilities()[name]["targeting"]["validTargets"]
        assert "ENEMY_PC" in valid and "ENEMY_NPC" in valid
    for name in ("BLESS", "INVISIBLE", "REMOVE_POISON", "PRESERVE"):
        valid = _abilities()[name]["targeting"]["validTargets"]
        assert not any(t.startswith("ENEMY") for t in valid)


def test_legacy_numbers():
    bless = _alter("BLESS")["params"]
    assert bless["requireTypes"] == ["WEAPON"]
    assert bless["maxObjectLevel"] == "skill" and bless["maxObjectWeight"] == "5 * skill"
    assert bless["barAlignment"] == "EVIL"
    assert set(bless["blockedByFlags"]) == {"GLOW", "HUM", "INVISIBLE", "MAGIC"}
    assert _alter("DISPEL_MAGIC")["params"]["powerRoll"] == "random(1, 50) + skill"
    assert _alter("INVISIBLE")["params"]["setFlags"] == ["INVISIBLE"]
    assert _alter("POISON")["params"]["poisoned"] is True
    assert _alter("REMOVE_POISON")["params"]["poisoned"] is False
    assert _alter("CREATE_WATER")["params"]["amount"] == "1 + 15 * skill / 2"
    feast = _alter("DARK_FEAST")["params"]
    assert (feast["hunger"], feast["thirst"]) == (24, 24)
    assert _alter("PRESERVE")["params"]["hours"] == "level"
    assert _alter("DARKNESS")["params"]["lightAction"] == "drain"
    assert _alter("ILLUMINATION")["params"]["lightAction"] == "ignite"


def test_earth_blessing_has_no_object_use():
    # Legacy mag_alter_obj has no EARTH_BLESSING case: nothing to port.
    ability = _abilities()["EARTH_BLESSING"]
    assert "targeting" not in ability
    assert all(e["effect"] != "alter_object" for e in ability["effects"])
    assert "EARTH_BLESSING" not in SQL.replace("-- EARTH_BLESSING", "")


def _sql_blocks():
    """plain_name -> the statement that mentions it, per statement kind."""
    effect_params = {}
    for m in re.finditer(
        r"INSERT INTO \"AbilityEffect\".*?'(\{.*?\})'::jsonb.*?plain_name = '(\w+)'", SQL, re.S
    ):
        effect_params[m.group(2)] = json.loads(m.group(1).replace("''", "'"))
    targets = {}
    for m in re.finditer(
        r"INSERT INTO \"AbilityTargeting\".*?ARRAY\[(.*?)\]::\"TargetType\"\[\].*?plain_name = '(\w+)'",
        SQL,
        re.S,
    ):
        targets[m.group(2)] = re.findall(r"'(\w+)'", m.group(1))
    return effect_params, targets


def test_sql_matches_json():
    effect_params, targets = _sql_blocks()
    assert set(effect_params) == set(MODES)
    for name in MODES:
        assert effect_params[name] == _alter(name)["params"], name
    assert set(targets) == set(MODES) | set(TARGET_ONLY)
    for name, valid in targets.items():
        assert valid == _abilities()[name]["targeting"]["validTargets"], name


def test_sql_is_guarded_for_idempotency():
    assert SQL.count("NOT EXISTS (SELECT 1 FROM \"AbilityEffect\" x") == len(MODES)
    assert SQL.count("NOT EXISTS (SELECT 1 FROM \"AbilityTargeting\" t") == len(MODES) + len(
        TARGET_ONLY
    )
    assert 'ON CONFLICT (ability_id, effect_id, "order") DO NOTHING' in SQL
    assert "NOT LIKE '%corpse_feed%'" in SQL
    assert "LIKE '%Bless on an item currently has no defined action.%'" in SQL
    assert "DELETE" not in SQL.upper().replace("-- ", "")


def test_alter_object_effect_documents_the_new_modes():
    effects = json.loads((DATA / "effects.json").read_text(encoding="utf-8"))
    (effect,) = [e for e in effects if e["name"] == "alter_object"]
    modes = effect["paramSchema"]["properties"]["mode"]["enum"]
    for mode in set(MODES.values()):
        assert mode in modes
    assert "corpse_feed" in effect["description"]
    assert "corpse_feed" in SQL
    props = effect["paramSchema"]["properties"]
    used = {k for name in MODES for k in _alter(name)["params"]}
    assert used <= set(props), used - set(props)
