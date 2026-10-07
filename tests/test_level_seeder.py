"""Tests for the legacy XP table seeder (no DB)."""

import re
from pathlib import Path

import pytest
from fierylib.seeders.level_seeder import (
    LVL_IMPL,
    LevelSeeder,
    class_exp_factors,
    exp_required_for_level,
    legacy_exp_table,
)

SQL_PATH = Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-07-legacy-exp-table.sql"


def test_legacy_exp_table_matches_init_exp_table():
    t = legacy_exp_table()
    assert len(t) == LVL_IMPL + 1
    # Hand-computed from fierymud_legacy/src/utils.cpp init_exp_table.
    assert t[0] == 0
    assert t[1] == 5500  # (1*1+1)/2 * 5500
    assert t[8] == 198000  # (64+8)/2 * 5500
    assert t[9] == 254500  # first eval[] bracket: 44000 + (9-8)*12500 + 198000
    assert t[16] == 1000000
    assert t[98] == 99938000
    assert t[99] == 105806000  # the "**" threshold: level 99 -> 100, factor 1
    assert t[100] == 299999999  # god levels
    assert t[101] == 300000001
    assert t[105] == 300000009


def test_table_is_strictly_increasing():
    t = legacy_exp_table()
    assert all(b > a for a, b in zip(t, t[1:]))


def test_exp_required_is_exp_next_level_of_previous_level():
    assert exp_required_for_level(1) == 0
    assert exp_required_for_level(2) == 5500
    assert exp_required_for_level(100) == legacy_exp_table()[99]
    assert LevelSeeder(None).calculate_exp_for_level(85) == legacy_exp_table()[84]


def test_class_factors_match_legacy_class_cpp():
    f = class_exp_factors()
    assert f["Sorcerer"] == 1.2
    assert f["Cleric"] == 1.0
    assert f["Necromancer"] == 1.3
    assert f["Monk"] == 1.3
    assert f["Paladin"] == 1.15
    assert f["Anti-Paladin"] == 1.15
    assert f["Berserker"] == 1.1
    assert len(f) == 24
    # Legacy truncates: exp_table[level] * gain_factor as a long.
    assert int(legacy_exp_table()[99] * f["Necromancer"]) == 137547800


def test_sql_patch_in_sync_with_seeder():
    sql = SQL_PATH.read_text(encoding="utf-8")
    levels = {int(a): int(b) for a, b in re.findall(r"^\s+\((\d+), (\d+)\)[,]?$", sql, re.M)}
    assert levels == {lv: exp_required_for_level(lv) for lv in range(1, LVL_IMPL + 1)}
    factors = {n: float(v) for n, v in re.findall(r"^\s+\('([^']+)', ([\d.]+)\)[,]?$", sql, re.M)}
    assert factors == class_exp_factors()
    assert "IF NOT EXISTS exp_gain_factor" in sql
    assert "IS DISTINCT FROM" in sql  # idempotent


class _FakePrisma:
    """Records writes; stands in for the Prisma client."""

    class _Table:
        def __init__(self):
            self.rows = {}

        async def find_unique(self, where):
            return self.rows.get(where["level"])

        async def create(self, data):
            self.rows[data["level"]] = data

        async def update(self, where, data):
            self.rows[where["level"]] = {**self.rows[where["level"]], **data}

        async def update_many(self, where, data):
            self.updates.append((where, data))
            return 1

    def __init__(self):
        self.leveldefinition = self._Table()
        self.characterclass = self._Table()
        self.characterclass.updates = []


@pytest.mark.asyncio
async def test_seed_levels_writes_legacy_values_and_class_factors():
    prisma = _FakePrisma()
    stats = await LevelSeeder(prisma).seed_levels()
    assert stats["total"] == LVL_IMPL
    rows = prisma.leveldefinition.rows
    assert rows[1]["expRequired"] == 0
    assert rows[2]["expRequired"] == 5500
    assert rows[100]["expRequired"] == 105806000
    assert stats["class_factors"] == 24
    assert ({"plainName": "Monk"}, {"expGainFactor": 1.3}) in prisma.characterclass.updates
