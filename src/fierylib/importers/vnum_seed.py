"""Seed legacy-vnum -> (zone_id, id) maps from rows already in the database.

A single-zone import (``--zone N``) only parses that zone's files, so its vnum
maps start empty. Cross-zone exit targets, door keys and reset references then
fail to resolve. Seeding the maps from the DB lets those lookups resolve to the
rows imported earlier.

Legacy vnum = zone_id * 100 + id (ids may exceed 99; the filename-based
conversion keeps the same arithmetic).
"""

from typing import Any, Dict, Tuple

_TABLES = {
    "rooms": 'SELECT zone_id, id FROM "Room"',
    "mobs": 'SELECT zone_id, id FROM "Mobs"',
    "objects": 'SELECT zone_id, id FROM "Objects"',
}


async def seed_vnum_maps_from_db(
    prisma: Any, vnum_maps: Dict[str, Dict[int, Tuple[int, int]]]
) -> Dict[str, int]:
    """Add DB-resident entities to ``vnum_maps`` without overriding existing entries.

    Entries already present (from the current import run) win.
    Returns the number of entries added per map.
    """
    added: Dict[str, int] = {}
    for key, sql in _TABLES.items():
        target = vnum_maps.setdefault(key, {})
        rows = await prisma.query_raw(sql)
        count = 0
        for row in rows:
            zone_id, ident = int(row["zone_id"]), int(row["id"])
            legacy = zone_id * 100 + ident
            if legacy not in target:
                target[legacy] = (zone_id, ident)
                count += 1
        added[key] = count
    return added
