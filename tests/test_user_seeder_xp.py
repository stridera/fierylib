"""Seeded test characters start at the XP floor of their level, not at a stray 1050."""

from fierylib.seeders.level_seeder import exp_required_for_level
from fierylib.seeders.user_seeder import level_floor_xp


def test_level_one_is_zero():
    assert level_floor_xp(exp_required_for_level(1), 1, 1.0) == 0


def test_neutral_factor_is_the_table_value():
    base = exp_required_for_level(25)
    assert base > 1050
    assert level_floor_xp(base, 25, 1.0) == base


def test_class_factor_scales_and_truncates():
    assert level_floor_xp(1001, 10, 1.15) == int(1001 * 1.15)


def test_staff_levels_ignore_the_class_factor():
    base = exp_required_for_level(105)
    assert level_floor_xp(base, 105, 1.3) == base
