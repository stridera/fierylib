"""
Object Importer - Imports object (item) data from legacy files to PostgreSQL

Handles:
- Objects with composite primary keys (zoneId, vnum)
- Object types, flags, wear locations
- Type-specific values (weapon stats, container capacity, etc.)
- Object affects and extra descriptions
"""

from typing import Optional
from pathlib import Path
import sys
import json

from mud.types.object import Object
from mud.mudfile import MudData
from fierylib.converters import legacy_id_to_composite, normalize_flags


class ObjectImporter:
    """Imports object data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize object importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client
        self.vnum_map = {}  # vnum -> (zone_id, id) - built during import

    async def import_object(
        self, obj: Object, zone_id: int, dry_run: bool = False
    ) -> dict:
        """
        Import a single object to the database

        Args:
            obj: Parsed Object
            zone_id: Zone ID from filename (may differ from object's actual zone)
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with import results
        """
        # Use zone ID from filename (authoritative source)
        # Calculate ID by removing zone offset from vnum (supports >100 items per zone)
        # Example: In 4.obj, #400 → (zone: 4, id: 0), #500 → (zone: 4, id: 100)
        obj_zone_id = zone_id
        vnum = obj.id - (zone_id * 100)

        # Map object type - handle legacy names with underscores
        obj_type = obj.type.upper().replace("_", "") if obj.type else "NOTHING"

        # Normalize flags (NO_RENT → NORENT)
        obj_flags = normalize_flags(obj.flags or [])
        obj_effect_flags = normalize_flags(obj.effect_flags or [])
        obj_wear_flags = normalize_flags(obj.wear_flags or [])

        # Convert values dict to JSON-serializable format (handle Dice objects)
        values_dict = {}
        if obj.values:
            for key, value in obj.values.items():
                # Check if value has dice attributes (num, size, bonus)
                if hasattr(value, 'num') and hasattr(value, 'size') and hasattr(value, 'bonus'):
                    values_dict[key] = {
                        "num": value.num,
                        "size": value.size,
                        "bonus": value.bonus
                    }
                else:
                    values_dict[key] = value

        if dry_run:
            return {
                "success": True,
                "zone_id": obj_zone_id,
                "vnum": vnum,
                "keywords": obj.keywords,
                "action": "validated",
            }

        try:
            # Build vnum map entry (for reset lookups later)
            legacy_vnum = (zone_id * 100) + vnum if zone_id != 1000 else vnum
            if self.vnum_map is not None:
                self.vnum_map[legacy_vnum] = (obj_zone_id, vnum)

            # Upsert object with composite key
            await self.prisma.objects.upsert(
                where={
                    "zoneId_id": {
                        "zoneId": obj_zone_id,
                        "id": vnum,
                    }
                },
                data={
                    "create": {
                        "id": vnum,
                        "zoneId": obj_zone_id,
                        "type": obj_type,
                        "keywords": obj.keywords if obj.keywords else [],
                        "shortDesc": obj.short or "",
                        "description": obj.ground or "",
                        "actionDesc": obj.action_desc or "",
                        "flags": obj_flags,
                        "weight": obj.weight or 0.0,
                        "cost": obj.cost or 0,
                        "timer": obj.timer or 0,
                        "level": obj.level or 0,
                        "effectFlags": obj_effect_flags,
                        "wearFlags": obj_wear_flags,
                        "concealment": obj.concealment or 0,
                        "values": json.dumps(values_dict) if values_dict else "{}",
                    },
                    "update": {
                        "type": obj_type,
                        "keywords": obj.keywords if obj.keywords else [],
                        "shortDesc": obj.short or "",
                        "description": obj.ground or "",
                        "actionDesc": obj.action_desc or "",
                        "flags": {"set": obj_flags},
                        "weight": obj.weight or 0.0,
                        "cost": obj.cost or 0,
                        "timer": obj.timer or 0,
                        "level": obj.level or 0,
                        "effectFlags": {"set": obj_effect_flags},
                        "wearFlags": {"set": obj_wear_flags},
                        "concealment": obj.concealment or 0,
                        "values": json.dumps(values_dict) if values_dict else "{}",
                    },
                },
            )

            # Import affects
            affects_imported = 0
            if obj.affects:
                for affect in obj.affects:
                    affect_result = await self.import_affect(obj_zone_id, vnum, affect)
                    if affect_result["success"]:
                        affects_imported += 1

            # Import extra descriptions
            extras_imported = 0
            if obj.extras:
                for extra in obj.extras:
                    extra_result = await self.import_extra_description(
                        obj_zone_id, vnum, extra
                    )
                    if extra_result["success"]:
                        extras_imported += 1

            return {
                "success": True,
                "zone_id": obj_zone_id,
                "vnum": vnum,
                "keywords": obj.keywords,
                "action": "imported",
                "affects": affects_imported,
                "extras": extras_imported,
            }

        except Exception as e:
            return {
                "success": False,
                "zone_id": obj_zone_id,
                "vnum": vnum,
                "keywords": obj.keywords,
                "action": "failed",
                "error": str(e),
            }

    async def import_affect(
        self, obj_zone_id: int, obj_vnum: int, affect: dict
    ) -> dict:
        """
        Import an object affect (stat modifier)

        Args:
            obj_zone_id: Object's zone ID
            obj_vnum: Object's vnum
            affect: Affect dict with location and modifier

        Returns:
            Dict with import results
        """
        try:
            await self.prisma.objectaffect.create(
                data={
                    "objectZoneId": obj_zone_id,
                    "objectId": obj_vnum,
                    "location": affect.get("location", ""),
                    "modifier": affect.get("modifier", 0),
                }
            )

            return {"success": True}

        except Exception as e:
            return {
                "success": False,
                "error": str(e),
            }

    async def import_extra_description(
        self, obj_zone_id: int, obj_vnum: int, extra: dict
    ) -> dict:
        """
        Import extra description for an object

        Args:
            obj_zone_id: Object's zone ID
            obj_vnum: Object's vnum
            extra: Extra description dict with keywords and text

        Returns:
            Dict with import results
        """
        keywords = " ".join(extra.keywords) if hasattr(extra, "keywords") else ""
        text = extra.text if hasattr(extra, "text") else ""

        try:
            await self.prisma.objectextradescription.create(
                data={
                    "objectZoneId": obj_zone_id,
                    "objectId": obj_vnum,
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

    async def import_objects_from_file(
        self, obj_file_path: Path, zone_id: int, dry_run: bool = False,
        vnum_map: dict = None
    ) -> dict:
        """
        Import objects from a legacy .obj file

        Args:
            obj_file_path: Path to .obj file
            zone_id: Zone ID (already converted)
            dry_run: If True, validate but don't write to database
            vnum_map: Optional dict to populate with vnum -> (zone_id, id) mappings during import

        Returns:
            Dict with import results
        """
        # Store parameter for use during import
        if vnum_map is not None:
            self.vnum_map = vnum_map

        try:
            # Read file
            with open(obj_file_path, "r") as f:
                content = f.read()

            # Parse objects
            lines = content.split("\n")
            mud_data = MudData(lines)
            objects = Object.parse(mud_data)

            results = {
                "success": True,
                "file": str(obj_file_path),
                "zone_id": zone_id,
                "total": len(objects),
                "imported": 0,
                "failed": 0,
                "objects": [],
            }
            
            # Handle empty object files (no objects to import is not an error)
            if len(objects) == 0:
                return results

            for obj in objects:
                result = await self.import_object(obj, zone_id, dry_run=dry_run)
                results["objects"].append(result)

                if result["success"]:
                    results["imported"] += 1
                else:
                    results["failed"] += 1
                    results["success"] = False

            return results

        except FileNotFoundError:
            return {
                "success": False,
                "file": str(obj_file_path),
                "zone_id": zone_id,
                "error": f"File not found: {obj_file_path}",
            }
        except Exception as e:
            return {
                "success": False,
                "file": str(obj_file_path),
                "zone_id": zone_id,
                "error": f"Parse error: {str(e)}",
            }
