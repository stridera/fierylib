import pytest
from typing import Any, Dict, List

from fierylib.importers.room_importer import RoomImporter

class MockPrismaRoomExitTable:
    def __init__(self):
        self.upserts: List[Dict[str, Any]] = []

    async def upsert(self, where: Dict[str, Any], data: Dict[str, Any]):  # type: ignore[override]
        # Record the normalized create payload for assertions
        self.upserts.append({
            'where': where,
            'create': data['create'],
            'update': data['update'],
        })
        return None

class MockPrismaRoomTable:
    async def upsert(self, where: Dict[str, Any], data: Dict[str, Any]):  # type: ignore[override]
        return None

class MockPrisma:
    def __init__(self):
        self.roomexit = MockPrismaRoomExitTable()
        self.room = MockPrismaRoomTable()

@pytest.mark.asyncio
async def test_import_exit_legacy_flat_id_bidirectional():
    prisma = MockPrisma()
    importer = RoomImporter(prisma)

    # Room A (zone 30, vnum 1) North -> legacy id 3002
    exit_a = await importer.import_exit(30, 1, 'North', {'destination': '3002'})
    assert exit_a['success'] is True
    assert exit_a['toZoneId'] == 30
    assert exit_a['toRoomId'] == 2

    # Room B (zone 30, vnum 2) South -> legacy id 3001
    exit_b = await importer.import_exit(30, 2, 'South', {'destination': '3001'})
    assert exit_b['success'] is True
    assert exit_b['toZoneId'] == 30
    assert exit_b['toRoomId'] == 1

    # Ensure two upserts recorded with composite key directions
    assert len(prisma.roomexit.upserts) == 2
    north = prisma.roomexit.upserts[0]['create']
    south = prisma.roomexit.upserts[1]['create']
    assert north['direction'] == 'NORTH'
    assert south['direction'] == 'SOUTH'
    assert north['toZoneId'] == 30 and north['toRoomId'] == 2
    assert south['toZoneId'] == 30 and south['toRoomId'] == 1

@pytest.mark.asyncio
async def test_import_exit_relative_vnum_same_zone():
    prisma = MockPrisma()
    importer = RoomImporter(prisma)

    # Using to_room field with a relative vnum (<100) should map to same zone
    # Source room zone 45 vnum 10, exit East to relative vnum 11
    result = await importer.import_exit(45, 10, 'East', {'to_room': 11})
    assert result['success'] is True
    assert result['toZoneId'] == 45
    assert result['toRoomId'] == 11

    # Ensure upsert recorded
    assert prisma.roomexit.upserts[-1]['create']['toZoneId'] == 45
    assert prisma.roomexit.upserts[-1]['create']['toRoomId'] == 11

@pytest.mark.asyncio
async def test_import_exit_invalid_direction():
    prisma = MockPrisma()
    importer = RoomImporter(prisma)
    result = await importer.import_exit(30, 1, 'InvalidDir', {'destination': '3002'})
    assert result['success'] is False
    assert 'Invalid direction' in result['error']
