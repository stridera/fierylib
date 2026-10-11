"""Importer floors: weapons always have dice, weights are never negative."""

from fierylib.importers.object_importer import sane_weapon_dice, sane_weight


def test_weapon_with_zero_dice_gets_1d4():
    assert sane_weapon_dice("WEAPON", 2, 0) == (1, 4)  # 481/3
    assert sane_weapon_dice("WEAPON", 0, 0) == (1, 4)  # 520/25
    assert sane_weapon_dice("WEAPON", 0, 6) == (1, 4)


def test_valid_weapon_dice_and_non_weapons_untouched():
    assert sane_weapon_dice("WEAPON", 4, 7) == (4, 7)
    assert sane_weapon_dice("ARMOR", 0, 0) == (0, 0)
    assert sane_weapon_dice("STAFF", 0, 0) == (0, 0)


def test_negative_weight_floors_to_zero():
    assert sane_weight(-2.0) == 0.0
    assert sane_weight(-5) == 0.0
    assert sane_weight(None) == 0.0
    assert sane_weight(1.1) == 1.1


def test_absurd_weight_is_clamped():
    assert sane_weight(2147483648.0) == 100000.0  # 30.obj #3137 fountain
    assert sane_weight(100000) == 100000.0
    assert sane_weight(99999.5) == 99999.5
