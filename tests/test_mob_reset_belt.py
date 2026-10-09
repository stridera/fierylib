"""Belt-only objects reset in the belt slot, not the waist (no DB)."""

import asyncio
import re
from pathlib import Path
from types import SimpleNamespace

from fierylib.importers.reset_importer import ResetImporter, belt_slot_for

SQL = (
    Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-09-mob-reset-belt.sql"
).read_text(encoding="utf-8")


def test_belt_only_object_named_at_the_waist_goes_to_the_belt():
    assert belt_slot_for("WAIST", ["BELT"]) == "OBELT"
    assert belt_slot_for("WAIST", ["OFFHAND", "BELT"]) == "OBELT"


def test_waist_only_object_named_at_the_belt_goes_to_the_waist():
    assert belt_slot_for("OBELT", ["WAIST"]) == "WAIST"


def test_correct_or_undecidable_slots_are_kept():
    assert belt_slot_for("OBELT", ["BELT"]) == "OBELT"
    assert belt_slot_for("WAIST", ["WAIST"]) == "WAIST"
    # both flags or neither: the zone file decides
    assert belt_slot_for("WAIST", ["WAIST", "BELT"]) == "WAIST"
    assert belt_slot_for("OBELT", []) == "OBELT"
    assert belt_slot_for("WAIST", ["LEGS"]) == "WAIST"
    # other slots and carried items are never touched
    assert belt_slot_for("WIELD", ["BELT"]) == "WIELD"
    assert belt_slot_for(None, ["BELT"]) is None


class _Objects:
    def __init__(self, flags):
        self.flags = flags

    async def find_unique(self, where):
        key = where["zoneId_id"]
        return SimpleNamespace(wearFlags=self.flags[(key["zoneId"], key["id"])])


class _Equipment:
    def __init__(self):
        self.rows = []

    async def create(self, data):
        self.rows.append(data)


class _Resets:
    async def create(self, data):
        return SimpleNamespace(id=1)


def test_importer_stores_the_belt_slot_from_the_objects_wear_flags():
    equipment = _Equipment()
    prisma = SimpleNamespace(
        objects=_Objects({(588, 20): ["BELT"], (11, 27): ["WAIST"]}),
        mobresets=_Resets(),
        mobresetequipment=equipment,
    )
    imp = ResetImporter(prisma)
    imp.set_vnum_maps(
        room_map={1: (1, 1)},
        mob_map={2: (1, 2)},
        object_map={1: (588, 20), 2: (11, 27)},
    )
    reset = {
        "id": 2,
        "max": 1,
        "room": 1,
        "name": "a guard",
        "equipped": [
            {"id": 1, "max": 100, "location": SimpleNamespace(name="WAIST")},
            {"id": 2, "max": 100, "location": SimpleNamespace(name="WAIST")},
        ],
        "carrying": [],
    }
    result = asyncio.run(imp.import_mob_reset(reset, 1))
    assert result["success"], result
    assert [r["wearLocation"] for r in equipment.rows] == ["OBELT", "WAIST"]


def test_sql_is_keyed_by_the_object_natural_key_and_guarded():
    assert not re.search(r"\bid\s*=\s*\d", SQL)
    assert "o.zone_id = e.object_zone_id" in SQL and "o.id = e.object_id" in SQL
    # Each UPDATE only touches a row whose slot disagrees with the flags.
    assert SQL.count("NOT ('") == 2
    assert "e.wear_location = 'WAIST'" in SQL
