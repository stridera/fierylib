"""Tests for the recall scroll destination seeder (no DB)."""

import json
from pathlib import Path

import pytest
from fierylib.seeders.recall_scroll_seeder import (
    VALUES_KEY,
    RecallScrollSeeder,
    build_sql,
    load_scrolls,
)

SQL_PATH = Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-07-recall-scroll-rooms.sql"


def test_table_matches_legacy_spec_procs():
    by_vnum = {s["legacy_vnum"]: s["recall_rooms"] for s in load_scrolls()}
    assert set(by_vnum) == {3056, 3057, 3058, 30010}
    red, green, blue, gray = by_vnum[3056], by_vnum[3057], by_vnum[3058], by_vnum[30010]
    # red_recall_room: sorcerer 6231 -> zone 62 id 31; default 6149 -> zone 61 id 49.
    assert red["classes"]["sorcerer"] == {"zone": 62, "id": 31}
    assert red["classes"]["berserker"] == {"zone": 557, "id": 97}
    assert red["default"] == {"zone": 61, "id": 49}
    # green_recall_room: necromancer 16932 -> zone 169 id 32; default 3022.
    assert green["classes"]["necromancer"] == {"zone": 169, "id": 32}
    assert green["classes"]["paladin"] == {"zone": 53, "id": 6}
    assert green["default"] == {"zone": 30, "id": 22}
    # blue: every arcane class shares 10030; default 10013.
    for c in ("sorcerer", "necromancer", "pyromancer", "cryomancer", "illusionist"):
        assert blue["classes"][c] == {"zone": 100, "id": 30}
    assert blue["default"] == {"zone": 100, "id": 13}
    # gray: illusionist 30000 -> zone 300 id 0; default 30030.
    assert gray["classes"]["illusionist"] == {"zone": 300, "id": 0}
    assert gray["default"] == {"zone": 300, "id": 30}


def test_sql_patch_is_in_sync_with_the_data_file():
    assert SQL_PATH.read_text(encoding="utf-8") == build_sql()


class _FakeObjects:
    def __init__(self, rows):
        self.rows = rows
        self.updates = {}

    async def find_unique(self, where):
        k = where["zoneId_id"]
        return self.rows.get((k["zoneId"], k["id"]))

    async def update(self, where, data):
        k = where["zoneId_id"]
        wrapped = data["values"]  # prisma.Json wrapper around the dict
        self.updates[(k["zoneId"], k["id"])] = getattr(wrapped, "data", wrapped)


class _Obj:
    def __init__(self, values):
        self.values = values


class _FakePrisma:
    def __init__(self, rows):
        self.objects = _FakeObjects(rows)


@pytest.mark.asyncio
async def test_seed_merges_into_existing_values_and_skips_missing_scrolls():
    rows = {
        (30, 56): _Obj({"Level": 0, "Spells": ["RECALL"]}),
        (30, 57): _Obj(json.dumps({"Level": 0})),
    }
    prisma = _FakePrisma(rows)
    stats = await RecallScrollSeeder(prisma).seed_recall_scrolls()
    assert stats == {"updated": 2, "missing": 2, "total": 4}
    red = prisma.objects.updates[(30, 56)]
    assert red["Spells"] == ["RECALL"]
    assert red[VALUES_KEY]["default"] == {"zone": 61, "id": 49}
    # Rerunning is a no-op on the stored shape.
    again = await RecallScrollSeeder(_FakePrisma({(30, 56): _Obj(red)})).seed_recall_scrolls()
    assert again["updated"] == 1
