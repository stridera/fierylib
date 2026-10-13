"""MountType tiers: seeder constants, SQL patch and seeder logic stay in sync (no DB)."""

import asyncio
import re
from pathlib import Path

from fierylib.seeders.mount_type_seeder import MOUNT_TYPES, MountTypeSeeder

SQL = (
    Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-13-mount-types.sql"
).read_text(encoding="utf-8")


def test_sql_matches_seeder():
    rows = re.findall(
        r"\((\d+), '(good|evil)', (\d+), (\d+), (\d+), (\d+), (\d+), (\d+)\)", SQL
    )
    parsed = [(int(r[0]), r[1], *[int(x) for x in r[2:]]) for r in rows]
    assert parsed == MOUNT_TYPES


def test_every_tier_has_both_sides_and_mounts_are_distinct():
    assert sorted((t, s) for t, s, *_ in MOUNT_TYPES) == [
        (t, s) for t in (1, 2, 3, 4) for s in ("evil", "good")
    ]
    assert len({(z, m) for _, _, _, _, z, m, _, _ in MOUNT_TYPES}) == 8
    base = [r for r in MOUNT_TYPES if r[0] == 1]
    assert all(r[2] == 0 and r[3] == 0 for r in base)


class _FakeDb:
    """Emulates the MountType insert: (tier, side) conflicts do nothing; missing mobs skip."""

    def __init__(self, rows=None, mobs=None):
        self.rows = dict(rows or {})
        self.mobs = set(mobs if mobs is not None else {(0, m) for m in range(45, 53)})

    async def execute_raw(self, sql, *args):
        assert 'INTO "MountType"' in sql
        tier, side, _lvl, _al, zone, mob, _hp, _mv = args
        if (zone, mob) not in self.mobs or (tier, side) in self.rows:
            return 0
        self.rows[(tier, side)] = args
        return 1


def test_seeder_inserts_missing_and_keeps_edits():
    edited = (3, "good", 61, 950, 0, 45, 55, 55)
    db = _FakeDb({(3, "good"): edited})
    assert asyncio.run(MountTypeSeeder(db).seed_mount_types()) == {"changed": 7}
    assert db.rows[(3, "good")] == edited
    assert asyncio.run(MountTypeSeeder(db).seed_mount_types()) == {"changed": 0}


def test_seeder_skips_tiers_whose_mob_is_missing():
    db = _FakeDb(mobs={(0, 48), (0, 47)})
    assert asyncio.run(MountTypeSeeder(db).seed_mount_types()) == {"changed": 2}
