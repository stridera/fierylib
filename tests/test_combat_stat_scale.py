"""Combat stat derivations score attributes on FieryMUD's 0-100 scale (playtest N1)."""

from pathlib import Path

import pytest

from fierylib.combat_formulas import (
    convert_legacy_to_modern_stats,
    derive_hit_roll_baseline,
    stat_bonus,
)

ROOT = Path(__file__).resolve().parent.parent
MOB_SQL = (ROOT / "data" / "sql" / "2026-10-12-combat-stat-scale.sql").read_text(encoding="utf-8")
CHAR_SQL = (ROOT / "data" / "sql" / "2026-10-12-character-combat-stat-scale.sql").read_text(encoding="utf-8")


@pytest.mark.parametrize(
    ("score", "bonus"),
    [(0, -10), (30, -4), (49, 0), (50, 0), (54, 0), (55, 1), (84, 6), (100, 10), (400, 10), (-400, -10)],
)
def test_stat_bonus_matches_core_stats_bonus(score, bonus):
    # fierymud-rs CoreStats::bonus: ((score - 50) / 5).clamp(-10, 10), integer division
    # (truncates toward zero, so 31..49 maps -3..0 rather than flooring a step lower).
    assert stat_bonus(score) == bonus


def test_dex_84_sparrow_is_not_inflated():
    # The old (dex - 10) // 2 gave evasion 50 + 37 + 2 = 89 for a level-1 dex-84 mob.
    assert derive_hit_roll_baseline(1, dex_score=84)["evasion"] == 50 + 6 + 2


def test_level_zero_to_five_mobs_land_near_the_symmetric_center():
    for level in range(6):
        ev = derive_hit_roll_baseline(level, dex_score=80)["evasion"]
        assert ev == 50 + 6 + 2 * level
        assert ev < 70


def test_class_dex_multiplier_applies_to_the_scaled_bonus():
    warrior = derive_hit_roll_baseline(
        1, dex_score=80, accuracy_per_level=2.7, evasion_per_level=2.0, dex_evasion_mult=1.5
    )
    assert warrior == {"accuracy": 53, "evasion": 50 + 9 + 2}  # matches the Rust level-1 warrior test


def test_mob_import_uses_the_scaled_dex_bonus():
    stats = convert_legacy_to_modern_stats(
        {"level": 3, "hitRoll": 0, "armorClass": 0, "dexterity": 90}, race_data={}
    )
    assert stats["evasion"] == 50 + 8 + 6
    assert stats["accuracy"] == 50 + 6


def test_mob_patch_is_guarded_on_the_old_formula():
    assert "floor((dexterity - 10) / 2.0)" in MOB_SQL  # the old output it matches on
    assert "trunc((dexterity - 50) / 5.0)" in MOB_SQL  # the new output it writes
    assert "LEAST(10, GREATEST(-10," in MOB_SQL
    assert "WHERE evasion = 50 + floor(" in MOB_SQL  # builder-edited values never match
    assert 'UPDATE "Mobs"' in MOB_SQL
    assert '"Characters"' not in MOB_SQL.split("UPDATE")[1]  # mobs only; player data is the other file


def test_character_patch_is_separate_guarded_and_flagged():
    assert "PLAYER DATA. Do not apply to prod without approval." in CHAR_SQL
    assert "floor((c.dexterity - 10) / 2.0)" in CHAR_SQL
    assert "trunc((c.dexterity - 50) / 5.0)" in CHAR_SQL
    assert "AND c.evasion = r.old_ev" in CHAR_SQL
    assert "AND r.old_ev <> r.new_ev" in CHAR_SQL
    # Fill is limited to rows still on the schema defaults.
    assert "c.accuracy = 0 AND c.evasion = 0 AND c.attack_power = 0" in CHAR_SQL
    assert "Mobs" not in CHAR_SQL.replace("2026-10-12-combat-stat-scale.sql (mobs)", "")
