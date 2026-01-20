"""
Room Importer - Imports room data from legacy files to PostgreSQL

Handles:
- Rooms with composite primary keys (zoneId, vnum)
- Room exits with directional connections
- Room sectors (terrain types)
- Base light level (converted from legacy DARK/ALWAYS_LIT flags)
- Extra descriptions
"""

from typing import Optional, Any, Dict
from pathlib import Path
import sys

from mud.types.world import World
from prisma import Prisma  # runtime client type
from mud.mudfile import MudData
from mud.bitflags import BitFlags
from fierylib.converters import legacy_id_to_composite, normalize_flags, convert_legacy_colors, strip_markup


class RoomImporter:
    """Imports room data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client: "Prisma"):
        """
        Initialize room importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client

    @staticmethod
    def map_sector(sector: str) -> str:
        """
        Map legacy sector string to Prisma Sector enum string

        Args:
            sector: Legacy sector string value

        Returns:
            Prisma enum string (already uppercase)

        Examples:
            >>> RoomImporter.map_sector('FOREST')
            'FOREST'
        """
        return sector

    @staticmethod
    def flags_to_base_light_level(flags: list[str]) -> int:
        """
        Convert legacy room flags to base light level.

        Light level system:
        - Positive values = lit (higher = brighter)
        - Zero = ambient (depends on time of day, weather, sector)
        - Negative values = dark (lower = darker, needs light source)

        Legacy flag mapping:
        - ALWAYS_LIT → 5 (brilliantly lit, ignores time/weather)
        - DARK → -3 (deep darkness, needs bright light to see)
        - No flags → 0 (ambient lighting)

        Args:
            flags: List of legacy room flag strings

        Returns:
            Base light level integer

        Examples:
            >>> RoomImporter.flags_to_base_light_level(['DARK'])
            -3
            >>> RoomImporter.flags_to_base_light_level(['ALWAYS_LIT'])
            5
            >>> RoomImporter.flags_to_base_light_level([])
            0
        """
        # Normalize flag names for comparison
        normalized = [f.upper().replace('_', '') for f in flags]

        # ALWAYS_LIT takes precedence (if both are set, room is lit)
        if 'ALWAYSLIT' in normalized:
            return 5

        # DARK makes the room require light sources
        if 'DARK' in normalized:
            return -3

        # Default: ambient lighting (time/weather dependent)
        return 0

    @staticmethod
    def flags_to_room_state(flags: list[str]) -> dict:
        """
        Convert legacy room flags to room state boolean fields.

        Legacy flag mapping:
        - PEACEFUL → isPeaceful: true
        - NO_MAGIC / NOMAGIC → allowsMagic: false
        - NO_RECALL / NORECALL → allowsRecall: false
        - NO_SUMMON / NOSUMMON → allowsSummon: false
        - NO_TELEPORT / NOTELEPORT → allowsTeleport: false
        - DEATH / DT / DEATH_TRAP → isDeathTrap: true
        - GODROOM → entryRestriction: Lua script for god check

        Args:
            flags: List of legacy room flag strings

        Returns:
            Dict with room state fields

        Examples:
            >>> RoomImporter.flags_to_room_state(['PEACEFUL', 'NO_MAGIC'])
            {'isPeaceful': True, 'allowsMagic': False, ...}
        """
        # Normalize flag names for comparison (uppercase, no underscores)
        normalized = [f.upper().replace('_', '').replace('-', '') for f in flags]

        result = {
            'isPeaceful': False,
            'allowsMagic': True,
            'allowsRecall': True,
            'allowsSummon': True,
            'allowsTeleport': True,
            'isDeathTrap': False,
            'entryRestriction': None,
        }

        # Check each flag
        if 'PEACEFUL' in normalized:
            result['isPeaceful'] = True

        if 'NOMAGIC' in normalized:
            result['allowsMagic'] = False

        if 'NORECALL' in normalized:
            result['allowsRecall'] = False

        if 'NOSUMMON' in normalized:
            result['allowsSummon'] = False

        if 'NOTELEPORT' in normalized:
            result['allowsTeleport'] = False

        # Death trap variants
        if any(f in normalized for f in ['DEATH', 'DT', 'DEATHTRAP']):
            result['isDeathTrap'] = True

        # GODROOM → Lua entry restriction
        if 'GODROOM' in normalized:
            result['entryRestriction'] = 'return actor:is_god()'

        return result

    @staticmethod
    def map_direction(direction_str: str) -> Optional[str]:
        """
        Map direction string to Prisma Direction enum

        Args:
            direction_str: Direction name (e.g., "North", "NORTH")

        Returns:
            Prisma enum string or None if invalid

        Examples:
            >>> RoomImporter.map_direction("North")
            'NORTH'
            >>> RoomImporter.map_direction("Up")
            'UP'
        """
        direction_map = {
            "NORTH": "NORTH",
            "EAST": "EAST",
            "SOUTH": "SOUTH",
            "WEST": "WEST",
            "UP": "UP",
            "DOWN": "DOWN",
        }
        return direction_map.get(direction_str.upper())

    async def import_room(
        self,
        room: Dict[str, Any],
        zone_id: int,
        dry_run: bool = False,
        base_zone_override: Optional[int] = None,
        skip_exits: bool = False,
    ) -> Dict[str, Any]:
        """
        Import a single room to the database

        Args:
            room: Parsed room dict from World.parse()
            zone_id: Zone ID (already converted, e.g., 30 or 1000)
            dry_run: If True, validate but don't write to database
            skip_exits: If True, skip exit import (for two-pass import to avoid FK issues)

        Returns:
            Dict with import results

        Examples:
            >>> room = {"id": "3045", "name": "Test Room", ...}
            >>> result = await importer.import_room(room, 30)
            >>> print(result["vnum"])
            45
        """
        # Derive vnum. Support extended zones (>100 rooms) where a single zone file
        # can contain room numbers that spill into the next century (e.g. 3000..3153 for zone 30).
        # In extended mode we compute vnum as (room_id - base_zone*100) allowing vnum > 99.
        room_id = int(room["id"])
        # Always derive vnum from the zone id taken from filename (base_zone_override if provided)
        base_zone = base_zone_override if base_zone_override is not None else zone_id
        vnum = room_id - (base_zone * 100)
        if vnum < 0:
            return {
                "success": False,
                "zone_id": zone_id,
                "name": room.get("name", "unknown"),
                "action": "failed",
                "error": f"Computed negative vnum {vnum} for room_id {room_id} and zone {base_zone}",
            }

        # Map sector
        sector = self.map_sector(room["sector"])

        # Convert legacy flags to base light level and room state
        raw_flags = room.get("flags", [])
        if isinstance(raw_flags, BitFlags):
            raw_flags = raw_flags.json_repr()
        base_light_level = self.flags_to_base_light_level(raw_flags)
        room_state = self.flags_to_room_state(raw_flags)

        if dry_run:
            return {
                "success": True,
                "zone_id": zone_id,
                "vnum": vnum,
                "name": room["name"],
                "action": "validated",
                "data": {
                    "zoneId": zone_id,
                    "id": vnum,
                    "name": room["name"],
                    "roomDescription": room["description"],
                    "sector": sector,
                    "baseLightLevel": base_light_level,
                    **room_state,
                },
            }

        try:
            # Convert legacy color codes to XML-Lite markup
            room_name = convert_legacy_colors(room["name"])
            room_description = convert_legacy_colors(room["description"])

            # Upsert room with composite key
            room_record = await self.prisma.room.upsert(
                where={
                    "zoneId_id": {
                        "zoneId": zone_id,
                        "id": vnum,
                    }
                },
                data={
                    "create": {
                        "zoneId": zone_id,
                        "id": vnum,
                        "name": room_name,
                        "roomDescription": room_description,
                        "plainRoomDescription": strip_markup(room_description),
                        "sector": sector,
                        "baseLightLevel": base_light_level,
                        "isPeaceful": room_state['isPeaceful'],
                        "allowsMagic": room_state['allowsMagic'],
                        "allowsRecall": room_state['allowsRecall'],
                        "allowsSummon": room_state['allowsSummon'],
                        "allowsTeleport": room_state['allowsTeleport'],
                        "isDeathTrap": room_state['isDeathTrap'],
                        "entryRestriction": room_state['entryRestriction'],
                    },
                    "update": {
                        "name": room_name,
                        "roomDescription": room_description,
                        "plainRoomDescription": strip_markup(room_description),
                        "sector": sector,
                        "baseLightLevel": base_light_level,
                        "isPeaceful": room_state['isPeaceful'],
                        "allowsMagic": room_state['allowsMagic'],
                        "allowsRecall": room_state['allowsRecall'],
                        "allowsSummon": room_state['allowsSummon'],
                        "allowsTeleport": room_state['allowsTeleport'],
                        "isDeathTrap": room_state['isDeathTrap'],
                        "entryRestriction": room_state['entryRestriction'],
                    },
                },
            )

            # Import exits (unless skip_exits is True)
            exits_imported = 0
            if not skip_exits and room.get("exits"):
                for direction_str, exit_data in room["exits"].items():
                    exit_result = await self.import_exit(
                        zone_id, vnum, direction_str, exit_data
                    )
                    if exit_result["success"]:
                        exits_imported += 1

            # Import extra descriptions
            extras_imported = 0
            if room.get("extras"):
                for extra in room["extras"]:
                    extra_result = await self.import_extra_description(
                        zone_id, vnum, extra
                    )
                    if extra_result["success"]:
                        extras_imported += 1

            return {
                "success": True,
                "zone_id": zone_id,
                "vnum": vnum,
                "name": room["name"],
                "action": "imported",
                "exits": exits_imported,
                "extras": extras_imported,
            }

        except Exception as e:
            return {
                "success": False,
                "zone_id": zone_id,
                "vnum": vnum,
                "name": room.get("name", "unknown"),
                "action": "failed",
                "error": str(e),
            }

    async def import_exits_for_room(
        self,
        room: Dict[str, Any],
        zone_id: int,
        base_zone_override: Optional[int] = None,
        vnum_map: Optional[Dict[int, tuple[int, int]]] = None,
    ) -> Dict[str, Any]:
        """
        Import exits for a room (separate from room import for two-pass approach)

        Args:
            room: Parsed room dict from World.parse()
            zone_id: Zone ID
            base_zone_override: Override base zone for id calculation
            vnum_map: Optional map of legacy_room_id -> (zone_id, id) for cross-zone exits

        Returns:
            Dict with import results
        """
        room_id = int(room["id"])
        base_zone = base_zone_override if base_zone_override is not None else zone_id
        room_composite_id = room_id - (base_zone * 100)

        exits_imported = 0
        exits_failed = 0

        if room.get("exits"):
            for direction_str, exit_data in room["exits"].items():
                exit_result = await self.import_exit(
                    zone_id, room_composite_id, direction_str, exit_data, vnum_map=vnum_map
                )
                if exit_result["success"]:
                    exits_imported += 1
                else:
                    exits_failed += 1

        return {
            "success": True,
            "zone_id": zone_id,
            "id": room_composite_id,
            "exits_imported": exits_imported,
            "exits_failed": exits_failed,
        }

    async def import_exit(
        self,
        room_zone_id: int,
        room_id: int,
        direction_str: str,
        exit_data: Dict[str, Any],
        vnum_map: Optional[Dict[int, tuple[int, int]]] = None,
    ) -> Dict[str, Any]:
        """
        Import a room exit

        Args:
            room_zone_id: Source room's zone ID
            room_id: Source room's id (composite key part)
            direction_str: Direction name (e.g., "NORTH")
            exit_data: Exit data dict
            vnum_map: Optional map of legacy_room_id -> (zone_id, id) for cross-zone exits

        Returns:
            Dict with import results
        """
        direction = self.map_direction(direction_str)
        if not direction:
            return {
                "success": False,
                "error": f"Invalid direction: {direction_str}",
            }

        # Process exit flags and determine defaultState
        raw_flags = exit_data.get("flags", [])
        if isinstance(raw_flags, BitFlags):
            raw_flags = raw_flags.json_repr()

        # Determine defaultState from CLOSED/LOCKED flags
        # Priority: LOCKED > CLOSED > OPEN
        default_state = "OPEN"
        if "LOCKED" in raw_flags or "locked" in [f.lower() for f in raw_flags]:
            default_state = "LOCKED"
        elif "CLOSED" in raw_flags or "closed" in [f.lower() for f in raw_flags]:
            default_state = "CLOSED"

        # Normalize flags (this will filter out CLOSED/LOCKED via flag_normalizer mappings)
        exit_flags = normalize_flags(raw_flags)

        # Parse destination legacy id (e.g. 3002) then convert to composite (zoneId, vnum)
        # Initialize target fields (Prisma schema uses composite toZoneId/toRoomId)
        to_zone_id: Optional[int] = None
        to_room_vnum: Optional[int] = None

        # Unify exit target keys. Legacy JSON (converted .zon → .json) currently uses
        #   { "North": { "to_room": 0, ... } }
        # Earlier importer prototype expected 'destination'. Some future tooling might
        # emit camelCase (toRoomId / toZoneId) directly. We normalize these possibilities
        # to a (to_zone_id, to_room_vnum) pair that matches the Prisma schema.
        raw_destination = (
            exit_data.get("toRoomId")
            or exit_data.get("to_room")
            or exit_data.get("destination")  # deprecated
            or exit_data.get("to")
        )
        if raw_destination in ("", "-1"):
            raw_destination = None

        # Accept explicit composite fields if present (already normalized upstream)
        explicit_to_zone = exit_data.get("toZoneId") or exit_data.get("to_zone_id")
        explicit_to_room = exit_data.get("toRoomId") or exit_data.get("to_room_id")
        if explicit_to_zone is not None and explicit_to_room is not None:
            try:
                to_zone_id = int(explicit_to_zone)
                to_room_vnum = int(explicit_to_room)
            except Exception:
                to_zone_id = None
                to_room_vnum = None
        elif raw_destination is not None:
            try:
                legacy_dest = int(raw_destination)

                # vnum_map is required for proper cross-zone exit resolution
                if not vnum_map:
                    raise ValueError("vnum_map is required for exit import - programming error")

                # Look up destination room in global vnum_map (legacy_room_id → (zone_id, id))
                if legacy_dest in vnum_map:
                    to_zone_id, to_room_vnum = vnum_map[legacy_dest]
                else:
                    # Destination room doesn't exist in our world
                    # NULL destination is valid (description-only exits or unimplemented zones)
                    to_zone_id = None
                    to_room_vnum = None
            except Exception as e:
                import sys
                print(f"[ERROR] Exception in exit import: {e}, raw_destination={raw_destination}", file=sys.stderr)
                to_zone_id = None
                to_room_vnum = None

        try:
            await self.prisma.roomexit.upsert(  # type: ignore[attr-defined]
                where={
                    "roomZoneId_roomId_direction": {
                        "roomZoneId": room_zone_id,
                        "roomId": room_id,
                        "direction": direction,
                    }
                },
                data={
                    "create": {
                        "roomZoneId": room_zone_id,
                        "roomId": room_id,
                        "direction": direction,
                        "description": exit_data.get("description", ""),
                        "keywords": [exit_data.get("keyword", "")] if exit_data.get("keyword") else [],
                        "key": exit_data.get("key"),
                        "toZoneId": to_zone_id,
                        "toRoomId": to_room_vnum,
                        "flags": exit_flags,
                        "defaultState": default_state,
                    },
                    "update": {
                        "description": exit_data.get("description", ""),
                        "keywords": [exit_data.get("keyword", "")] if exit_data.get("keyword") else [],
                        "key": exit_data.get("key"),
                        "toZoneId": to_zone_id,
                        "toRoomId": to_room_vnum,
                        "flags": {"set": exit_flags},
                        "defaultState": default_state,
                    },
                },
            )

            return {
                "success": True,
                "direction": direction,
                "toZoneId": to_zone_id,
                "toRoomId": to_room_vnum,
                "defaultState": default_state,
                "flags": exit_flags,
            }

        except Exception as e:
            return {
                "success": False,
                "direction": direction,
                "error": str(e),
            }

    async def import_extra_description(
        self, room_zone_id: int, room_vnum: int, extra: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Import extra description for a room

        Args:
            room_zone_id: Room's zone ID
            room_vnum: Room's vnum
            extra: Extra description dict with keywords and text

        Returns:
            Dict with import results
        """
        keywords = " ".join(extra.keywords) if hasattr(extra, "keywords") else ""
        text = extra.text if hasattr(extra, "text") else ""

        # Convert legacy color codes to XML-Lite markup
        text = convert_legacy_colors(text)

        try:
            await self.prisma.roomextradescriptions.create(
                data={
                    "roomZoneId": room_zone_id,
                    "roomId": room_vnum,
                    "keywords": keywords.split() if keywords else [],
                    "description": text,
                }
            )

            return {"success": True}

        except Exception as e:
            return {
                "success": False,
                "error": str(e),
            }

    async def import_rooms_from_file(
        self,
        wld_file_path: Path,
        zone_id: Optional[int] = None,
        dry_run: bool = False,
        door_reset_lookup: Optional[dict[int, dict[str, list[str]]]] = None,
        vnum_map: Optional[dict[int, tuple[int, int]]] = None,
    ) -> dict:
        """
        Import rooms from a legacy .wld file

        Automatically detects zones from room IDs and creates missing zones.

        Args:
            wld_file_path: Path to .wld file
            zone_id: Optional zone ID filter (imports only rooms from this zone)
            dry_run: If True, validate but don't write to database
            door_reset_lookup: Optional mapping {room_vnum: {direction: [flags]}} from zone resets
            vnum_map: Optional dict to populate with vnum -> (zone_id, id) for downstream linking

        Returns:
            Dict with import results including zones_created list

        Examples:
            >>> result = await importer.import_rooms_from_file(Path("lib/world/wld/30.wld"))
            >>> print(f"Imported {result['imported']} rooms from {len(result['zones_created'])} zones")
        """
        try:
            # Read file
            with open(wld_file_path, "r") as f:
                content = f.read()

            # Parse rooms
            lines = content.split("\n")
            mud_data = MudData(lines)
            rooms = World.parse(mud_data)

            # Always derive authoritative zone id from filename (ignore per-room zone math)
            try:
                file_zone_id = int(Path(wld_file_path).stem)
            except ValueError:
                return {
                    "success": False,
                    "file": str(wld_file_path),
                    "error": "Filename must be numeric (e.g. 30.wld) to derive zone id",
                }

            # If caller passed zone_id and it disagrees, we log but proceed with filename zone
            if zone_id is not None and zone_id != file_zone_id:
                print(f"[WARN] Ignoring provided zone_id={zone_id}; using filename zone_id={file_zone_id}")
            zone_id = file_zone_id

            # Ensure zone exists
            zones_created: list[int] = []
            existing_zone = await self.prisma.zones.find_unique(where={"id": zone_id})
            if not existing_zone and not dry_run:
                await self.prisma.zones.create(
                    data={
                        "id": zone_id,
                        "name": f"Zone {zone_id}",
                        "resetMode": "NORMAL",
                        "lifespan": 10,
                    }
                )
                zones_created.append(zone_id)

            results = {
                "success": True,
                "file": str(wld_file_path),
                "zones_in_file": [zone_id],
                "zones_created": zones_created,
                "total": len(rooms),
                "imported": 0,
                "failed": 0,
                "rooms": [],
                "exits_imported": 0,
                "exits_failed": 0,
            }

            # PASS 1: Import rooms without exits (avoid FK constraint issues)
            for room in rooms:
                room_id = int(room["id"])
                result = await self.import_room(
                    room,
                    zone_id,
                    dry_run=dry_run,
                    base_zone_override=zone_id,
                    skip_exits=True,  # Skip exits in first pass
                )

                # Populate vnum_map: use original legacy room_id as key for uniqueness
                if vnum_map is not None and result.get("success"):
                    vnum_map[room_id] = (zone_id, result["vnum"])  # composite parts

                # Apply door reset flags to exits if available (augment result data in dry_run)
                if door_reset_lookup and dry_run and result.get("success"):
                    door_flags = door_reset_lookup.get(result["vnum"], {})
                    if door_flags:
                        result.setdefault("doorResets", door_flags)
                results["rooms"].append(result)

                if result["success"]:
                    results["imported"] += 1
                else:
                    results["failed"] += 1
                    results["success"] = False

            # PASS 2: Import exits (now all destination rooms exist)
            if not dry_run:
                for room in rooms:
                    exit_result = await self.import_exits_for_room(
                        room,
                        zone_id,
                        base_zone_override=zone_id,
                    )
                    results["exits_imported"] += exit_result.get("exits_imported", 0)
                    results["exits_failed"] += exit_result.get("exits_failed", 0)

            return results

        except FileNotFoundError:
            return {
                "success": False,
                "file": str(wld_file_path),
                "zone_id": zone_id,
                "error": f"File not found: {wld_file_path}",
            }
        except Exception as e:
            return {
                "success": False,
                "file": str(wld_file_path),
                "zone_id": zone_id,
                "error": f"Parse error: {str(e)}",
            }
