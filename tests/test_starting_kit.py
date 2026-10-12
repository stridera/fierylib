"""Tests for the StartingKit data, SQL patch and seeder (no DB)."""

import re
from pathlib import Path

import pytest
from fierylib.seeders.starting_kit_seeder import (
    StartingKitSeeder,
    build_sql,
    load_items,
)

ROOT = Path(__file__).resolve().parents[1]
SQL_PATH = ROOT / "data" / "sql" / "2026-10-12-starting-kit.sql"
_LEGACY_SRC = Path("fierymud_legacy") / "src" / "class.cpp"
# The legacy checkout is a sibling of the fierylib checkout (or of .worktrees/).
LEGACY_CLASS = next(
    (p / _LEGACY_SRC for p in ROOT.parents[:2] if (p / _LEGACY_SRC).exists()),
    ROOT / _LEGACY_SRC,
)


def _vnum(item: dict) -> int:
    return item["object"]["zone"] * 100 + item["object"]["id"]


def test_everyone_gets_a_light_and_the_common_pack_first():
    common = [r for r in load_items() if r["class"] is None]
    # Legacy common_newbie_eq[]: bag, rations, water skin, torch, map, journal.
    assert [_vnum(r) for r in common] == [18, 19, 20, 23, 3090, 299]
    # The common rows come first so they are handed out first.
    firsts = load_items()[: len(common)]
    assert all(r["class"] is None for r in firsts)


def test_warrior_and_sorcerer_kits_match_legacy():
    items = load_items()
    kit = lambda cls: [_vnum(r) for r in items if r["class"] == cls]  # noqa: E731
    assert kit("Warrior") == [1019, 1022, 1024, 1026, 1014]
    assert kit("Sorcerer") == [1029, 1154, 38, 1003, 1027, 1012]
    assert kit("Cleric") == [1019, 1022, 1025, 1027, 1011]
    assert kit("Rogue") == [1019, 1022, 1025, 1027, 1012]


def test_no_coin_in_the_kit():
    # Legacy gave no starting coin; the rows carry only class, object, quantity.
    assert all(set(r) == {"class", "object", "quantity"} for r in load_items())


@pytest.mark.skipif(not LEGACY_CLASS.exists(), reason="legacy checkout not present")
def test_every_class_kit_matches_legacy_class_cpp():
    src = LEGACY_CLASS.read_text(encoding="utf-8", errors="replace")
    block = src[src.index("ClassDef classes[NUM_CLASSES]") : src.index("/* The newbie equipment")]
    names = re.findall(r'\{"([a-z -]+)", /\* standard name \*/', block)
    kits = re.findall(r"\{([0-9, -]+)\}\},\s+/\* starting equipment for newbies \*/", block)
    assert len(names) == len(kits) > 20
    items = load_items()
    for name, kit in zip(names, kits):
        cls = "Anti-Paladin" if name == "anti-paladin" else name.capitalize()
        if cls == "Layman":  # not a playable class in the new game
            continue
        legacy = [int(v) for v in kit.split(",") if int(v) >= 0]
        ours = [_vnum(r) for r in items if r["class"] == cls]
        assert ours == legacy, cls


def test_kit_keys_are_unique():
    keys = [(r["class"], r["object"]["zone"], r["object"]["id"]) for r in load_items()]
    assert len(keys) == len(set(keys))


def test_sql_patch_is_in_sync_with_the_data_file():
    assert SQL_PATH.read_text(encoding="utf-8") == build_sql()


def test_sql_patch_is_idempotent_in_shape():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert 'CREATE TABLE IF NOT EXISTS "StartingKit"' in sql
    assert "CREATE UNIQUE INDEX IF NOT EXISTS" in sql
    assert "NOT EXISTS" in sql and "IS NOT DISTINCT FROM" in sql
    assert "DELETE FROM" not in sql and "TRUNCATE" not in sql and "DROP" not in sql


class _FakePrisma:
    """Counts rows like Postgres would: a (class, zone, id) seen before inserts 0."""

    def __init__(self, existing=()):
        self.seen = set(existing)
        self.calls = []

    async def execute_raw(self, sql, cls, zone, obj, qty):
        self.calls.append((cls, zone, obj, qty))
        key = (cls, zone, obj)
        if key in self.seen:
            return 0
        self.seen.add(key)
        return 1


@pytest.mark.asyncio
async def test_seed_inserts_every_row_once_and_is_a_no_op_on_rerun():
    prisma = _FakePrisma()
    total = len(load_items())
    stats = await StartingKitSeeder(prisma).seed_starting_kit()
    assert stats == {"inserted": total, "existing": 0, "total": total}
    assert prisma.calls[3] == (None, 0, 23, 1)  # the wooden torch
    again = await StartingKitSeeder(prisma).seed_starting_kit()
    assert again == {"inserted": 0, "existing": total, "total": total}
