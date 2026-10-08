"""Mob bare-hand damage dice: legacy fierymud 64c30ccb get_set_dice port."""

from pathlib import Path
from unittest.mock import AsyncMock, MagicMock

import pytest

from fierylib.combat_formulas import get_class_dice_factor, get_race_dice_factor, get_set_dice
from fierylib.importers.mob_importer import MobImporter, apply_damage_dice_modifiers

LEVELS = [1, 5, 10, 21, 22, 30, 39, 40, 55, 60, 90, 99]

# Hand-computed from the C++ (db.cpp @ 64c30ccb):
#   count = level / 3 (int), max(1, ..) only when level < 10, then
#   sfactor = (race + class) / 2 (int); count = sfactor * count / 100 (truncated).
#   face  = 3 (<22) | 4 (<40) | level / 10 + 1.
FACES = [3, 3, 3, 3, 4, 4, 4, 5, 6, 7, 10, 10]
BASE_COUNT = [1, 1, 3, 7, 7, 10, 13, 13, 18, 20, 30, 33]  # level / 3, clamped >= 1 below level 10

# (race, class) -> (sfactor, expected counts per LEVELS)
COUNTS = {
    ("HUMAN", "THIEF"): (100, BASE_COUNT),
    ("DRAGON", "WARRIOR"): (120, [1, 1, 3, 8, 8, 12, 15, 15, 21, 24, 36, 39]),
    ("ELF", "SORCERER"): (80, [0, 0, 2, 5, 5, 8, 10, 10, 14, 16, 24, 26]),
    ("FAERIE", "WARRIOR"): (95, [0, 0, 2, 6, 6, 9, 12, 12, 17, 19, 28, 31]),
}


@pytest.mark.parametrize("race,cls", list(COUNTS))
def test_factor_values_match_tables(race, cls):
    sfactor = COUNTS[(race, cls)][0]
    assert (get_race_dice_factor(race) + get_class_dice_factor(cls)) // 2 == sfactor


@pytest.mark.parametrize("race,cls", list(COUNTS))
@pytest.mark.parametrize("idx", range(len(LEVELS)))
def test_get_set_dice_matches_cpp(race, cls, idx):
    level = LEVELS[idx]
    expected_count = COUNTS[(race, cls)][1][idx]
    got = get_set_dice(level, get_race_dice_factor(race), get_class_dice_factor(cls))
    assert got == (expected_count, FACES[idx])


def test_no_bump_over_level_50_and_no_floor_rounding():
    # old formula: level 60 -> int(60/2.5 + .5) = 24; level 31 -> int(31/3 + .5) = 10
    assert get_set_dice(60, 100, 100)[0] == 20
    assert get_set_dice(31, 100, 100)[0] == 10
    assert get_set_dice(29, 100, 100)[0] == 9  # old: int(9.67 + .5) = 10


def test_clamp_only_before_factor_below_level_10():
    assert get_set_dice(2, 100, 100)[0] == 1  # level/3 = 0 -> clamped to 1
    assert get_set_dice(2, 60, 80)[0] == 0  # factor 70 applied after the clamp, no second clamp
    assert get_set_dice(12, 60, 60)[0] == 2  # level >= 10: 4 * 60 / 100 = 2


def test_odd_factor_sum_uses_integer_division():
    # (75 + 100) / 2 = 87 in C int math (not 87.5)
    assert get_set_dice(21, 75, 100)[0] == 6  # 87 * 7 / 100 = 6
    assert get_set_dice(30, 75, 100)[0] == 8  # 87 * 10 / 100 = 8


def test_importer_adds_file_modifiers_and_clamps():
    # level 40, factor 100: base (13, 5)
    assert apply_damage_dice_modifiers(40, 100, 100, 0, 0) == (13, 5)
    assert apply_damage_dice_modifiers(40, 100, 100, 2, 3) == (15, 8)
    assert apply_damage_dice_modifiers(40, 100, 100, -15, 0) == (0, 5)  # num clamped at 0
    assert apply_damage_dice_modifiers(40, 100, 100, 0, -9) == (13, 1)  # size clamped at 1


LIB_MOBS = Path(__file__).resolve().parent.parent.parent / "lib" / "world" / "mob"


@pytest.mark.asyncio
@pytest.mark.skipif(not (LIB_MOBS / "30.mob").exists(), reason="legacy lib not present")
async def test_import_mob_stores_base_plus_file_modifiers():
    from mud.mudfile import MudData
    from mud.types.mob import Mob

    mob = Mob.parse(MudData((LIB_MOBS / "30.mob").read_text().split("\n")))[0]
    mob.level = 40
    mob.damage_dice.num, mob.damage_dice.size = 2, 3

    prisma = MagicMock()
    prisma.mobs.upsert = AsyncMock()
    prisma.races.find_unique = AsyncMock(return_value=None)
    imp = MobImporter(prisma)
    imp.get_zone_statistics = AsyncMock(
        return_value={"avg_level": 20, "stddev_level": 5, "avg_hp": 500, "stddev_hp": 100}
    )
    imp.sync_default_effects = AsyncMock(return_value=False)

    result = await imp.import_mob(mob, 30)
    assert result["success"], result

    race = mob.race.name
    cls = mob.mob_class.name
    base_num, base_size = get_set_dice(40, get_race_dice_factor(race), get_class_dice_factor(cls))
    create = prisma.mobs.upsert.call_args.kwargs["data"]["create"]
    assert create["damageDiceNum"] == max(0, base_num + 2)
    assert create["damageDiceSize"] == base_size + 3
