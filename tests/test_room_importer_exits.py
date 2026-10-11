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
    vnum_map = {3001: (30, 1), 3002: (30, 2)}

    # Room A (zone 30, vnum 1) North -> legacy id 3002
    exit_a = await importer.import_exit(
        30, 1, 'North', {'destination': '3002'}, vnum_map=vnum_map
    )
    assert exit_a['success'] is True
    assert exit_a['toZoneId'] == 30
    assert exit_a['toRoomId'] == 2

    # Room B (zone 30, vnum 2) South -> legacy id 3001
    exit_b = await importer.import_exit(
        30, 2, 'South', {'destination': '3001'}, vnum_map=vnum_map
    )
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
async def test_import_exit_invalid_direction():
    prisma = MockPrisma()
    importer = RoomImporter(prisma)
    result = await importer.import_exit(
        30, 1, 'InvalidDir', {'destination': '3002'}, vnum_map={3002: (30, 2)}
    )
    assert result['success'] is False
    assert 'Invalid direction' in result['error']


@pytest.mark.asyncio
async def test_import_exit_resolves_door_key_to_composite():
    prisma = MockPrisma()
    importer = RoomImporter(prisma)
    vnum_map = {1614: (16, 14), 1684: (16, 84), 1686: (16, 86)}
    object_vnum_map = {1614: (16, 14)}  # the door key object

    result = await importer.import_exit(
        16, 84, 'North',
        {'destination': '1686', 'key': '1614'},
        vnum_map=vnum_map,
        object_vnum_map=object_vnum_map,
    )
    assert result['success'] is True
    assert result['keyZoneId'] == 16
    assert result['keyId'] == 14

    create = prisma.roomexit.upserts[-1]['create']
    assert create['keyZoneId'] == 16
    assert create['keyId'] == 14
    assert 'key' not in create  # legacy String column is gone


@pytest.mark.asyncio
@pytest.mark.parametrize('sentinel', [None, '', '-1', -1, '0', 0])
async def test_import_exit_treats_sentinel_keys_as_null(sentinel):
    prisma = MockPrisma()
    importer = RoomImporter(prisma)
    vnum_map = {3001: (30, 1), 3002: (30, 2)}

    exit_data: dict = {'destination': '3002'}
    if sentinel is not None:
        exit_data['key'] = sentinel

    result = await importer.import_exit(
        30, 1, 'North', exit_data,
        vnum_map=vnum_map,
        object_vnum_map={1614: (16, 14)},
    )
    assert result['success'] is True
    assert result['keyZoneId'] is None
    assert result['keyId'] is None


@pytest.mark.asyncio
async def test_import_exit_unknown_key_left_null():
    """A key referencing an object we never imported should land as NULL, not raise."""
    prisma = MockPrisma()
    importer = RoomImporter(prisma)
    vnum_map = {3001: (30, 1), 3002: (30, 2)}

    result = await importer.import_exit(
        30, 1, 'North',
        {'destination': '3002', 'key': '99999'},  # not in object_vnum_map
        vnum_map=vnum_map,
        object_vnum_map={},
    )
    assert result['success'] is True
    assert result['keyZoneId'] is None
    assert result['keyId'] is None


@pytest.mark.asyncio
async def test_import_exit_unresolved_target_does_not_null_existing_on_update():
    """--zone re-import: unresolved cross-zone target must not overwrite a good value."""
    prisma = MockPrisma()
    importer = RoomImporter(prisma)

    # Empty-ish map (single-zone run): destination 3002 is unknown
    result = await importer.import_exit(
        16, 84, 'North',
        {'destination': '3002', 'key': '1614'},
        vnum_map={1684: (16, 84)},
        object_vnum_map={},
    )
    assert result['success'] is True
    upsert = prisma.roomexit.upserts[0]
    assert 'toZoneId' not in upsert['update']
    assert 'toRoomId' not in upsert['update']
    assert 'keyZoneId' not in upsert['update']
    assert 'keyId' not in upsert['update']
    # create path still records NULL for a brand-new row
    assert upsert['create']['toZoneId'] is None


@pytest.mark.asyncio
async def test_import_exit_resolved_target_updates():
    prisma = MockPrisma()
    importer = RoomImporter(prisma)
    await importer.import_exit(
        30, 1, 'North', {'destination': '3002'}, vnum_map={3002: (30, 2), 3001: (30, 1)}
    )
    update = prisma.roomexit.upserts[0]['update']
    assert update['toZoneId'] == 30 and update['toRoomId'] == 2


@pytest.mark.asyncio
async def test_seed_vnum_maps_from_db_fills_missing_only():
    from fierylib.importers.vnum_seed import seed_vnum_maps_from_db

    class P:
        async def query_raw(self, sql):
            if '"Room"' in sql:
                return [{'zone_id': 31, 'id': 5}, {'zone_id': 30, 'id': 150}]
            if '"Mobs"' in sql:
                return []
            return [{'zone_id': 16, 'id': 14}]

    maps = {'rooms': {3005: (30, 5)}, 'mobs': {}, 'objects': {}}
    added = await seed_vnum_maps_from_db(P(), maps)
    assert maps['rooms'][3105] == (31, 5)
    assert maps['rooms'][3150] == (30, 150)
    assert maps['rooms'][3005] == (30, 5)  # in-run entry untouched
    assert maps['objects'][1614] == (16, 14)
    assert added == {'rooms': 2, 'mobs': 0, 'objects': 1}
