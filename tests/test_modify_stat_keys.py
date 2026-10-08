"""Every modify-effect stat key in data/abilities.json must be one fierymud-rs can apply (no DB)."""

import json
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "data"

# Keys (lower-cased) accepted by `apply_modify_delta` in
# fierymud-rs/crates/mud-server/src/commands.rs. Keep in sync with that match statement.
SUPPORTED = {
    "str", "strength", "str_bonus", "dex", "dexterity", "dex_bonus",
    "con", "constitution", "con_bonus", "int", "intelligence", "int_bonus",
    "wis", "wisdom", "wis_bonus", "cha", "charisma", "cha_bonus",
    "accuracy", "attack_power", "evasion", "spell_power", "armor_flat", "hardness",
    "pen_flat", "pen_pct", "ward", "ward_pct", "max_hp",
    "max_move", "max_stamina", "stamina_max", "armor_pct",
    "saving_para", "saving_rod", "saving_petri", "saving_breath", "saving_spell",
    "focus", "perception", "hit_regen", "hiddenness", "size",
}  # fmt: skip

# Known gaps: no equivalent in apply_modify_delta yet (needs runtime support, not a data rename).
# item_bonus: Enchant Weapon edits an object. unarmed_damage / weapon_hitroll: skill-scaled passives
# (Barehand, weapon skills) with no passive-effect hook and no bare-hand damage stat. self: Dodge /
# Parry, which the combat evasion roll reads from the proficiency directly.
UNSUPPORTED_KNOWN = {"item_bonus", "self", "unarmed_damage", "weapon_hitroll"}


def _modify_keys():
    abilities = json.loads((DATA / "abilities.json").read_text(encoding="utf-8"))
    return {
        (a["name"], str(e["params"].get("target")).lower())
        for a in abilities
        for e in a.get("effects", [])
        if e["effect"] == "modify"
    }


def test_modify_keys_are_supported_or_known_gaps():
    bad = {(n, k) for n, k in _modify_keys() if k not in SUPPORTED and k not in UNSUPPORTED_KNOWN}
    assert not bad, f"unsupported modify stat keys: {sorted(bad)}"


def test_legacy_abbreviations_are_gone():
    keys = {k for _, k in _modify_keys()}
    assert not keys & {"acc", "ap", "eva", "regen_hp", "save_spell"}


def test_curse_debuffs_accuracy():
    assert ("Curse", "accuracy") in _modify_keys()


def test_gaias_cloak_uses_ward_like_the_other_armor_spells():
    keys = _modify_keys()
    assert ("Gaia's Cloak", "ward") in keys
    assert ("Gaia's Cloak", "armor") not in keys
    assert ("Armor", "ward") in keys


def test_size_spells_use_the_supported_size_key():
    keys = _modify_keys()
    assert {("Reduce", "size"), ("Shapechange", "size")} <= keys
