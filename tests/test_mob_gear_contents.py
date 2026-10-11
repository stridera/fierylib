"""Items inside a container a mob carries or wears survive parse and import (no DB)."""

import asyncio
import re
from pathlib import Path
from types import SimpleNamespace

from fierylib.importers.reset_importer import ResetImporter
from mud.mudfile import MudData
from mud.types.zone import Zone

SQL = (
    Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-11-mob-gear-contents.sql"
).read_text(encoding="utf-8")

ZONE = """#23
Test Zone~
2399 25 2 100 2 3
M 0 2308 1 2359 	(a monstrous canopy spider)
G 1 2303 3 -1 	(a large white cocoon)
P 1 2302 3 2303 	(a little bronze key)
E 1 2310 1 14 	(a leather satchel)
P 1 2311 1 2310 	(a coin pouch)
P 1 2312 1 2311 	(a gold coin)
P 1 2313 1 2310 	(a map)
G 1 2314 1 -1 	(a plain sack)
S
$
"""


def _parse():
    return Zone.parse(MudData(ZONE.split("\n")))


def test_parser_nests_p_under_carried_and_worn_items():
    (mob,) = _parse().resets["mob"]
    (cocoon,) = [g for g in mob["carrying"] if g["id"] == 2303]
    assert [c["id"] for c in cocoon["contains"]] == [2302]
    assert cocoon["contains"][0]["max"] == 3
    (satchel,) = mob["equipped"]
    # pouch and map sit directly in the satchel; the coin sits inside the pouch
    assert [c["id"] for c in satchel["contains"]] == [2311, 2313]
    assert [c["id"] for c in satchel["contains"][0]["contains"]] == [2312]
    # an item with no P stays flat
    (sack,) = [g for g in mob["carrying"] if g["id"] == 2314]
    assert "contains" not in sack


class _Table:
    def __init__(self):
        self.rows = []

    async def create(self, data):
        row = SimpleNamespace(id=len(self.rows) + 1, **data)
        self.rows.append(row)
        return row


class _Objects:
    async def find_unique(self, where):
        return SimpleNamespace(wearFlags=[])


def _import():
    equipment, contents = _Table(), _Table()
    prisma = SimpleNamespace(
        objects=_Objects(),
        mobresets=_Table(),
        mobresetequipment=equipment,
        mobresetequipmentcontents=contents,
    )
    imp = ResetImporter(prisma)
    objs = {v: (23, v - 2300) for v in range(2300, 2320)}
    imp.set_vnum_maps(room_map={2359: (23, 59)}, mob_map={2308: (23, 8)}, object_map=objs)
    (mob,) = _parse().resets["mob"]
    result = asyncio.run(imp.import_mob_reset(mob, 23))
    assert result["success"], result
    return equipment.rows, contents.rows


def test_importer_writes_nested_contents_under_their_equipment_row():
    equipment, contents = _import()
    eq_by_obj = {e.objectId: e.id for e in equipment}
    by_obj = {c.objectId: c for c in contents}

    key = by_obj[2]
    assert key.equipmentId == eq_by_obj[3]  # cocoon 23/3
    assert key.parentContentId is None
    assert key.maxInstances == 3 and key.quantity == 1

    pouch, coin, map_ = by_obj[11], by_obj[12], by_obj[13]
    assert pouch.equipmentId == coin.equipmentId == map_.equipmentId == eq_by_obj[10]
    assert pouch.parentContentId is None and map_.parentContentId is None
    assert coin.parentContentId == pouch.id
    assert len(contents) == 4  # nothing for the plain sack


def test_importer_treats_nonpositive_p_max_as_unlimited():
    imp = ResetImporter(SimpleNamespace(mobresetequipmentcontents=(table := _Table())))
    imp.set_vnum_maps(room_map={}, mob_map={}, object_map={2302: (23, 2)})
    asyncio.run(imp._import_gear_contents([{"id": 2302, "max": 0}], equipment_id=7))
    assert table.rows[0].maxInstances == 999


def test_sql_patch_is_keyed_by_natural_keys_and_idempotent():
    assert not re.search(r"\be\.id\s*=\s*\d", SQL)
    assert "(23, 8, 23, 459, 23, 3, 23, 2, 3)" in SQL  # canopy spider, cocoon, bronze key
    assert SQL.count("\n    (") >= 25
    assert "CREATE TABLE IF NOT EXISTS" in SQL
    assert "WHERE NOT EXISTS" in SQL
    assert SQL.strip().endswith("COMMIT;")
