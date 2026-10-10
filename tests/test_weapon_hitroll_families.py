"""Every weapon-skill passive grants the legacy skill / 20 hit bonus (no DB).

Legacy calc_thaco gave GET_SKILL(weapon_proficiency) / 2 to every weapon user; the Rust passive
hook (combat.rs proto_weapon_family) matches a row's `weapon_type` against the wielded weapon's
family. data/abilities.json and the SQL patch must define one row per family.
"""

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"
SQL = (DATA / "sql" / "2026-10-10-weapon-hitroll-families.sql").read_text(encoding="utf-8")

# Ability.plain_name -> weapon_type the runtime matches.
FAMILIES = {
    "BLUDGEONING": "bludgeoning",
    "SLASHING": "slashing",
    "PIERCING": "piercing",
    "TWO_HAND_BLUDGEONING": "two_hand_bludgeoning",
    "TWO_HAND_SLASHING": "two_hand_slashing",
    "TWO_HAND_PIERCING": "two_hand_piercing",
}


def _abilities():
    return {
        a["plainName"]: a
        for a in json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    }


def test_every_weapon_skill_has_one_weapon_hitroll_row():
    abilities = _abilities()
    for plain_name, family in FAMILIES.items():
        (effect,) = abilities[plain_name]["effects"]
        assert effect["effect"] == "modify"
        assert effect["trigger"] == "passive"
        assert effect["params"] == {
            "target": "weapon_hitroll",
            "amount": "skill / 20",
            "weapon_type": family,
            "type": "passive",
        }, plain_name
        assert "passive" in abilities[plain_name]["tags"]


def test_no_other_ability_grants_weapon_hitroll():
    granted = {
        a["plainName"]
        for a in _abilities().values()
        for e in a.get("effects") or []
        if e["effect"] == "modify" and e["params"].get("target") == "weapon_hitroll"
    }
    assert granted == set(FAMILIES)


def test_sql_patch_covers_the_families_the_data_already_lacked():
    rows = dict(re.findall(r"\('([A-Z_]+)', '([a-z_]+)'\)", SQL))
    assert rows == {k: v for k, v in FAMILIES.items() if k != "BLUDGEONING"}
    assert "'weapon_hitroll'" in SQL and "skill / 20" in SQL


def test_sql_patch_is_keyed_by_name_and_guarded():
    assert "a.plain_name = f.plain_name" in SQL
    assert "NOT EXISTS" in SQL and "ON CONFLICT" in SQL


def test_sql_patch_enchant_literal_matches_json():
    literals = [json.loads(m) for m in re.findall(r"'(\{.*?\})'::jsonb", SQL)]
    assert _abilities()["ENCHANT_WEAPON"]["effects"][0]["params"] in literals
