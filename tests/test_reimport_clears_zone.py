"""Re-importing a zone replaces its resets and room extra descriptions instead of appending."""

import asyncio
from types import SimpleNamespace
from unittest.mock import AsyncMock, MagicMock

from fierylib.importers.reset_importer import ResetImporter


def _prisma():
    p = MagicMock()
    p.mobresets.delete_many = AsyncMock(return_value=3)
    p.objectresets.delete_many = AsyncMock(return_value=2)
    return p


def test_mob_and_object_resets_are_cleared_per_zone():
    p = _prisma()
    imp = ResetImporter(p)
    asyncio.run(imp.import_mob_resets([], 30))
    asyncio.run(imp.import_object_resets([], 30))
    p.mobresets.delete_many.assert_awaited_once_with(where={"zoneId": 30})
    p.objectresets.delete_many.assert_awaited_once_with(where={"zoneId": 30})


def test_dry_run_deletes_nothing():
    p = _prisma()
    imp = ResetImporter(p)
    asyncio.run(imp.import_mob_resets([], 30, dry_run=True))
    asyncio.run(imp.import_object_resets([], 30, dry_run=True))
    p.mobresets.delete_many.assert_not_awaited()
    p.objectresets.delete_many.assert_not_awaited()
