"""Second modify-key pass: the importer emits modern keys and the SQL patch renames the rest."""

import re
from pathlib import Path

from fierylib.seeders.ability_effects_linker import (
    APPLY_MAPPINGS,
    WARD_MOD_SPELLS,
    AbilityEffectsLinker,
)

ROOT = Path(__file__).resolve().parents[1]
SQL = (ROOT / "data" / "sql" / "2026-10-08-modify-keys-2.sql").read_text(encoding="utf-8")

# Keys fierymud-rs apply_modify_delta rejects or never sees under these names.
LEGACY_KEYS = {"acc", "ap", "eva", "regen_hp", "armor"} | {
    f"save_{k}" for k in ("para", "rod", "petri", "breath", "spell")
}


def _linker():
    return AbilityEffectsLinker(prisma=None)


def _target(location, spell_key=None, modifier="5"):
    effect, params = _linker().map_legacy_effect(
        {"type": "modifier", "location": location, "modifier": modifier}, spell_key
    )
    assert effect == "modify"
    return params["target"]


def test_apply_mappings_emit_only_modern_keys():
    targets = {t for _, t in APPLY_MAPPINGS.values()}
    assert not targets & LEGACY_KEYS, sorted(targets & LEGACY_KEYS)


def test_combat_applies_map_to_runtime_names():
    assert _target("APPLY_HITROLL") == "accuracy"
    assert _target("APPLY_DAMROLL") == "attack_power"
    assert _target("APPLY_AC") == "evasion"
    assert _target("APPLY_SAVING_PARA") == "saving_para"
    assert _target("APPLY_SAVING_SPELL") == "saving_spell"
    assert _target("APPLY_SIZE") == "size"


def test_apply_ac_on_armor_spells_is_ward_including_gaias_cloak():
    assert "SPELL_GAIAS_CLOAK" in WARD_MOD_SPELLS
    assert _target("APPLY_AC", "SPELL_GAIAS_CLOAK") == "ward"
    assert _target("APPLY_AC", "SPELL_ARMOR") == "ward"


def test_sql_patch_renames_armor_to_ward_and_save_to_saving():
    assert "WHEN 'armor' THEN 'ward'" in SQL
    for kind in ("para", "rod", "petri", "breath", "spell"):
        assert f"WHEN 'save_{kind}' THEN 'saving_{kind}'" in SQL


def test_sql_patch_is_guarded_so_a_second_run_updates_nothing():
    assert "e.name = 'modify'" in SQL
    # Every renamed source key is in the WHERE guard; targets are never sources.
    guard = re.search(r"IN\s*\(([^)]*)\)", SQL, re.S).group(1)
    sources = set(re.findall(r"'([a-z_]+)'", guard))
    assert sources == set(re.findall(r"WHEN '([a-z_]+)' THEN", SQL))
    assert not sources & set(re.findall(r"THEN '([a-z_]+)'", SQL))
