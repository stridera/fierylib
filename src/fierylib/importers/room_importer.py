"""
Room Importer - Imports room data from legacy files to PostgreSQL

Handles:
- Rooms with composite primary keys (zoneId, vnum)
- Room exits with directional connections
- Room sectors (terrain types)
- Room flags
- Extra descriptions
"""

from typing import Optional
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

    async def import_room(self, room: dict, zone_id: int, dry_run: bool = False) -> dict:
        """
        Import a single room to the database

        Args:
            room: Parsed room dict from World.parse()
            zone_id: Zone ID from filename (may differ from room's actual zone)
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with import results

        Examples:
            >>> room = {"id": "3045", "name": "Test Room", ...}
            >>> result = await importer.import_room(room, 30)
            >>> print(result["vnum"])
            45
        """
        # Use zone ID from filename (authoritative source)
        # Calculate ID by removing zone offset from vnum (supports >100 items per zone)
        # Example: In 117.wld, #11700 → (zone: 117, id: 0), #11800 → (zone: 117, id: 100)
        room_zone_id = zone_id
        vnum = int(room["id"]) - (zone_id * 100)

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
                "zone_id": room_zone_id,
                "vnum": vnum,
                "name": room["name"],
                "action": "validated",
                "data": {
                    "zoneId": room_zone_id,
                    "id": vnum,
                    "name": room["name"],
                    "description": room["description"],
                    "sector": sector,
                    "flags": flags,
                },
            }

        try:
            # Upsert room with composite key
            room_record = await self.prisma.room.upsert(
                where={
                    "zoneId_id": {
                        "zoneId": room_zone_id,
                        "id": vnum,
                    }
                },
                data={
                    "create": {
                        "zoneId": room_zone_id,
                        "id": vnum,
                        "name": room["name"],
                        "description": room["description"],
                        "sector": sector,
                        "flags": flags,
                    },
                    "update": {
                        "name": room["name"],
                        "description": room["description"],
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
                        room_zone_id, vnum, direction_str, exit_data
                    )
                    if exit_result["success"]:
                        exits_imported += 1

            # Import extra descriptions
            extras_imported = 0
            if room.get("extras"):
                for extra in room["extras"]:
                    extra_result = await self.import_extra_description(
                        room_zone_id, vnum, extra
                    )
                    if extra_result["success"]:
                        extras_imported += 1

            return {
                "success": True,
                "zone_id": room_zone_id,
                "vnum": vnum,
                "name": room["name"],
                "action": "imported",
                "exits": exits_imported,
                "extras": extras_imported,
            }

        except Exception as e:
            return {
                "success": False,
                "zone_id": room_zone_id,
                "vnum": vnum,
                "name": room.get("name", "unknown"),
                "action": "failed",
                "error": str(e),
            }

    async def import_exit(
        self, room_zone_id: int, room_vnum: int, direction_str: str, exit_data: dict
    ) -> dict:
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

        # Parse destination room ID if it exists and split into zone/vnum
        to_zone_id = None
        to_room_vnum = None
        if exit_data.get("destination") and exit_data["destination"] != "-1":
            try:
                legacy_id = int(exit_data["destination"])
                to_zone_id = legacy_id // 100
                to_room_vnum = legacy_id % 100
            except (ValueError, TypeError):
                pass

        try:
            await self.prisma.roomexit.upsert(
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
                        "toZoneId": to_zone_id,
                        "toRoomId": to_room_vnum,
                    },
                    "update": {
                        "description": exit_data.get("description", ""),
                        "keywords": [exit_data.get("keyword", "")] if exit_data.get("keyword") else [],
                        "toZoneId": to_zone_id,
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
        self, room_zone_id: int, room_vnum: int, extra: dict
    ) -> dict:
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
            await self.prisma.roomextradescription.create(
                data={
                    "roomZoneId": room_zone_id,
                    "roomId": room_vnum,
                    "keyword": keywords,
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
        self, wld_file_path: Path, zone_id: int = None, dry_run: bool = False
    ) -> dict:
        """
        Import rooms from a legacy .wld file

        Automatically detects zones from room IDs and creates missing zones.

        Args:
            wld_file_path: Path to .wld file
            zone_id: Optional zone ID filter (imports only rooms from this zone)
            dry_run: If True, validate but don't write to database

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

            # If zone_id provided, use it for ALL rooms (filename-based assignment)
            # Otherwise, detect zones from room IDs using legacy arithmetic
            if zone_id is not None:
                zones_in_file = {zone_id}
            else:
                zones_in_file = set()
                for room in rooms:
                    room_id = int(room["id"])
                    room_zone_id = room_id // 100
                    zones_in_file.add(room_zone_id)

            # Ensure all zones exist in database
            zones_created = []
            for detected_zone_id in sorted(zones_in_file):
                # Check if zone exists
                existing_zone = await self.prisma.zone.find_unique(where={"id": detected_zone_id})
                if not existing_zone and not dry_run:
                    # Create zone with default name
                    await self.prisma.zone.create(
                        data={
                            "id": detected_zone_id,
                            "name": f"Zone {detected_zone_id}",
                            "resetMode": "NORMAL",
                            "lifespan": 10,
                        }
                    )
                    zones_created.append(detected_zone_id)

            results = {
                "success": True,
                "file": str(wld_file_path),
                "zones_in_file": sorted(zones_in_file),
                "zones_created": zones_created,
                "total": len(rooms),
                "imported": 0,
                "failed": 0,
                "rooms": [],
            }

            for room in rooms:
                # Use provided zone_id (filename-based) if available,
                # otherwise extract zone ID from room ID (legacy arithmetic)
                if zone_id is not None:
                    room_zone_id = zone_id
                else:
                    room_id = int(room["id"])
                    room_zone_id = room_id // 100

                result = await self.import_room(room, room_zone_id, dry_run=dry_run)
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
