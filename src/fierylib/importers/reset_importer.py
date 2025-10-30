"""
Reset Importer - Imports mob and object resets from legacy files to PostgreSQL

Handles:
- Mob resets (M commands) with equipment (E) and inventory (G)
- Object resets (O commands) with nested containers (P)
- Reset behavior detection (PERSISTENT vs RESPAWN based on R commands)
- Composite primary keys (zoneId, id)
- Nested object hierarchies
- Entity lookup via prebuilt vnum maps for performance
"""

from typing import Optional, Tuple, Dict
from fierylib.converters import convert_zone_id, vnum_to_composite


class ResetImporter:
    """Imports reset data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize reset importer

        Args:
            prisma_client: Prisma client instance (from prisma import Prisma)
        """
        self.prisma = prisma_client
        # Vnum to (zone_id, id) maps - built once, reused for all resets
        self.mob_map: Dict[int, Tuple[int, int]] = {}
        self.room_map: Dict[int, Tuple[int, int]] = {}
        self.object_map: Dict[int, Tuple[int, int]] = {}
        self.maps_built = False

    def set_vnum_maps(self, room_map: Dict[int, Tuple[int, int]],
                      mob_map: Dict[int, Tuple[int, int]],
                      object_map: Dict[int, Tuple[int, int]]):
        """
        Set prebuilt vnum maps (built incrementally during entity import)

        Args:
            room_map: vnum -> (zone_id, id) for rooms
            mob_map: vnum -> (zone_id, id) for mobs
            object_map: vnum -> (zone_id, id) for objects
        """
        self.room_map = room_map
        self.mob_map = mob_map
        self.object_map = object_map
        self.maps_built = True

    async def build_vnum_maps(self):
        """
        Build vnum → (zone_id, id) maps for all entities in the database

        This is called once before importing resets and dramatically speeds up
        reset imports by avoiding thousands of individual database lookups.

        The maps are used to resolve legacy vnums (e.g., #7475) to composite IDs
        (e.g., zone 73, id 175) without needing to calculate or search for them.
        """
        if self.maps_built:
            return

        # Build mob map: vnum → (zoneId, id)
        mobs = await self.prisma.mob.find_many()
        for mob in mobs:
            # Calculate legacy vnum from zone/id
            vnum = (mob.zoneId * 100) + mob.id if mob.zoneId != 1000 else mob.id
            self.mob_map[vnum] = (mob.zoneId, mob.id)

        # Build room map: vnum → (zoneId, id)
        rooms = await self.prisma.room.find_many()
        for room in rooms:
            vnum = (room.zoneId * 100) + room.id if room.zoneId != 1000 else room.id
            self.room_map[vnum] = (room.zoneId, room.id)

        # Build object map: vnum → (zoneId, id)
        objects = await self.prisma.object.find_many()
        for obj in objects:
            vnum = (obj.zoneId * 100) + obj.id if obj.zoneId != 1000 else obj.id
            self.object_map[vnum] = (obj.zoneId, obj.id)

        self.maps_built = True
        print(f"📋 Built vnum maps: {len(self.mob_map)} mobs, {len(self.room_map)} rooms, {len(self.object_map)} objects")

    def find_mob_zone(self, mob_vnum: int) -> Optional[Tuple[int, int]]:
        """
        Find which zone a mob belongs to using the prebuilt vnum map

        Args:
            mob_vnum: Legacy mob vnum (e.g., 7475)

        Returns:
            Tuple of (zone_id, id) if found, None otherwise

        Examples:
            >>> find_mob_zone(7475)
            (73, 175)  # Found in zone 73 with id 175
        """
        return self.mob_map.get(mob_vnum)

    def find_room_zone(self, room_vnum: int) -> Optional[Tuple[int, int]]:
        """
        Find which zone a room belongs to using the prebuilt vnum map

        Args:
            room_vnum: Legacy room vnum (e.g., 7475)

        Returns:
            Tuple of (zone_id, id) if found, None otherwise
        """
        return self.room_map.get(room_vnum)

    def find_object_zone(self, obj_vnum: int) -> Optional[Tuple[int, int]]:
        """
        Find which zone an object belongs to using the prebuilt vnum map

        Args:
            obj_vnum: Legacy object vnum (e.g., 586)

        Returns:
            Tuple of (zone_id, id) if found, None otherwise
        """
        return self.object_map.get(obj_vnum)

    async def import_mob_reset(
        self, mob_reset: dict, zone_id: int, dry_run: bool = False
    ) -> dict:
        """
        Import a single mob reset with equipment

        Args:
            mob_reset: Parsed mob reset from zone.resets["mob"]
                {
                    "id": 3000,          # Mob vnum (legacy global ID)
                    "max": 1,            # max_instances
                    "room": 3001,        # Room vnum (legacy global ID)
                    "name": "...",       # Comment
                    "equipped": [...],   # E commands
                    "carrying": [...]    # G commands
                }
            zone_id: Zone ID this reset belongs to
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with import results
        """
        # Look up actual zone/id for mob and room using vnum maps
        mob_vnum = mob_reset["id"]
        room_vnum = mob_reset["room"]

        mob_lookup = self.find_mob_zone(mob_vnum)
        if not mob_lookup:
            return {
                "success": False,
                "type": "mob",
                "mob_id": f"?:{mob_vnum}",
                "room_id": "?:?",
                "error": f"Mob #{mob_vnum} not found in database (check mob import errors)",
            }

        room_lookup = self.find_room_zone(room_vnum)
        if not room_lookup:
            return {
                "success": False,
                "type": "mob",
                "mob_id": f"{mob_lookup[0]}:{mob_lookup[1]}",
                "room_id": f"?:{room_vnum}",
                "error": f"Room #{room_vnum} not found in database",
            }

        db_mob_zone_id, mob_id = mob_lookup
        db_room_zone_id, room_id = room_lookup
        db_zone_id = convert_zone_id(zone_id)

        if dry_run:
            return {
                "success": True,
                "type": "mob",
                "mob_id": f"{db_mob_zone_id}:{mob_id}",
                "room_id": f"{db_room_zone_id}:{room_id}",
                "equipped_count": len(mob_reset.get("equipped", [])),
                "carrying_count": len(mob_reset.get("carrying", [])),
            }

        try:
            # Create mob reset
            reset_record = await self.prisma.mobreset.create(
                {
                    "zoneId": db_zone_id,
                    "mobZoneId": db_mob_zone_id,
                    "mobId": mob_id,
                    "roomZoneId": db_room_zone_id,
                    "roomId": room_id,
                    "maxInstances": mob_reset["max"] if mob_reset["max"] > 0 else 999,
                    "probability": 1.0,  # M commands are always 100%
                    "resetBehavior": "PERSISTENT",  # Default behavior
                    "comment": mob_reset.get("name"),
                }
            )

            # Import equipped items (E commands)
            equipment_count = 0
            equipment_errors = []

            for equipped in mob_reset.get("equipped", []):
                obj_vnum = equipped["id"]

                # Look up actual object zone/id using vnum map
                obj_lookup = self.find_object_zone(obj_vnum)
                if not obj_lookup:
                    equipment_errors.append(f"vnum {obj_vnum}")
                    continue

                db_obj_zone_id, obj_id = obj_lookup

                # Convert WearFlag enum to string
                wear_location = equipped.get("location")
                if wear_location is not None:
                    if hasattr(wear_location, 'name'):
                        # Valid enum, use name
                        wear_location = wear_location.name
                    else:
                        # Invalid location (e.g., position 22 which doesn't exist)
                        # Set to None - equipment will be added to inventory instead
                        wear_location = None

                try:
                    await self.prisma.mobresetequipment.create(
                        {
                            "resetId": reset_record.id,
                            "objectZoneId": db_obj_zone_id,
                            "objectId": obj_id,
                            "wearLocation": wear_location,
                            "maxInstances": 1,
                            "probability": equipped["max"] / 100.0,  # Convert percentage
                        }
                    )
                    equipment_count += 1
                except Exception as e:
                    equipment_errors.append(f"vnum {obj_vnum} (db error: {str(e)[:50]})")

            # Import carried items (G commands) - treated as equipment without location
            for carried in mob_reset.get("carrying", []):
                obj_vnum = carried["id"]

                # Look up actual object zone/id using vnum map
                obj_lookup = self.find_object_zone(obj_vnum)
                if not obj_lookup:
                    equipment_errors.append(f"vnum {obj_vnum}")
                    continue

                db_obj_zone_id, obj_id = obj_lookup

                try:
                    await self.prisma.mobresetequipment.create(
                        {
                            "resetId": reset_record.id,
                            "objectZoneId": db_obj_zone_id,
                            "objectId": obj_id,
                            "wearLocation": None,  # G commands have no wear location
                            "maxInstances": 1,
                            "probability": carried["max"] / 100.0,
                        }
                    )
                    equipment_count += 1
                except Exception as e:
                    equipment_errors.append(f"vnum {obj_vnum} (db error: {str(e)[:50]})")

            # If any equipment failed, report the error
            if equipment_errors:
                return {
                    "success": False,
                    "type": "mob",
                    "mob_id": f"{db_mob_zone_id}:{mob_id}",
                    "room_id": f"{db_room_zone_id}:{room_id}",
                    "error": f"Equipment objects not found: {', '.join(equipment_errors)} (check object import errors)",
                }

            return {
                "success": True,
                "type": "mob",
                "reset_id": reset_record.id,
                "mob_id": f"{db_mob_zone_id}:{mob_id}",
                "room_id": f"{db_room_zone_id}:{room_id}",
                "equipment_count": equipment_count,
            }

        except Exception as e:
            error_msg = str(e)
            # Note: FK errors should not happen anymore since we lookup entities first

            return {
                "success": False,
                "type": "mob",
                "mob_id": f"{db_mob_zone_id}:{mob_id}",
                "room_id": f"{db_room_zone_id}:{room_id}",
                "error": error_msg,
            }

    async def import_object_reset(
        self,
        obj_reset: dict,
        zone_id: int,
        parent_reset_id: Optional[str] = None,
        dry_run: bool = False,
    ) -> dict:
        """
        Import a single object reset with nested containers (recursive)

        Args:
            obj_reset: Parsed object reset from zone.resets["object"]
                {
                    "id": 3297,          # Object vnum (legacy global ID)
                    "max": 1,            # max_instances or probability %
                    "room": 3203,        # Room vnum (only for top-level)
                    "name": "...",       # Comment
                    "contains": [...]    # P commands (nested objects)
                }
            zone_id: Zone ID this reset belongs to
            parent_reset_id: Parent ObjectReset ID (for nested P commands)
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with import results
        """
        # Look up actual object zone/id using vnum map
        obj_vnum = obj_reset["id"]
        obj_lookup = self.find_object_zone(obj_vnum)
        if not obj_lookup:
            return {
                "success": False,
                "type": "object",
                "object_id": f"?:{obj_vnum}",
                "error": f"Object #{obj_vnum} not found in database (check object import errors)",
            }

        db_obj_zone_id, obj_id = obj_lookup

        # Determine spawn location
        db_room_zone_id = None
        room_id = None
        if "room" in obj_reset and parent_reset_id is None:
            room_vnum = obj_reset["room"]
            room_lookup = self.find_room_zone(room_vnum)
            if not room_lookup:
                return {
                    "success": False,
                    "type": "object",
                    "object_id": f"{db_obj_zone_id}:{obj_id}",
                    "error": f"Room #{room_vnum} not found in database",
                }
            db_room_zone_id, room_id = room_lookup

        db_zone_id = convert_zone_id(zone_id)

        if dry_run:
            result = {
                "success": True,
                "type": "object",
                "object_id": f"{db_obj_zone_id}:{obj_id}",
                "location": f"room {db_room_zone_id}:{room_id}"
                if parent_reset_id is None
                else f"container {parent_reset_id}",
                "contains_count": len(obj_reset.get("contains", [])),
            }
            # Recursively validate nested objects
            for nested_obj in obj_reset.get("contains", []):
                await self.import_object_reset(
                    nested_obj, zone_id, "dry-run-parent", dry_run=True
                )
            return result

        try:
            # Determine reset behavior and spawn parameters
            if parent_reset_id is None:
                # Top-level object (O command)
                max_instances = obj_reset["max"] if obj_reset["max"] > 0 else 999
                probability = 1.0
            else:
                # Nested object (P command) - max is probability percentage
                max_instances = 1
                probability = obj_reset["max"] / 100.0

            # Create object reset
            reset_record = await self.prisma.objectreset.create(
                {
                    "zoneId": db_zone_id,
                    "objectZoneId": db_obj_zone_id,
                    "objectId": obj_id,
                    "roomZoneId": db_room_zone_id,
                    "roomId": room_id,
                    "containerResetId": parent_reset_id,
                    "maxInstances": max_instances,
                    "probability": probability,
                    "resetBehavior": "PERSISTENT",  # Default, can be updated later
                    "comment": obj_reset.get("name"),
                }
            )

            # Recursively import nested contents (P commands)
            nested_count = 0
            for nested_obj in obj_reset.get("contains", []):
                nested_result = await self.import_object_reset(
                    nested_obj, zone_id, parent_reset_id=reset_record.id, dry_run=False
                )
                if nested_result["success"]:
                    nested_count += 1

            return {
                "success": True,
                "type": "object",
                "reset_id": reset_record.id,
                "object_id": f"{db_obj_zone_id}:{obj_id}",
                "nested_count": nested_count,
            }

        except Exception as e:
            error_msg = str(e)
            # Note: FK errors should not happen anymore since we lookup entities first

            return {
                "success": False,
                "type": "object",
                "object_id": f"{db_obj_zone_id}:{obj_id}",
                "error": error_msg,
            }

    async def detect_respawn_behavior(self, zone, obj_reset: dict) -> str:
        """
        Detect if an object should use RESPAWN behavior based on R commands

        Args:
            zone: Parsed Zone object with resets
            obj_reset: Object reset dict

        Returns:
            "RESPAWN" if matching R command found, "PERSISTENT" otherwise
        """
        # Check if there's a matching R command for this object/room
        remove_list = zone.resets.get("remove", [])
        obj_id = obj_reset["id"]
        room_id = obj_reset.get("room")

        for remove in remove_list:
            if remove["id"] == obj_id and remove["room"] == room_id:
                return "RESPAWN"

        return "PERSISTENT"

    async def import_resets_from_zone(
        self, zone, dry_run: bool = False
    ) -> dict:
        """
        Import all resets from a parsed zone

        Args:
            zone: Parsed Zone object from Zone.parse()
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with summary:
            {
                "success": bool,
                "mob_resets": int,
                "object_resets": int,
                "failed": int
            }
        """
        results = {
            "success": True,
            "mob_resets": 0,
            "object_resets": 0,
            "failed": 0,
            "errors": [],
        }

        # Import mob resets
        for mob_reset in zone.resets.get("mob", []):
            result = await self.import_mob_reset(mob_reset, zone.id, dry_run=dry_run)
            if result["success"]:
                results["mob_resets"] += 1
            else:
                results["failed"] += 1
                results["errors"].append(result)

        # Import object resets (with nested containers)
        for obj_reset in zone.resets.get("object", []):
            # Detect reset behavior
            reset_behavior = await self.detect_respawn_behavior(zone, obj_reset)

            result = await self.import_object_reset(
                obj_reset, zone.id, parent_reset_id=None, dry_run=dry_run
            )

            if result["success"]:
                results["object_resets"] += 1

                # Update reset behavior if RESPAWN detected
                if not dry_run and reset_behavior == "RESPAWN":
                    await self.prisma.objectreset.update(
                        where={"id": result["reset_id"]},
                        data={"resetBehavior": "RESPAWN"},
                    )
            else:
                results["failed"] += 1
                results["errors"].append(result)

        if results["failed"] > 0:
            results["success"] = False

        return results

    async def import_mob_resets(self, mob_resets: list, zone_id: int,
                                dry_run: bool = False, verbose: bool = False,
                                debug: bool = False) -> dict:
        """
        Import mob resets from in-memory reset data

        Args:
            mob_resets: List of mob reset dicts with legacy vnums
            zone_id: Zone ID for logging
            dry_run: If True, validate but don't write to database
            verbose: Enable verbose logging
            debug: Enable debug logging

        Returns:
            Dict with import results {"imported": int, "failed": int, "errors": [...]}
        """
        imported = 0
        failed = 0
        errors = []

        for mob_reset in mob_resets:
            mob_vnum = mob_reset['id']
            room_vnum = mob_reset['room']

            # Validate mob exists
            if mob_vnum not in self.mob_map:
                error_msg = f"Mob vnum {mob_vnum} not found - check zone {zone_id}.mob import"
                errors.append({"type": "mob", "mob_vnum": mob_vnum, "error": error_msg})
                failed += 1
                if debug:
                    print(f"❌ {error_msg}")
                continue

            # Validate room exists
            if room_vnum not in self.room_map:
                error_msg = f"Room vnum {room_vnum} not found - needed for mob {mob_vnum}"
                errors.append({"type": "room", "room_vnum": room_vnum, "mob_vnum": mob_vnum, "error": error_msg})
                failed += 1
                if debug:
                    print(f"❌ {error_msg}")
                continue

            mob_zone_id, mob_id = self.mob_map[mob_vnum]
            room_zone_id, room_id = self.room_map[room_vnum]

            if verbose or debug:
                print(f"✅ Mob reset: mob {mob_vnum} (zone {mob_zone_id}:{mob_id}) → room {room_vnum} (zone {room_zone_id}:{room_id})")

            # Validate equipment
            for equip in mob_reset.get('equipped', []):
                obj_vnum = equip['id']
                if obj_vnum not in self.object_map:
                    error_msg = f"Equipment obj vnum {obj_vnum} not found - needed for mob {mob_vnum}"
                    errors.append({"type": "equipment", "obj_vnum": obj_vnum, "mob_vnum": mob_vnum, "error": error_msg})
                    failed += 1
                    if debug:
                        print(f"❌ {error_msg}")

            # Validate inventory
            for item in mob_reset.get('carrying', []):
                obj_vnum = item['id']
                if obj_vnum not in self.object_map:
                    error_msg = f"Inventory obj vnum {obj_vnum} not found - needed for mob {mob_vnum}"
                    errors.append({"type": "inventory", "obj_vnum": obj_vnum, "mob_vnum": mob_vnum, "error": error_msg})
                    failed += 1
                    if debug:
                        print(f"❌ {error_msg}")

            if not dry_run:
                # Import via existing import_mob_reset method
                result = await self.import_mob_reset(mob_reset, zone_id, dry_run=False)
                if result["success"]:
                    imported += 1
                else:
                    failed += 1
                    errors.append(result)
            else:
                imported += 1

        return {
            "imported": imported,
            "failed": failed,
            "errors": errors
        }

    async def import_object_resets(self, object_resets: list, zone_id: int,
                                   dry_run: bool = False, verbose: bool = False,
                                   debug: bool = False) -> dict:
        """
        Import object resets from in-memory reset data

        Args:
            object_resets: List of object reset dicts with legacy vnums
            zone_id: Zone ID for logging
            dry_run: If True, validate but don't write to database
            verbose: Enable verbose logging
            debug: Enable debug logging

        Returns:
            Dict with import results {"imported": int, "failed": int, "errors": [...]}
        """
        imported = 0
        failed = 0
        errors = []

        for obj_reset in object_resets:
            obj_vnum = obj_reset['id']
            room_vnum = obj_reset['room']

            # Validate object exists
            if obj_vnum not in self.object_map:
                error_msg = f"Object vnum {obj_vnum} not found - check zone {zone_id}.obj import"
                errors.append({"type": "object", "obj_vnum": obj_vnum, "error": error_msg})
                failed += 1
                if debug:
                    print(f"❌ {error_msg}")
                continue

            # Validate room exists
            if room_vnum not in self.room_map:
                error_msg = f"Room vnum {room_vnum} not found - needed for object {obj_vnum}"
                errors.append({"type": "room", "room_vnum": room_vnum, "obj_vnum": obj_vnum, "error": error_msg})
                failed += 1
                if debug:
                    print(f"❌ {error_msg}")
                continue

            obj_zone_id, obj_id = self.object_map[obj_vnum]
            room_zone_id, room_id = self.room_map[room_vnum]

            if verbose or debug:
                print(f"✅ Object reset: obj {obj_vnum} (zone {obj_zone_id}:{obj_id}) → room {room_vnum} (zone {room_zone_id}:{room_id})")

            # Validate nested containers
            for nested in obj_reset.get('contains', []):
                nested_obj_vnum = nested['id']
                if nested_obj_vnum not in self.object_map:
                    error_msg = f"Container obj vnum {nested_obj_vnum} not found - needed for object {obj_vnum}"
                    errors.append({"type": "container", "obj_vnum": nested_obj_vnum, "parent_obj_vnum": obj_vnum, "error": error_msg})
                    failed += 1
                    if debug:
                        print(f"❌ {error_msg}")

            if not dry_run:
                # Import via existing import_object_reset method
                result = await self.import_object_reset(obj_reset, zone_id, dry_run=False)
                if result["success"]:
                    imported += 1
                else:
                    failed += 1
                    errors.append(result)
            else:
                imported += 1

        return {
            "imported": imported,
            "failed": failed,
            "errors": errors
        }
