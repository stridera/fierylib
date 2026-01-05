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


class EntityResolver:
    """
    Resolves legacy vnums to composite IDs with database verification.

    Zone boundaries in CircleMUD are flexible - a zone can contain vnums
    beyond zone*100+99. For example, zone 30 (Mielikki) has vnums 3000-3499.

    Resolution Strategy:
    1. Try context zone first (most common - entities are usually local)
    2. Fall back to calculated zone (vnum // 100) for cross-zone references
    3. Verify entity exists in database before returning

    Usage:
        resolver = EntityResolver(prisma_client)
        result = await resolver.resolve_object(3109, context_zone=30)
        # Returns CompositeId(zone_id=30, id=109) if object exists

    This eliminates the need for duplicated vnum // 100 logic everywhere.
    """

    def __init__(self, prisma_client):
        """
        Initialize resolver with Prisma client

        Args:
            prisma_client: Prisma client instance for database lookups
        """
        self.prisma = prisma_client

    async def resolve_object(
        self, legacy_vnum: int, context_zone: Optional[int] = None
    ) -> Optional[CompositeId]:
        """
        Resolve legacy object vnum to composite ID

        Args:
            legacy_vnum: Legacy object vnum (e.g., 3109)
            context_zone: Zone context for resolution (e.g., 30 from 30.shp)

        Returns:
            CompositeId if object found, None otherwise

        Examples:
            >>> await resolver.resolve_object(3109, context_zone=30)
            CompositeId(zone_id=30, id=109)  # Found in same zone
            >>> await resolver.resolve_object(1029, context_zone=30)
            CompositeId(zone_id=10, id=29)   # Found in zone 10 (cross-zone)
        """
        return await self._resolve_entity("objects", legacy_vnum, context_zone)

    async def resolve_mob(
        self, legacy_vnum: int, context_zone: Optional[int] = None
    ) -> Optional[CompositeId]:
        """
        Resolve legacy mob vnum to composite ID

        Args:
            legacy_vnum: Legacy mob vnum (e.g., 3149)
            context_zone: Zone context for resolution

        Returns:
            CompositeId if mob found, None otherwise
        """
        return await self._resolve_entity("mobs", legacy_vnum, context_zone)

    async def resolve_room(
        self, legacy_vnum: int, context_zone: Optional[int] = None
    ) -> Optional[CompositeId]:
        """
        Resolve legacy room vnum to composite ID

        Args:
            legacy_vnum: Legacy room vnum (e.g., 3150)
            context_zone: Zone context for resolution

        Returns:
            CompositeId if room found, None otherwise
        """
        return await self._resolve_entity("room", legacy_vnum, context_zone)

    async def _resolve_entity(
        self, table: str, legacy_vnum: int, context_zone: Optional[int]
    ) -> Optional[CompositeId]:
        """
        Internal method to resolve any entity type

        Args:
            table: Prisma table name ('objects', 'mobs', 'rooms')
            legacy_vnum: Legacy vnum
            context_zone: Zone context

        Returns:
            CompositeId if found, None otherwise
        """
        vnum = int(legacy_vnum)

        # Strategy 1: Try context zone first (most common case)
        if context_zone is not None:
            same_zone_id = vnum - (context_zone * 100)
            if same_zone_id >= 0:
                if await self._entity_exists(table, context_zone, same_zone_id):
                    return CompositeId(zone_id=context_zone, id=same_zone_id)

        # Strategy 2: Try calculated zone (vnum // 100)
        calc_zone = vnum // 100
        calc_id = vnum % 100
        if await self._entity_exists(table, calc_zone, calc_id):
            return CompositeId(zone_id=calc_zone, id=calc_id)

        # Not found
        return None

    async def _entity_exists(self, table: str, zone_id: int, entity_id: int) -> bool:
        """
        Check if entity exists in database

        Args:
            table: Prisma table name
            zone_id: Zone ID
            entity_id: Entity ID

        Returns:
            True if entity exists
        """
        try:
            model = getattr(self.prisma, table)
            result = await model.find_unique(
                where={"zoneId_id": {"zoneId": zone_id, "id": entity_id}}
            )
            return result is not None
        except Exception:
            return False
