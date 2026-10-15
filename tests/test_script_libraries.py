"""Script libraries: file format, DDL patch and seeder logic (no DB)."""

import asyncio
from pathlib import Path

import pytest

from fierylib.seeders.script_library_seeder import (
    ScriptLibrarySeeder,
    parse_library_file,
)

ROOT = Path(__file__).resolve().parents[1]
LIB_DIR = ROOT / "data" / "script_libraries"
SQL = (ROOT / "data" / "sql" / "2026-10-14-script-library.sql").read_text(encoding="utf-8")


def _write(tmp_path, name, text):
    f = tmp_path / name
    f.write_text(text, encoding="utf-8")
    return f


def test_parses_header_and_keeps_usage_comments(tmp_path):
    f = _write(
        tmp_path,
        "a.lua",
        "-- Library: wand-quest\n-- Zone: 30\n-- Description: Wand data\n-- Usage: require('x')\n\nreturn {}\n",
    )
    lib = parse_library_file(f)
    assert (lib.name, lib.zone_id, lib.description) == ("wand-quest", 30, "Wand data")
    assert lib.code == "-- Usage: require('x')\n\nreturn {}\n"


def test_zone_and_description_are_optional(tmp_path):
    lib = parse_library_file(_write(tmp_path, "a.lua", "-- Library: util\n\nreturn 1\n"))
    assert lib.zone_id is None and lib.description is None
    assert lib.code == "return 1\n"


@pytest.mark.parametrize("name", ["Util", "has space", "x" * 65, "semi;colon"])
def test_rejects_invalid_names(tmp_path, name):
    with pytest.raises(ValueError, match="Invalid library name"):
        parse_library_file(_write(tmp_path, "a.lua", f"-- Library: {name}\n\nreturn 1\n"))


def test_requires_library_header(tmp_path):
    with pytest.raises(ValueError, match="Missing"):
        parse_library_file(_write(tmp_path, "a.lua", "-- Trigger: nope\n\nreturn 1\n"))


def test_example_library_is_valid():
    lib = parse_library_file(LIB_DIR / "example_util.lua")
    assert lib.name == "util"
    assert "format_coins" in lib.code
    assert lib.code.rstrip().endswith("return util")


def test_every_committed_library_parses_with_unique_names():
    names = [parse_library_file(p).name for p in sorted(LIB_DIR.glob("*.lua"))]
    assert names and len(names) == len(set(names))


def test_sql_patch_matches_prisma_ddl():
    for needle in (
        'CREATE TABLE IF NOT EXISTS "ScriptLibrary"',
        '"id" SERIAL NOT NULL',
        '"name" TEXT NOT NULL',
        '"zone_id" INTEGER,',
        '"description" TEXT,',
        '"code" TEXT NOT NULL',
        '"created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP',
        '"updated_at" TIMESTAMP(3) NOT NULL,',
        '"created_by" TEXT,',
        '"updated_by" TEXT,',
        'CONSTRAINT "ScriptLibrary_pkey" PRIMARY KEY ("id")',
        'CREATE UNIQUE INDEX IF NOT EXISTS "ScriptLibrary_name_key" ON "ScriptLibrary"("name")',
        'CREATE INDEX IF NOT EXISTS "ScriptLibrary_zone_id_idx"',
        "ScriptLibrary_zone_id_fkey",
        'REFERENCES "Zones"("id")',
        "ON DELETE SET NULL ON UPDATE CASCADE",
    ):
        assert needle in SQL, needle


class _FakeDb:
    """Emulates the upsert: name is the key, zones must exist, no-op when unchanged."""

    def __init__(self, zones=(30,)):
        self.zones = set(zones)
        self.rows: dict[str, tuple] = {}

    async def query_raw(self, sql, *args):
        if '"Zones"' in sql:
            return [{"ok": 1}] if args[0] in self.zones else []
        return [{"ok": 1}] if args[0] in self.rows else []

    async def execute_raw(self, sql, name, zone, desc, code):
        new = (zone, desc, code)
        if self.rows.get(name) == new:
            return 0
        self.rows[name] = new
        return 1


def test_seeder_inserts_updates_and_is_idempotent(tmp_path):
    _write(tmp_path, "a.lua", "-- Library: a\n\nreturn 1\n")
    _write(tmp_path, "b.lua", "-- Library: b\n-- Zone: 30\n\nreturn 2\n")
    db = _FakeDb()
    seeder = ScriptLibrarySeeder(db)
    first = asyncio.run(seeder.seed_script_libraries(tmp_path))
    assert first == {"imported": 2, "updated": 0, "skipped": 0}
    again = asyncio.run(seeder.seed_script_libraries(tmp_path))
    assert again == {"imported": 0, "updated": 0, "skipped": 0}
    _write(tmp_path, "a.lua", "-- Library: a\n\nreturn 99\n")
    third = asyncio.run(seeder.seed_script_libraries(tmp_path))
    assert third == {"imported": 0, "updated": 1, "skipped": 0}
    assert db.rows["a"][2] == "return 99\n"


def test_seeder_skips_bad_files_missing_zones_and_duplicates(tmp_path):
    _write(tmp_path, "bad.lua", "-- Library: Bad Name\n\nreturn 1\n")
    _write(tmp_path, "zone.lua", "-- Library: z\n-- Zone: 999\n\nreturn 1\n")
    _write(tmp_path, "d1.lua", "-- Library: dup\n\nreturn 1\n")
    _write(tmp_path, "d2.lua", "-- Library: dup\n\nreturn 2\n")
    db = _FakeDb()
    stats = asyncio.run(ScriptLibrarySeeder(db).seed_script_libraries(tmp_path))
    assert stats == {"imported": 1, "updated": 0, "skipped": 3}
    assert list(db.rows) == ["dup"]
