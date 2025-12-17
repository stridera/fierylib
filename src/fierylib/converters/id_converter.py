"""
ID Converter - Converts legacy CircleMUD IDs to composite primary keys

Legacy Format: Single integer (e.g., 3045, 12399, 7475)
New Format: Composite (zoneId, id)

Conversion Algorithms:

1. FILENAME-BASED (Primary - supports unlimited items per zone):
   Used when zone is known from file context (e.g., importing from 73.mob)
   - zoneId = zone_from_filename
   - id = legacy_id - (zoneId * 100)

   Examples:
   - In 73.mob, #7300 → (zoneId: 73, id: 0)
   - In 73.mob, #7475 → (zoneId: 73, id: 175)
   - In 4.obj, #500 → (zoneId: 4, id: 100)

2. LEGACY LOOKUP (Fallback - limited to 100 items per zone):
   Used when zone is unknown (e.g., reset commands referencing entities)
   - zoneId = legacy_id // 100
   - id = legacy_id % 100

   NOTE: This only works for entities with ids 0-99!
   For entities with id >= 100, you MUST know the zone from context.

Special Cases:
- Zone 0 uses negative vnums for special items/mobs (converted to positive IDs)

Examples:
- Filename-based: In 73.mob, #7475 → (zoneId: 73, id: 175)
- Legacy lookup: #3045 → (zoneId: 30, id: 45)  [works, id < 100]
- Legacy lookup: #7475 → (zoneId: 74, id: 75)  [WRONG! mob is in zone 73]
"""

from dataclasses import dataclass
from typing import NamedTuple, Optional


class CompositeId(NamedTuple):
    """Composite primary key (zoneId, id)"""

    zone_id: int
    id: int


@dataclass
class IdConversionError(Exception):
    """Raised when ID conversion fails"""

    legacy_id: int
    reason: str

    def __str__(self) -> str:
        return f"Invalid legacy ID {self.legacy_id}: {self.reason}"


def convert_zone_id(legacy_zone_id: int) -> int:
    """
    Convert legacy zone ID to new zone ID

    Args:
        legacy_zone_id: Legacy zone ID (0-999)

    Returns:
        Zone ID (unchanged from legacy)

    Examples:
        >>> convert_zone_id(0)
        0
        >>> convert_zone_id(30)
        30
        >>> convert_zone_id(123)
        123
    """
    if legacy_zone_id < 0:
        raise IdConversionError(legacy_zone_id, "Zone ID cannot be negative")

    return legacy_zone_id


def vnum_to_composite(legacy_vnum: int, zone_id: int) -> CompositeId:
    """
    Convert legacy vnum to composite ID using filename-based algorithm

    This is the PRIMARY conversion method that supports unlimited items per zone.
    Use this when you know which zone file the entity came from.

    Formula: id = legacy_vnum - (zone_id * 100)

    Args:
        legacy_vnum: Legacy CircleMUD vnum (e.g., 7475, 500, 3045)
        zone_id: Zone ID from filename (e.g., 73 from 73.mob)

    Returns:
        CompositeId with (zone_id, id)

    Examples:
        >>> vnum_to_composite(7475, 73)  # From 73.mob
        CompositeId(zone_id=73, id=175)
        >>> vnum_to_composite(7300, 73)  # From 73.mob
        CompositeId(zone_id=73, id=0)
        >>> vnum_to_composite(500, 4)  # From 4.obj
        CompositeId(zone_id=4, id=100)
        >>> vnum_to_composite(3045, 30)  # From 30.wld
        CompositeId(zone_id=30, id=45)
    """
    # Zone 0 allows negative vnums (special items/mobs), other zones don't
    if zone_id != 0 and legacy_vnum < 0:
        raise IdConversionError(legacy_vnum, "Vnum cannot be negative (except in zone 0)")

    # Special handling for zone 0: convert negative vnums to positive IDs
    if zone_id == 0 and legacy_vnum < 0:
        entity_id = abs(legacy_vnum)
    else:
        # Calculate id by removing zone offset
        entity_id = legacy_vnum - (zone_id * 100)

        if entity_id < 0:
            raise IdConversionError(
                legacy_vnum,
                f"Vnum {legacy_vnum} is less than zone base {zone_id * 100}"
            )

    return CompositeId(zone_id=zone_id, id=entity_id)


def legacy_id_to_composite(legacy_id: int) -> CompositeId:
    """
    Convert legacy flat ID to composite (zoneId, id) - FALLBACK METHOD

    WARNING: This method only works for entities with id 0-99!
    For zones with >100 items, use vnum_to_composite() instead with the known zone.

    This method uses the legacy algorithm:
    - zone_id = legacy_id // 100
    - id = legacy_id % 100

    Use Cases:
    - Reset commands that don't know which file an entity came from
    - Entities in zones with <100 items (ids 0-99)

    Limitations:
    - Cannot find entities with id >= 100 (will calculate wrong zone)
    - Example: #7475 → zone 74, id 75 (WRONG if mob is actually in zone 73)

    Args:
        legacy_id: Legacy CircleMUD ID (e.g., 3045)

    Returns:
        CompositeId with (zone_id, id)

    Raises:
        IdConversionError: If ID is invalid (negative)

    Examples:
        >>> legacy_id_to_composite(3045)
        CompositeId(zone_id=30, id=45)
        >>> legacy_id_to_composite(12399)
        CompositeId(zone_id=123, id=99)
        >>> legacy_id_to_composite(0)
        CompositeId(zone_id=0, id=0)
        >>> legacy_id_to_composite(7475)  # WRONG! Assumes zone 74
        CompositeId(zone_id=74, id=75)    # But mob is in zone 73!
    """
    if legacy_id < 0:
        raise IdConversionError(legacy_id, "ID cannot be negative")

    # Extract zone and id using legacy algorithm
    zone_id = legacy_id // 100
    entity_id = legacy_id % 100

    return CompositeId(zone_id=zone_id, id=entity_id)


def composite_to_legacy_id(zone_id: int, vnum: int) -> int:
    """
    Convert composite (zoneId, vnum) back to legacy ID

    Mainly for debugging/validation. Not used in production import.

    Args:
        zone_id: Zone ID
        vnum: Virtual number (0-99)

    Returns:
        Legacy flat ID

    Raises:
        IdConversionError: If vnum is out of range

    Examples:
        >>> composite_to_legacy_id(30, 45)
        3045
        >>> composite_to_legacy_id(0, 0)
        0
        >>> composite_to_legacy_id(123, 99)
        12399
    """
    if vnum < 0 or vnum > 99:
        raise IdConversionError(
            zone_id * 100 + vnum, f"vnum {vnum} must be in range 0-99"
        )

    return zone_id * 100 + vnum


def validate_composite_id(zone_id: int, vnum: int) -> bool:
    """
    Validate that a composite ID is well-formed

    Args:
        zone_id: Zone ID
        vnum: Virtual number

    Returns:
        True if valid

    Raises:
        IdConversionError: If ID components are invalid
    """
    if zone_id < 0:
        raise IdConversionError(zone_id * 100 + vnum, "Zone ID cannot be negative")

    if vnum < 0 or vnum > 99:
        raise IdConversionError(
            zone_id * 100 + vnum, f"vnum {vnum} must be in range 0-99"
        )

    return True
