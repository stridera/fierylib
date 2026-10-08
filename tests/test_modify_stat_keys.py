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
    "focus", "perception", "hit_regen", "hiddenness",
}  # fmt: skip

# Known gaps: no equivalent in apply_modify_delta yet (needs runtime support, not a data rename).
UNSUPPORTED_KNOWN = {"armor", "item_bonus", "self", "size", "unarmed_damage", "weapon_hitroll"}


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
