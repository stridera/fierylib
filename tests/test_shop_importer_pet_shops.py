from types import SimpleNamespace as NS
from typing import Any, Dict, List

import pytest

from fierylib.converters.id_converter import CompositeId
from fierylib.importers.shop_importer import ShopImporter


class MockResets:
    def __init__(self, rows):
        self.rows = rows

    async def find_many(self, where: Dict[str, Any]):
        return [
            NS(mobZoneId=mz, mobId=mid)
            for (rz, rid, mz, mid) in self.rows
            if rz == where["roomZoneId"] and rid == where["roomId"]
        ]


class MockShops:
    def __init__(self, rows):
        self.rows = rows

    async def find_many(self, where: Dict[str, Any]):
        return [
            NS(zoneId=z, id=i)
            for (z, i, kz, kid) in self.rows
            if (kz, kid) == (where["keeperZoneId"], where["keeperId"])
        ]


class MockShopMobs:
    def __init__(self):
        self.upserts: List[Dict[str, Any]] = []

    async def upsert(self, where: Dict[str, Any], data: Dict[str, Any]):
        self.upserts.append({"where": where, **data})


class MockPrisma:
    def __init__(self, resets, shops):
        self.mobresets = MockResets(resets)
        self.shops = MockShops(shops)
        self.shopmobs = MockShopMobs()


class StubResolver:
    async def resolve_room(self, vnum, context_zone=None):
        mapping = {3091: CompositeId(zone_id=30, id=91), 10056: CompositeId(zone_id=100, id=56)}
        return mapping.get(vnum)


def make(resets, shops):
    importer = ShopImporter(MockPrisma(resets, shops))
    importer.resolver = StubResolver()
    return importer


@pytest.mark.asyncio
async def test_mount_shop_links_deduped_backroom_mobs_unlimited():
    resets = [
        (30, 91, 30, 91),  # keeper Jorhan in the shop room
        # backroom (30/92) holds the mounts, some reset twice
        (30, 92, 30, 81),
        (30, 92, 30, 102),
        (30, 92, 0, 45),
        (30, 92, 30, 81),
        (30, 93, 30, 5),  # unrelated room, ignored
    ]
    importer = make(resets, [(30, 91, 30, 91)])
    result = await importer.import_pet_shop_from_legacy_spec(3091)
    assert result["success"] is True
    assert result["shop_found"] is True
    assert result["shop"] == "30:91"
    assert result["mobs_linked"] == 3
    rows = importer.prisma.shopmobs.upserts
    assert sorted((r["create"]["mobZoneId"], r["create"]["mobId"]) for r in rows) == [
        (0, 45),
        (30, 81),
        (30, 102),
    ]
    assert all(r["create"]["amount"] == -1 for r in rows)
    assert all(r["create"]["shopZoneId"] == 30 and r["create"]["shopId"] == 91 for r in rows)


@pytest.mark.asyncio
async def test_keeper_with_two_shops_gets_pets_on_highest_shop_id():
    resets = [(100, 56, 100, 29), (100, 57, 100, 6), (100, 57, 100, 5)]
    shops = [(100, 54, 100, 29), (100, 56, 100, 29)]
    importer = make(resets, shops)
    result = await importer.import_pet_shop_from_legacy_spec(10056)
    assert result["shop"] == "100:56"
    assert result["mobs_linked"] == 2


@pytest.mark.asyncio
async def test_missing_keeper_or_room_reports_failure_without_writes():
    importer = make([(30, 92, 30, 81)], [])
    result = await importer.import_pet_shop_from_legacy_spec(3091)
    assert result["success"] is False and result["shop_found"] is False
    result = await importer.import_pet_shop_from_legacy_spec(9999)
    assert result["success"] is False and "not found" in result["error"]
    assert importer.prisma.shopmobs.upserts == []


@pytest.mark.asyncio
async def test_dry_run_counts_but_does_not_write():
    resets = [(30, 91, 30, 91), (30, 92, 30, 81)]
    importer = make(resets, [(30, 91, 30, 91)])
    result = await importer.import_pet_shop_from_legacy_spec(3091, dry_run=True)
    assert result["shop_found"] is True and result["mobs_linked"] == 1
    assert importer.prisma.shopmobs.upserts == []
