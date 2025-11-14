"""
Zone Importer - Imports zone data from legacy files to PostgreSQL

Handles:
- Zone metadata (name, lifespan, reset mode)
- Climate and hemisphere data
- Zone 0 → Zone 1000 conversion
- Upsert (create or update) operations
"""

from typing import Optional
from prisma import Prisma
from pathlib import Path
import sys

from mud.types.zone import Zone
from mud.mudfile import MudData
from fierylib.converters import convert_zone_id, vnum_to_composite


class ZoneImporter:
    """Imports zone data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client: "Prisma", room_map: Optional[dict] = None):
        """
        Initialize zone importer

        Args:
            prisma_client: Prisma client instance (from prisma import Prisma)
            room_map: Optional dictionary mapping vnum → (zoneId, id) for room lookups
        """
        self.prisma = prisma_client
        self.room_map = room_map or {}

    @staticmethod
    def map_reset_mode(mode) -> str:
        """
        Map legacy reset mode string to Prisma ResetMode enum string

        Args:
            mode: Legacy reset mode string value

        Returns:
            Prisma enum string ("NEVER", "EMPTY", "NORMAL")

        Examples:
            >>> ZoneImporter.map_reset_mode('NEVER')
            'NEVER'
            >>> ZoneImporter.map_reset_mode('NORMAL')
            'NORMAL'
        """
        # Accept either enum (with .value) or string-like; normalize to uppercase string
        try:
            value = mode.value  # Enum with uppercase value
        except AttributeError:
            value = str(mode)
        return value.upper()

    @staticmethod
    def map_hemisphere(hemisphere) -> str:
        """
        Map legacy hemisphere string to Prisma Hemisphere enum string

        Args:
            hemisphere: Legacy hemisphere string value

        Returns:
            Prisma enum string ("NORTHWEST", "NORTHEAST", etc.)

        Examples:
            >>> ZoneImporter.map_hemisphere('NORTHWEST')
            'NORTHWEST'
        """
        try:
            value = hemisphere.value
        except AttributeError:
            value = str(hemisphere)
        return value.upper()

    @staticmethod
    def map_climate(climate) -> str:
        """
        Map legacy climate string to Prisma Climate enum string

        Args:
            climate: Legacy climate string value

        Returns:
            Prisma enum string ("NONE", "SEMIARID", "TROPICAL", etc.)

        Examples:
            >>> ZoneImporter.map_climate('TROPICAL')
            'TROPICAL'
        """
        try:
            value = climate.value
        except AttributeError:
            value = str(climate)
        return value.upper()

    async def import_zone(self, zone: Zone, dry_run: bool = False, skip_door_resets: bool = False) -> dict:
        """
        Import a single zone to the database

        Args:
            zone: Parsed Zone object from legacy file
            dry_run: If True, validate but don't write to database
            skip_door_resets: If True, skip applying door resets (for first pass)

        Returns:
            Dict with import results:
            {
                "success": bool,
                "zone_id": int,
                "zone_name": str,
                "action": "created" | "updated" | "skipped"
            }

        Examples:
            >>> zone = Zone(id=30, name="Test Zone", ...)
            >>> result = await importer.import_zone(zone)
            >>> print(result["action"])
            'created'
        """
        # Convert zone ID (handles zone 0 → 1000)
        zone_id = convert_zone_id(zone.id)

        # Map enums to Prisma format
        reset_mode = self.map_reset_mode(zone.reset_mode)
        hemisphere = self.map_hemisphere(zone.hemisphere)
        climate = self.map_climate(zone.climate)

        if dry_run:
            return {
                "success": True,
                "zone_id": zone_id,
                "zone_name": zone.name,
                "action": "validated",
                "data": {
                    "id": zone_id,
                    "name": zone.name,
                    "lifespan": zone.lifespan,
                    "resetMode": reset_mode,
                    "hemisphere": hemisphere,
                    "climate": climate,
                },
            }

        # Upsert zone (create or update)
        try:
            zone_record = await self.prisma.zones.upsert(
                where={"id": zone_id},
                data={
                    "create": {
                        "id": zone_id,
                        "name": zone.name,
                        "lifespan": zone.lifespan,
                        "resetMode": reset_mode,
                        "hemisphere": hemisphere,
                        "climate": climate,
                    },
                    "update": {
                        "name": zone.name,
                        "lifespan": zone.lifespan,
                        "resetMode": reset_mode,
                        "hemisphere": hemisphere,
                        "climate": climate,
                    },
                },
            )

            # Determine if created or updated
            # Prisma doesn't return this info directly, so we assume update for existing zones
            action = "updated" if zone_record else "created"

            result = {
                "success": True,
                "zone_id": zone_id,
                "zone_name": zone.name,
                "action": action,
            }

            # Apply door states from zone resets (only if not skipped)
            # Door resets are typically applied in a second pass after all rooms are imported
            if not skip_door_resets:
                try:
                    door_apply, door_warnings = await self.apply_door_resets(zone, dry_run=dry_run)
                    if dry_run:
                        result["doorResets"] = door_apply
                    if door_warnings:
                        result["doorWarnings"] = door_warnings
                except Exception as e:
                    # Don't fail zone import due to door application; report in result
                    result["doorResetError"] = str(e)

            return result

        except Exception as e:
            return {
                "success": False,
                "zone_id": zone_id,
                "zone_name": zone.name,
                "action": "failed",
                "error": str(e),
            }

    async def apply_door_resets(self, zone: Zone, dry_run: bool = False):
        """
        Apply door states from zone.resets to RoomExit.flags.
        Does not infer; only uses 'D' commands parsed in Zone.parse().
        """
        resets = getattr(zone, "resets", None)
        if not resets:
            return [], []
        # resets may be a dict-like with key 'door'
        door_list = None
        if isinstance(resets, dict):
            door_list = resets.get("door")
        if not door_list:
            return [], []

        summary: list[dict] = []
        warnings: list[str] = []
        for door in door_list:
            # door = {room: int, direction: 'NORTH'..., state: [strings or lists?]}
            room_legacy_vnum = int(door.get("room"))

            # Look up room in vnum map (must exist - all rooms are imported before door resets)
            if not self.room_map:
                warnings.append(
                    f"Door reset failed: room_map not initialized (vnum={room_legacy_vnum})"
                )
                continue
            
            if room_legacy_vnum not in self.room_map:
                # Debug: show what vnums ARE in the map near this one
                nearby_vnums = [v for v in self.room_map.keys() if abs(v - room_legacy_vnum) < 10]
                warnings.append(
                    f"Door reset references non-existent room: vnum={room_legacy_vnum} (nearby vnums in map: {sorted(nearby_vnums)[:5]})"
                )
                continue

            room_zone_id, room_vnum = self.room_map[room_legacy_vnum]
            direction = str(door.get("direction"))
            state = door.get("state")

            # state may be a list of strings or a nested list if multiple continued D commands
            flattened: list[str] = []
            if isinstance(state, list):
                for s in state:
                    if isinstance(s, list):
                        flattened.extend(s)
                    else:
                        flattened.append(s)

            # Build ExitFlag[]: always IS_DOOR, plus CLOSED/LOCKED/HIDDEN if present
            flags: list[str] = ["IS_DOOR"]
            flat_upper = {str(x).upper() for x in flattened}
            if "CLOSED" in flat_upper:
                flags.append("CLOSED")
            if "LOCKED" in flat_upper:
                flags.append("LOCKED")
            if "HIDDEN" in flat_upper:
                flags.append("HIDDEN")

            summary.append({
                "roomZoneId": room_zone_id,
                "roomId": room_vnum,
                "direction": direction,
                "flags": flags,
            })

            if dry_run:
                continue

            # Try to find the exit first; warn if missing
            try:
                existing = await self.prisma.roomexit.find_unique(  # type: ignore[attr-defined]
                    where={
                        "roomZoneId_roomId_direction": {
                            "roomZoneId": room_zone_id,
                            "roomId": room_vnum,
                            "direction": direction,
                        }
                    }
                )
                if not existing:
                    warnings.append(
                        f"Door reset points to missing exit: zone={room_zone_id} room={room_vnum} dir={direction}"
                    )
                    continue

                await self.prisma.roomexit.update(  # type: ignore[attr-defined]
                    where={
                        "roomZoneId_roomId_direction": {
                            "roomZoneId": room_zone_id,
                            "roomId": room_vnum,
                            "direction": direction,
                        }
                    },
                    data={
                        "flags": {"set": flags},
                    },
                )
            except Exception as e:
                warnings.append(
                    f"Failed applying door reset for zone={room_zone_id} room={room_vnum} dir={direction}: {e}"
                )

        return summary, warnings

    async def import_zone_from_file(
        self, zone_file_path: Path, dry_run: bool = False, skip_door_resets: bool = False
    ) -> dict:
        """
        Import a zone from a legacy .zon file

        Args:
            zone_file_path: Path to .zon file
            dry_run: If True, validate but don't write to database
            skip_door_resets: If True, skip applying door resets (for first pass)

        Returns:
            Dict with import results

        Examples:
            >>> result = await importer.import_zone_from_file(Path("lib/world/zon/30.zon"))
            >>> print(f"Imported zone {result['zone_name']}")
            'Imported zone Test Zone'
        """
        try:
            # Read file
            with open(zone_file_path, "r") as f:
                content = f.read()

            # Parse zone file
            lines = content.split("\n")
            mud_data = MudData(lines)
            zone = Zone.parse(mud_data)

            # Import zone
            result = await self.import_zone(zone, dry_run=dry_run, skip_door_resets=skip_door_resets)
            result["file"] = str(zone_file_path)

            return result

        except FileNotFoundError:
            return {
                "success": False,
                "file": str(zone_file_path),
                "action": "failed",
                "error": f"File not found: {zone_file_path}",
            }
        except Exception as e:
            return {
                "success": False,
                "file": str(zone_file_path),
                "action": "failed",
                "error": f"Parse error: {str(e)}",
            }

    async def import_all_zones(
        self, world_dir: Path, dry_run: bool = False
    ) -> dict:
        """
        Import all zones from a world directory

        Args:
            world_dir: Path to world directory (e.g., lib/world/zon/)
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with summary:
            {
                "success": bool,
                "total": int,
                "imported": int,
                "failed": int,
                "zones": [...]
            }

        Examples:
            >>> result = await importer.import_all_zones(Path("lib/world/zon/"))
            >>> print(f"Imported {result['imported']} of {result['total']} zones")
        """
        zon_dir = world_dir / "zon" if (world_dir / "zon").exists() else world_dir
        zone_files = sorted(zon_dir.glob("*.zon"))

        results = {
            "success": True,
            "total": len(zone_files),
            "imported": 0,
            "failed": 0,
            "zones": [],
        }

        for zone_file in zone_files:
            result = await self.import_zone_from_file(zone_file, dry_run=dry_run)
            results["zones"].append(result)

            if result["success"]:
                results["imported"] += 1
            else:
                results["failed"] += 1
                results["success"] = False

        return results
