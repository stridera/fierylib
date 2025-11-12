"""
Room Importer - Imports room data from legacy files to PostgreSQL

Handles:
- Rooms with composite primary keys (zoneId, vnum)
- Room exits with directional connections
- Room sectors (terrain types)
- Room flags
- Extra descriptions
"""

from typing import Optional, Any, Dict
from pathlib import Path
import sys

from mud.types.world import World
from mud.mudfile import MudData
from mud.bitflags import BitFlags
from fierylib.converters import legacy_id_to_composite, normalize_flags


class RoomImporter:
    """Imports room data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
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
    ) -> Dict[str, Any]:
        """
        Import a single room to the database

        Args:
            room: Parsed room dict from World.parse()
            zone_id: Zone ID (already converted, e.g., 30 or 1000)
            dry_run: If True, validate but don't write to database

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

        # Map sector and flags
        sector = self.map_sector(room["sector"])
        flags = room.get("flags", [])

        # Convert BitFlags to list if needed
        if isinstance(flags, BitFlags):
            flags = flags.json_repr()

        # Normalize flag names (NO_MOB → NOMOB)
        flags = normalize_flags(flags)

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
                    "flags": flags,
                },
            }

        try:
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
                        "name": room["name"],
                        "roomDescription": room["description"],
                        "sector": sector,
                        "flags": flags,
                    },
                    "update": {
                        "name": room["name"],
                        "roomDescription": room["description"],
                        "sector": sector,
                        "flags": {"set": flags},
                    },
                },
            )

            # Import exits
            exits_imported = 0
            if room.get("exits"):
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

    async def import_exit(
        self, room_zone_id: int, room_vnum: int, direction_str: str, exit_data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Import a room exit

        Args:
            room_zone_id: Source room's zone ID
            room_vnum: Source room's vnum
            direction_str: Direction name (e.g., "NORTH")
            exit_data: Exit data dict

        Returns:
            Dict with import results
        """
        direction = self.map_direction(direction_str)
        if not direction:
            return {
                "success": False,
                "error": f"Invalid direction: {direction_str}",
            }

        # Parse destination room ID if it exists
        to_room_vnum = None
        if exit_data.get("destination") and exit_data["destination"] != "-1":
            try:
                to_room_vnum = int(exit_data["destination"])
            except (ValueError, TypeError):
                pass

        try:
            await self.prisma.roomexits.upsert(
                where={
                    "roomZoneId_roomId_direction": {
                        "roomZoneId": room_zone_id,
                        "roomId": room_vnum,
                        "direction": direction,
                    }
                },
                data={
                    "create": {
                        "roomZoneId": room_zone_id,
                        "roomId": room_vnum,
                        "direction": direction,
                        "description": exit_data.get("description", ""),
                        "keywords": [exit_data.get("keyword", "")] if exit_data.get("keyword") else [],
                        "toRoomId": to_room_vnum,
                    },
                    "update": {
                        "description": exit_data.get("description", ""),
                        "keywords": [exit_data.get("keyword", "")] if exit_data.get("keyword") else [],
                        "toRoomId": to_room_vnum,
                    },
                },
            )

            return {"success": True, "direction": direction}

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
            }

            for room in rooms:
                room_id = int(room["id"])
                result = await self.import_room(
                    room,
                    zone_id,
                    dry_run=dry_run,
                    base_zone_override=zone_id,
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
