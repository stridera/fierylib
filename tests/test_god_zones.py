"""Tests for god-zone derivation (no DB): the importer SQL and the prod patch
must stay in sync, and the patch must be idempotent."""

import json
from pathlib import Path

import pytest
from fierylib.importers.zone_importer import MARK_GOD_ZONES_SQL, ZoneImporter

DATA = Path(__file__).resolve().parents[1] / "data"
SQL_PATH = DATA / "sql" / "2026-10-07-god-zones.sql"


def test_patch_embeds_the_importer_statement_verbatim():
    assert MARK_GOD_ZONES_SQL + ";" in SQL_PATH.read_text(encoding="utf-8")


def test_patch_is_idempotent_by_construction():
    sql = SQL_PATH.read_text(encoding="utf-8")
    assert "ADD COLUMN IF NOT EXISTS is_god_zone" in sql
    # Only ever flips false -> true, never back.
    assert "WHERE z.is_god_zone = false" in sql
    assert "is_god_zone = false," not in sql
    assert sql.strip().endswith("COMMIT;")


def test_teleport_range_params_are_seeded_and_patched():
    abilities = {a["plainName"]: a for a in json.loads((DATA / "abilities.json").read_text())}
    for name, rng in (("TELEPORT", "zone"), ("WORLD_TELEPORT", "world")):
        params = abilities[name]["effects"][0]["params"]
        assert params["destination"] == "random"
        assert params["range"] == rng
        assert params["success_base_pct"] == 10
        assert params["success_per_skill_pct"] == 2
    woods = abilities["WANDERING_WOODS"]["effects"][0]["params"]
    assert woods["range"] == "world" and woods["success_base_pct"] == 100
    sql = SQL_PATH.read_text(encoding="utf-8")
    for name in ("'TELEPORT'", "'WORLD_TELEPORT'", "'WANDERING_WOODS'"):
        assert name in sql
    # Matched by ability name + effect type, and reports what it touched.
    assert 'e."effectType" = \'teleport\'' in sql
    assert "RAISE NOTICE" in sql and "GET DIAGNOSTICS" in sql


class _FakePrisma:
    def __init__(self):
        self.statements = []

    async def execute_raw(self, sql):
        self.statements.append(sql)
        return 5


@pytest.mark.asyncio
async def test_importer_marks_god_zones_with_the_shared_statement():
    prisma = _FakePrisma()
    assert await ZoneImporter(prisma).mark_god_zones() == 5
    assert prisma.statements == [MARK_GOD_ZONES_SQL]
