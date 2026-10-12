"""Zones.is_internal and Social.staff_only: importer/seeder statements, SQL patches and the Prisma
schema stay in sync (no DB)."""

import re
from pathlib import Path

import pytest

from fierylib.importers.zone_importer import (
    INTERNAL_ZONE_IDS,
    MARK_INTERNAL_ZONES_SQL,
    ZoneImporter,
)
from fierylib.seeders.socials_seeder import (
    MARK_STAFF_ONLY_SQL,
    STAFF_ONLY_SOCIALS,
    SocialsSeeder,
)

ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = ROOT / "data" / "sql"
ZONE_SQL = (SQL_DIR / "2026-10-12-zone-internal-flag.sql").read_text(encoding="utf-8")
SOCIAL_SQL = (SQL_DIR / "2026-10-12-social-staff-only.sql").read_text(encoding="utf-8")
SCHEMA = (ROOT.parent / "muditor/packages/db/prisma/schema.prisma").read_text(encoding="utf-8")


class _FakePrisma:
    def __init__(self):
        self.statements = []

    async def execute_raw(self, sql):
        self.statements.append(sql)
        return 3


def test_zone_ddl_matches_prisma_model():
    assert re.search(r'isInternal\s+Boolean\s+@default\(false\)\s+@map\("is_internal"\)', SCHEMA)
    assert 'ALTER TABLE "Zones" ADD COLUMN IF NOT EXISTS is_internal BOOLEAN NOT NULL DEFAULT false;' in ZONE_SQL


def test_social_ddl_matches_prisma_model():
    assert re.search(r'staffOnly\s+Boolean\s+@default\(false\)\s+@map\("staff_only"\)', SCHEMA)
    assert 'ALTER TABLE "Social" ADD COLUMN IF NOT EXISTS staff_only BOOLEAN NOT NULL DEFAULT false;' in SOCIAL_SQL


def test_zone_patch_flags_the_importer_ids_and_is_idempotent():
    assert INTERNAL_ZONE_IDS == (0, 1, 2)
    ids = "(" + ", ".join(str(i) for i in INTERNAL_ZONE_IDS) + ")"
    assert f"id IN {ids}" in MARK_INTERNAL_ZONES_SQL
    assert f"WHERE id IN {ids} AND is_internal = false" in ZONE_SQL
    # Only flips false -> true, so a rerun touches 0 rows.
    assert "is_internal = false," not in ZONE_SQL
    assert "RAISE NOTICE" in ZONE_SQL and "GET DIAGNOSTICS" in ZONE_SQL
    assert ZONE_SQL.strip().endswith("COMMIT;")


def test_social_patch_flags_the_seeder_names_and_is_idempotent():
    assert STAFF_ONLY_SOCIALS == ("snowball",)
    assert "WHERE name IN ('snowball') AND staff_only = false" in MARK_STAFF_ONLY_SQL
    assert "WHERE name IN ('snowball') AND staff_only = false" in SOCIAL_SQL
    assert "staff_only = false," not in SOCIAL_SQL
    assert "RAISE NOTICE" in SOCIAL_SQL and "GET DIAGNOSTICS" in SOCIAL_SQL
    assert SOCIAL_SQL.strip().endswith("COMMIT;")


@pytest.mark.asyncio
async def test_importer_marks_internal_zones_with_the_shared_statement():
    prisma = _FakePrisma()
    assert await ZoneImporter(prisma).mark_internal_zones() == 3
    assert prisma.statements == [MARK_INTERNAL_ZONES_SQL]


@pytest.mark.asyncio
async def test_seeder_marks_staff_only_socials_with_the_shared_statement():
    prisma = _FakePrisma()
    assert await SocialsSeeder(prisma).mark_staff_only() == 3
    assert prisma.statements == [MARK_STAFF_ONLY_SQL]
