"""SphereStyle colours and Liquids.legacy_index/legacy_code: seeder constants, SQL patches and
the seeder logic stay in sync (no DB)."""

import asyncio
import re
from pathlib import Path

from fierylib.seeders.liquid_seeder import (
    LEGACY_LIQUID_CODES,
    LIQUID_DATA,
    seed_legacy_liquid_ids,
)
from fierylib.seeders.sphere_style_seeder import SPHERE_STYLES, SphereStyleSeeder

SQL_DIR = Path(__file__).resolve().parents[1] / "data" / "sql"
SPHERE_SQL = (SQL_DIR / "2026-10-12-sphere-colors.sql").read_text(encoding="utf-8")
LIQUID_SQL = (SQL_DIR / "2026-10-12-liquid-index.sql").read_text(encoding="utf-8")


def test_sphere_sql_matches_seeder():
    sql_rows = re.findall(r"\('([A-Z]+)', '([^']+)'\)", SPHERE_SQL)
    expected = [(s, c) for s, c in SPHERE_STYLES if c is not None]
    assert sql_rows == expected
    assert "('GENERIC', NULL)" in SPHERE_SQL


def test_sphere_styles_cover_every_spell_sphere():
    schema = (
        Path(__file__).resolve().parents[2]
        / "muditor/packages/db/prisma/schema.prisma"
    ).read_text(encoding="utf-8")
    enum_body = re.search(r"enum SpellSphere \{(.*?)\}", schema, re.S).group(1)
    spheres = {w for w in enum_body.split() if w.isupper()}
    assert {s for s, _ in SPHERE_STYLES} == spheres


def test_liquid_sql_matches_seeder_order():
    rows = re.findall(r"\('([a-z-]+)', (\d+), '([A-Z]+)'\)", LIQUID_SQL)
    assert len(rows) == 42
    for i, (alias, idx, code) in enumerate(rows):
        assert int(idx) == i
        assert alias == LIQUID_DATA[i][0]
        assert code == LEGACY_LIQUID_CODES[i]


def test_liquid_codes_unique_and_tea_is_11():
    assert len(set(LEGACY_LIQUID_CODES)) == len(LEGACY_LIQUID_CODES) == len(LIQUID_DATA)
    # Scripts compare these fixed numbers (120_03_druid_receive: tea 11, coffee 12, milk 10).
    assert LEGACY_LIQUID_CODES.index("TEA") == 11
    assert LEGACY_LIQUID_CODES.index("WHISKY") == 5


class _FakeDb:
    """Emulates the SphereStyle/Liquids statements the seeders issue via execute_raw."""

    def __init__(self, spheres=None, liquids=None):
        self.spheres = dict(spheres or {})
        self.liquids = dict(liquids or {})  # alias -> [legacy_index, legacy_code]

    async def execute_raw(self, sql, *args):
        if 'INTO "SphereStyle"' in sql:
            sphere, color = args
            if sphere not in self.spheres:
                self.spheres[sphere] = color
                return 1
            if self.spheres[sphere] is None and color is not None:
                self.spheres[sphere] = color
                return 1
            return 0
        if 'UPDATE "Liquids"' in sql:
            idx, code, alias = args
            cur = self.liquids.get(alias)
            if cur is None or (cur[0] is not None and cur[1] is not None):
                return 0
            self.liquids[alias] = [cur[0] if cur[0] is not None else idx, cur[1] or code]
            return 1
        raise AssertionError(sql)


def test_sphere_seeder_creates_fills_and_keeps_builder_edits():
    db = _FakeDb({"FIRE": "b:red", "AIR": None})
    stats = asyncio.run(SphereStyleSeeder(db).seed_sphere_styles())
    assert db.spheres["FIRE"] == "b:red"  # builder edit survives
    assert db.spheres["AIR"] == "b:cyan"  # NULL filled
    assert db.spheres["GENERIC"] is None
    assert stats == {"changed": 10}  # 8 new coloured + AIR filled + GENERIC row
    assert asyncio.run(SphereStyleSeeder(db).seed_sphere_styles()) == {"changed": 0}


def test_liquid_seeder_fills_only_null_legacy_ids():
    db = _FakeDb(liquids={"water": [None, None], "beer": [7, "CUSTOM"], "homebrew": [None, None]})
    changed = asyncio.run(seed_legacy_liquid_ids(db))
    assert changed == 1  # water only: beer already set, homebrew is not a legacy alias
    assert db.liquids["water"] == [0, "WATER"]
    assert db.liquids["beer"] == [7, "CUSTOM"]
    assert db.liquids["homebrew"] == [None, None]
