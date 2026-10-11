"""The 2026-10-11 floor patches are keyed by (zone, id) and guarded by current values."""

import re
from pathlib import Path

SQL_DIR = Path(__file__).resolve().parents[1] / "data" / "sql"
MOB_SQL = (SQL_DIR / "2026-10-11-mob-dice-floor.sql").read_text(encoding="utf-8")
OBJ_SQL = (SQL_DIR / "2026-10-11-object-sanity.sql").read_text(encoding="utf-8")


def test_mob_patch_keys_and_guards():
    keys = re.findall(r"^\s+\((\d+), (\d+)\),?$", MOB_SQL, re.M)
    assert len(keys) == len(set(keys)) == 16 + 31
    assert "m.hp_dice_num = 0 AND m.hp_dice_size = 0 AND m.hp_dice_bonus = 0" in MOB_SQL
    assert "m.damage_dice_num = 0" in MOB_SQL
    assert "m.level * 2 + 1" in MOB_SQL


def test_object_patch_keys_and_guards():
    assert "(481, 3, 2, 0)" in OBJ_SQL and "(520, 25, 0, 0)" in OBJ_SQL
    assert "(4, 5, -5.0)" in OBJ_SQL and "(117, 111, -2.0)" in OBJ_SQL
    assert "o.weapon_dice_num = k.num AND o.weapon_dice_size = k.size" in OBJ_SQL
    assert "o.weight = k.weight" in OBJ_SQL
