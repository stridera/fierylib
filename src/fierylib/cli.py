#!/usr/bin/env python3
"""
FieryLib CLI - Main entry point for legacy data import
"""

import click
import os
import json
import subprocess
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


@click.group()
@click.version_option(version="0.1.0")
def main():
    """FieryLib - FieryMUD legacy data importer"""
    pass


@main.command()
@click.option(
    "--lib-path",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=lambda: os.getenv("LEGACY_LIB_PATH", "../lib"),
    help="Path to legacy CircleMUD lib directory",
)
@click.option(
    "--zone",
    type=int,
    help="Import specific zone only (e.g., 30 for zone 30)",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Parse and validate without importing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Enable verbose output",
)
@click.option(
    "--debug",
    is_flag=True,
    default=False,
    help="Enable debug output (shows all errors and warnings)",
)
@click.option(
    "--with-users",
    is_flag=True,
    default=False,
    help="Also seed test users after import",
)
@click.option(
    "--clear",
    is_flag=True,
    default=False,
    help="Clear existing data for zones before importing (prevents duplicates)",
)
def import_legacy(lib_path: str, zone: int | None, dry_run: bool, verbose: bool, debug: bool, with_users: bool, clear: bool):
    """Import legacy CircleMUD data to PostgreSQL database"""
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.importers import ZoneImporter, RoomImporter, MobImporter, ObjectImporter, ShopImporter, ResetImporter
    from fierylib.importers.trigger_importer import TriggerImporter
    from fierylib.importers.mail_importer import MailImporter
    from fierylib.importers.board_importer import import_boards as do_import_boards

    async def run_import():
        click.echo(f"FieryLib v0.1.0 - Legacy Data Importer")
        click.echo(f"Library path: {lib_path}")

        if zone:
            click.echo(f"Importing zone: {zone}")
        else:
            click.echo("Importing all zones")

        if dry_run:
            click.echo("DRY RUN - No database changes will be made\n")

        # Initialize Prisma
        prisma = Prisma()
        await prisma.connect()

        try:
            from fierylib.zone_reset_data import ZoneResetData, extract_door_resets, extract_mob_resets, extract_object_resets
            from mud.mudfile import MudData
            from mud.types.zone import Zone

            # Create importers
            zone_importer = ZoneImporter(prisma)
            room_importer = RoomImporter(prisma)
            mob_importer = MobImporter(prisma)
            object_importer = ObjectImporter(prisma)
            shop_importer = ShopImporter(prisma)
            reset_importer = ResetImporter(prisma)

            world_dir = Path(lib_path) / "world"
            zon_dir = world_dir / "zon"
            wld_dir = world_dir / "wld"
            mob_dir = world_dir / "mob"
            obj_dir = world_dir / "obj"
            shp_dir = world_dir / "shp"

            if not zon_dir.exists():
                click.echo(f"❌ Zone directory not found: {zon_dir}")
                return

            # Determine which zones to import
            if zone:
                zone_files = [zon_dir / f"{zone}.zon"]
            else:
                zone_files = sorted(zon_dir.glob("*.zon"))

            # Get list of zone IDs to process
            zone_ids_to_import = []
            for zone_file in zone_files:
                try:
                    zone_ids_to_import.append(int(zone_file.stem))
                except ValueError:
                    pass

            # Clear existing data if requested (prevents duplicates on re-import)
            if clear and not dry_run and zone_ids_to_import:
                click.echo(f"\n{'='*60}")
                click.echo(f"Clearing Existing Data for {len(zone_ids_to_import)} Zone(s)")
                click.echo(f"{'='*60}")

                # All tables have onDelete: Cascade to Zones, so we just need to
                # delete the Zone record and everything cascades automatically.
                # Convert zone IDs using the same logic as import
                from fierylib.converters import convert_zone_id

                for zone_num in zone_ids_to_import:
                    db_zone_id = convert_zone_id(zone_num)
                    if verbose:
                        click.echo(f"  Clearing zone {db_zone_id} (from {zone_num})...")

                    # Just delete the zone - CASCADE handles all dependent tables
                    await prisma.execute_raw('DELETE FROM "Zones" WHERE id = $1', db_zone_id)

                click.echo(f"  ✅ Cleared data for {len(zone_ids_to_import)} zone(s)")

            total_stats = {
                "zones": 0,
                "rooms": 0,
                "mobs": 0,
                "objects": 0,
                "shops": 0,
                "mob_resets": 0,
                "object_resets": 0,
                "triggers": 0,
                "mail": 0,
                "boards": 0,
                "board_messages": 0,
                "failed": 0,
            }

            # Accumulate a structured run log to help debugging if needed
            run_log = {
                "lib_path": str(lib_path),
                "dry_run": dry_run,
                "zones": [],
                "rooms": [],
                "mobs": [],
                "objects": [],
                "shops": [],
                "summary": total_stats.copy(),
            }

            # PHASE 0: Seed core data (classes, races) before importing mobs
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 0: Seeding Core Data (Classes, Races)")
            click.echo(f"{'='*60}")

            # Check if classes already exist
            existing_class_count = await prisma.characterclass.count()
            if existing_class_count > 0:
                click.echo(f"  ✅ Classes already seeded: {existing_class_count} classes exist")
            else:
                from fierylib.importers.class_importer_v2 import ClassImporterV2

                # Seed classes from pre-generated JSON
                classes_json = Path("data/classes.json")
                if classes_json.exists():
                    class_importer = ClassImporterV2(prisma)
                    # Just import class definitions, skip skill/spell/circle assignments
                    import json
                    with classes_json.open('r') as f:
                        classes_data = json.load(f)
                    class_stats = await class_importer.import_classes(classes_data.get("classes", []))
                    click.echo(f"  ✅ Classes: {class_stats.get('classes_created', 0)} created, {class_stats.get('classes_skipped', 0)} skipped")
                else:
                    click.echo(f"  ⚠️  data/classes.json not found, run 'fierylib seed classes --regenerate' first")

            # Seed spell slot progression (static data from legacy C++)
            existing_slots = await prisma.spellslotprogression.count()
            if existing_slots > 0:
                click.echo(f"  ✅ Spell slots already seeded: {existing_slots} entries exist")
            else:
                from fierylib.importers.spell_slot_importer import SpellSlotImporter
                slot_importer = SpellSlotImporter(prisma)
                slot_stats = await slot_importer.import_spell_slots(dry_run=dry_run, verbose=verbose)
                click.echo(f"  ✅ Spell slots: {slot_stats['rows_created']} entries created")

            # PHASE 1: Parse all zones once, create Zone DB records, store resets in memory
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 1: Parsing Zones and Extracting Resets")
            click.echo(f"{'='*60}")

            zone_reset_map = {}  # zone_id -> ZoneResetData
            parsed_zones = {}  # zone_id -> parsed Zone object (for door resets later)

            for zone_file in zone_files:
                # Skip non-numeric zone files
                try:
                    zone_num = int(zone_file.stem)
                except ValueError:
                    if verbose or debug:
                        click.echo(f"⚠️  Skipping invalid zone file: {zone_file.name}")
                    continue

                # Parse zone file ONCE
                try:
                    with open(zone_file, "r") as f:
                        content = f.read()
                    lines = content.split("\n")
                    mud_data = MudData(lines)
                    parsed_zone = Zone.parse(mud_data)
                except Exception as e:
                    if verbose or debug:
                        click.echo(f"❌ Zone {zone_num}: Failed to parse - {str(e)[:100]}")
                    total_stats["failed"] += 1
                    continue

                # Import zone metadata to database
                zone_result = await zone_importer.import_zone(parsed_zone, dry_run=dry_run, skip_door_resets=True)
                run_log["zones"].append(zone_result)

                if zone_result["success"]:
                    zone_id = zone_result["zone_id"]
                    click.echo(f"✅ Zone {zone_id} ({zone_result['zone_name']}): {zone_result['action']}")
                    total_stats["zones"] += 1

                    # Store parsed zone for door reset application later
                    parsed_zones[zone_id] = parsed_zone

                    # Extract and store resets in memory
                    zone_reset_map[zone_id] = ZoneResetData(
                        zone_id=zone_id,
                        door_resets=extract_door_resets(parsed_zone),
                        mob_resets=extract_mob_resets(parsed_zone),
                        object_resets=extract_object_resets(parsed_zone)
                    )

                    if verbose:
                        door_count = len(zone_reset_map[zone_id].door_resets)
                        mob_count = len(zone_reset_map[zone_id].mob_resets)
                        obj_count = len(zone_reset_map[zone_id].object_resets)
                        click.echo(f"  📋 Extracted {door_count} door resets, {mob_count} mob resets, {obj_count} object resets")
                else:
                    click.echo(f"❌ Zone import failed: {zone_result.get('error', 'Unknown error')}")
                    total_stats["failed"] += 1
                    continue

            # PHASE 2: Import entities (rooms, mobs, objects, shops)
            # Split into 2A (rooms), 2B (mobs/objects/shops), 2C (exits) for cross-zone references
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 2A: Importing Rooms (without exits)")
            click.echo(f"{'='*60}")

            # Initialize vnum maps for incremental building
            vnum_maps = {
                'rooms': {},    # vnum -> (zone_id, id)
                'mobs': {},     # vnum -> (zone_id, id)
                'objects': {}   # vnum -> (zone_id, id)
            }

            # Store parsed room data for Phase 2C (exit import)
            room_data_by_zone = {}  # zone_id -> list of parsed rooms

            for zone_file in zone_files:
                # Skip non-numeric zone files
                try:
                    zone_num = int(zone_file.stem)
                except ValueError:
                    continue

                # Skip if zone wasn't successfully imported
                from fierylib.converters import convert_zone_id
                zone_id = convert_zone_id(zone_num)
                if zone_id not in zone_reset_map:
                    continue

                click.echo(f"  Zone {zone_id}: Importing rooms...")

                # Import rooms WITHOUT exits (Phase 2A - global room import)
                wld_file = wld_dir / f"{zone_num}.wld"
                if wld_file.exists():
                    # Parse rooms and store for later exit import
                    from mud.mudfile import MudData
                    from mud.types.world import World

                    with open(wld_file, "r") as f:
                        content = f.read()
                    lines = content.split("\n")
                    mud_data = MudData(lines)
                    parsed_rooms = World.parse(mud_data)
                    room_data_by_zone[zone_id] = parsed_rooms

                    # Import rooms without exits (skip_exits=True forces single-pass)
                    room_result = {
                        "success": True,
                        "file": str(wld_file),
                        "zones_in_file": [zone_id],
                        "zones_created": [],
                        "total": len(parsed_rooms),
                        "imported": 0,
                        "failed": 0,
                        "rooms": [],
                    }

                    for room in parsed_rooms:
                        room_id = int(room["id"])
                        result = await room_importer.import_room(
                            room,
                            zone_id,
                            dry_run=dry_run,
                            base_zone_override=zone_id,
                            skip_exits=True,  # Skip exits in Phase 2A
                        )

                        # Populate vnum_map
                        if vnum_maps is not None and result.get("success"):
                            vnum_maps['rooms'][room_id] = (zone_id, result["vnum"])

                        room_result["rooms"].append(result)
                        if result["success"]:
                            room_result["imported"] += 1
                        else:
                            room_result["failed"] += 1
                            room_result["success"] = False

                    run_log["rooms"].append(room_result)
                    imported = room_result.get("imported", 0)
                    failed = room_result.get("failed", 0)
                    total = room_result.get("total", 0)
                    total_stats["rooms"] += imported
                    
                    if verbose:
                        click.echo(f"  [DEBUG] Room import result: imported={imported}, failed={failed}, total={total}")
                        if room_result.get("error"):
                            click.echo(f"  [DEBUG] Room import error: {room_result['error']}")
                    
                    if imported > 0:
                        if failed > 0:
                            click.echo(f"  ⚠️  Rooms: {imported} imported, {failed} failed")
                            if verbose or debug:
                                # Show failed rooms
                                error_count = 0
                                for room in room_result.get("rooms", []):
                                    if not room.get("success"):
                                        if debug or error_count < 5:
                                            error_msg = room.get('error', 'Unknown error')
                                            if len(error_msg) > 150 and not debug:
                                                error_msg = error_msg[:150] + "..."
                                            room_name = room.get('name', 'unnamed')[:30]
                                            click.echo(f"      - Room {room.get('vnum')} ({room_name}): {error_msg}")
                                            error_count += 1
                                if not debug and failed > error_count:
                                    click.echo(f"      ... and {failed - error_count} more (use --debug to see all)")
                        else:
                            click.echo(f"  ✅ Rooms: {imported} imported")
                            # Check for exit import errors even on successful rooms
                            if debug:
                                for room in room_result.get("rooms", []):
                                    if room.get("success") and room.get("exit_errors"):
                                        room_name = room.get('name', 'unnamed')[:30]
                                        click.echo(f"      - Room {room.get('vnum')} ({room_name}) has exit errors:")
                                        for err in room.get("exit_errors", []):
                                            click.echo(f"          {err}")
                    else:
                        error_msg = room_result.get('error', f'Failed to import any rooms')
                        click.echo(f"  ❌ Room import failed: {error_msg}")
                        if debug and room_result.get("rooms"):
                            # Show all failed rooms
                            for room in room_result.get("rooms", [])[:10]:
                                if not room.get("success"):
                                    room_name = room.get('name', 'unnamed')[:30]
                                    click.echo(f"      - Room {room.get('vnum')} ({room_name}): {room.get('error', 'Unknown error')}")
                            if room_result.get("rooms") and len(room_result.get("rooms", [])) > 10:
                                click.echo(f"      ... and {len(room_result.get('rooms', [])) - 10} more")
                        total_stats["failed"] += 1

                # Import mobs (with vnum map building)
                mob_file = mob_dir / f"{zone_num}.mob"
                if mob_file.exists():
                    mob_result = await mob_importer.import_mobs_from_file(
                        mob_file, zone_id, dry_run=dry_run,
                        vnum_map=vnum_maps['mobs']
                    )
                    run_log["mobs"].append(mob_result)
                    imported = mob_result.get("imported", 0)
                    failed = mob_result.get("failed", 0)
                    total = mob_result.get("total", 0)
                    total_stats["mobs"] += imported
                    
                    if imported > 0:
                        if failed > 0:
                            click.echo(f"  ⚠️  Mobs: {imported} imported, {failed} failed")
                            if verbose or debug:
                                # Show failed mobs
                                error_count = 0
                                for mob in mob_result.get("mobs", []):
                                    if not mob.get("success"):
                                        if debug or error_count < 5:
                                            error_msg = mob.get('error', 'Unknown error')
                                            if len(error_msg) > 150 and not debug:
                                                error_msg = error_msg[:150] + "..."
                                            click.echo(f"      - Mob {mob.get('vnum')} ({mob.get('keywords', 'no keywords')[:30]}): {error_msg}")
                                            error_count += 1
                                if not debug and failed > error_count:
                                    click.echo(f"      ... and {failed - error_count} more (use --debug to see all)")
                        else:
                            click.echo(f"  ✅ Mobs: {imported} imported")
                    elif total == 0:
                        # Empty file is not an error, just don't report it unless verbose
                        if verbose or debug:
                            click.echo(f"  ℹ️  No mobs in file")
                    else:
                        error_msg = mob_result.get('error', f'Failed to import any mobs')
                        click.echo(f"  ❌ Mob import failed: {error_msg}")
                        if debug:
                            # Show all failed mobs
                            for mob in mob_result.get("mobs", [])[:10]:
                                if not mob.get("success"):
                                    click.echo(f"      - Mob {mob.get('vnum')} ({mob.get('keywords', 'no keywords')[:30]}): {mob.get('error', 'Unknown error')}")
                            if mob_result.get("mobs") and len(mob_result.get("mobs", [])) > 10:
                                click.echo(f"      ... and {len(mob_result.get('mobs', [])) - 10} more")
                        total_stats["failed"] += 1
                else:
                    if verbose:
                        click.echo(f"  ℹ️  No mob file found: {mob_file.name}")

                # Import objects (with vnum map building)
                obj_file = obj_dir / f"{zone_num}.obj"
                if obj_file.exists():
                    obj_result = await object_importer.import_objects_from_file(
                        obj_file, zone_id, dry_run=dry_run,
                        vnum_map=vnum_maps['objects']
                    )
                    run_log["objects"].append(obj_result)
                    imported = obj_result.get("imported", 0)
                    failed = obj_result.get("failed", 0)
                    total = obj_result.get("total", 0)
                    total_stats["objects"] += imported
                    
                    if imported > 0:
                        if failed > 0:
                            click.echo(f"  ⚠️  Objects: {imported} imported, {failed} failed")
                            if verbose or debug:
                                # Show failed objects
                                error_count = 0
                                for obj in obj_result.get("objects", []):
                                    if not obj.get("success"):
                                        if debug or error_count < 5:
                                            error_msg = obj.get('error', 'Unknown error')
                                            if len(error_msg) > 150 and not debug:
                                                error_msg = error_msg[:150] + "..."
                                            click.echo(f"      - Obj {obj.get('vnum')} ({obj.get('keywords', ['no keywords'])[0] if obj.get('keywords') else 'no keywords'}): {error_msg}")
                                            error_count += 1
                                if not debug and failed > error_count:
                                    click.echo(f"      ... and {failed - error_count} more (use --debug to see all)")
                        else:
                            click.echo(f"  ✅ Objects: {imported} imported")
                    elif total == 0:
                        # Empty file is not an error, just don't report it unless verbose
                        if verbose or debug:
                            click.echo(f"  ℹ️  No objects in file")
                    else:
                        error_msg = obj_result.get('error', f'Failed to import any objects')
                        click.echo(f"  ❌ Object import failed: {error_msg}")
                        if debug:
                            # Show all failed objects
                            for obj in obj_result.get("objects", [])[:10]:
                                if not obj.get("success"):
                                    click.echo(f"      - Obj {obj.get('vnum')} ({obj.get('keywords', ['no keywords'])[0] if obj.get('keywords') else 'no keywords'}): {obj.get('error', 'Unknown error')}")
                            if obj_result.get("objects") and len(obj_result.get("objects", [])) > 10:
                                click.echo(f"      ... and {len(obj_result.get('objects', [])) - 10} more")
                        total_stats["failed"] += 1
                else:
                    if verbose:
                        click.echo(f"  ℹ️  No object file found: {obj_file.name}")

                # Import shops
                shp_file = shp_dir / f"{zone_num}.shp"
                if shp_file.exists():
                    shp_result = await shop_importer.import_shops_from_file(
                        shp_file, zone_id, dry_run=dry_run
                    )
                    run_log["shops"].append(shp_result)
                    imported = shp_result.get("imported", 0)
                    failed = shp_result.get("failed", 0)
                    total = shp_result.get("total", 0)
                    total_stats["shops"] += imported

                    if imported > 0:
                        if failed > 0:
                            click.echo(f"  ⚠️  Shops: {imported} imported, {failed} failed")
                            if verbose or debug:
                                # Show failed shops
                                error_count = 0
                                for shop in shp_result.get("shops", []):
                                    if not shop.get("success"):
                                        if debug or error_count < 5:
                                            error_msg = shop.get('error', 'Unknown error')
                                            if len(error_msg) > 150 and not debug:
                                                error_msg = error_msg[:150] + "..."
                                            click.echo(f"      - Shop keeper {shop.get('keeper_vnum', 'unknown')}: {error_msg}")
                                            error_count += 1
                                if not debug and failed > error_count:
                                    click.echo(f"      ... and {failed - error_count} more (use --debug to see all)")
                        else:
                            click.echo(f"  ✅ Shops: {imported} imported")
                    elif total == 0:
                        # Empty file is not an error, just don't report it unless verbose
                        if verbose or debug:
                            click.echo(f"  ℹ️  No shops in file")
                    else:
                        error_msg = shp_result.get('error', f'Failed to import any shops')
                        click.echo(f"  ❌ Shop import failed: {error_msg}")
                        if debug:
                            # Show all failed shops
                            for shop in shp_result.get("shops", [])[:10]:
                                if not shop.get("success"):
                                    click.echo(f"      - Shop keeper {shop.get('keeper_vnum', 'unknown')}: {shop.get('error', 'Unknown error')}")
                            if shp_result.get("shops") and len(shp_result.get("shops", [])) > 10:
                                click.echo(f"      ... and {len(shp_result.get('shops', [])) - 10} more")
                        total_stats["failed"] += 1
                else:
                    if verbose:
                        click.echo(f"  ℹ️  No shop file found: {shp_file.name}")

            # PHASE 2C: Import ALL exits (now all destination rooms exist)
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 2C: Importing Room Exits")
            click.echo(f"{'='*60}")

            if verbose or debug:
                click.echo(f"  [DEBUG] vnum_map size: {len(vnum_maps['rooms'])} rooms")
                click.echo(f"  [DEBUG] Sample vnum_map entries: {dict(list(vnum_maps['rooms'].items())[:5])}")

            total_stats["exits_imported"] = 0
            total_stats["exits_failed"] = 0

            for zone_id, parsed_rooms in room_data_by_zone.items():
                zone_exits_imported = 0
                zone_exits_failed = 0

                for room in parsed_rooms:
                    if not dry_run:
                        exit_result = await room_importer.import_exits_for_room(
                            room,
                            zone_id,
                            base_zone_override=zone_id,
                            vnum_map=vnum_maps['rooms'],
                        )
                        zone_exits_imported += exit_result.get("exits_imported", 0)
                        zone_exits_failed += exit_result.get("exits_failed", 0)

                total_stats["exits_imported"] += zone_exits_imported
                total_stats["exits_failed"] += zone_exits_failed

                if not dry_run:
                    if zone_exits_failed > 0:
                        click.echo(f"  Zone {zone_id}: {zone_exits_imported} exits imported, {zone_exits_failed} failed ⚠️")
                    else:
                        click.echo(f"  Zone {zone_id}: {zone_exits_imported} exits imported ✅")

            # PHASE 2D: Apply door resets (set defaultState on exits)
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 2D: Applying Door Resets")
            click.echo(f"{'='*60}")

            # Give zone_importer access to room map for door resets
            zone_importer.room_map = vnum_maps['rooms']

            total_door_resets = 0
            for zone_id, reset_data in zone_reset_map.items():
                if not reset_data.door_resets:
                    continue

                # Apply door resets for this zone
                if zone_id in parsed_zones:
                    door_applied, door_warnings = await zone_importer.apply_door_resets(parsed_zones[zone_id], dry_run=dry_run)
                    total_door_resets += len(door_applied)
                    if door_warnings and (verbose or debug):
                        for warning in door_warnings[:5]:
                            click.echo(f"  ⚠️  {warning}")

            if total_door_resets > 0:
                click.echo(f"  ✅ Applied {total_door_resets} door resets")
            else:
                click.echo(f"  ℹ️  No door resets to apply")

            # PHASE 3: Apply mob/object resets using prebuilt vnum maps
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 3: Applying Mob/Object Resets")
            click.echo(f"{'='*60}")

            # Build shopkeeper vnums set (G commands skipped for these mobs)
            # Shop inventory comes from ShopItems, not mob inventory
            shopkeeper_vnums: set[int] = set()
            shops = await prisma.shops.find_many(
                where={"keeperZoneId": {"not": None}, "keeperId": {"not": None}}
            )
            for shop in shops:
                vnum = (shop.keeperZoneId * 100) + shop.keeperId if shop.keeperZoneId != 1000 else shop.keeperId
                shopkeeper_vnums.add(vnum)
            if verbose or debug:
                click.echo(f"  [DEBUG] Found {len(shopkeeper_vnums)} shopkeepers (G commands will be skipped)")

            # Pass prebuilt vnum maps to reset importer (no DB queries needed!)
            reset_importer.set_vnum_maps(
                room_map=vnum_maps['rooms'],
                mob_map=vnum_maps['mobs'],
                object_map=vnum_maps['objects'],
                shopkeeper_vnums=shopkeeper_vnums
            )

            for zone_id, reset_data in zone_reset_map.items():
                if not reset_data.mob_resets and not reset_data.object_resets:
                    continue

                click.echo(f"  Zone {zone_id}: Processing resets...")

                # Import mob resets
                if reset_data.mob_resets:
                    mob_result = await reset_importer.import_mob_resets(
                        reset_data.mob_resets, zone_id, dry_run=dry_run, verbose=verbose, debug=debug
                    )
                    total_stats["mob_resets"] += mob_result.get("imported", 0)

                    if mob_result.get("failed", 0) > 0:
                        total_stats["failed"] += mob_result["failed"]

                # Import object resets
                if reset_data.object_resets:
                    obj_result = await reset_importer.import_object_resets(
                        reset_data.object_resets, zone_id, dry_run=dry_run, verbose=verbose, debug=debug
                    )
                    total_stats["object_resets"] += obj_result.get("imported", 0)

                    if obj_result.get("failed", 0) > 0:
                        total_stats["failed"] += obj_result["failed"]

            # PHASE 3.5: Import known pet/mount shops from legacy spec_assign.cpp
            # Only these specific rooms have the pet_shop spec_proc in legacy code
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 3.5: Importing Pet/Mount Shops (from legacy spec_assign)")
            click.echo(f"{'='*60}")

            # Known legacy pet shop rooms from spec_assign.cpp
            # These are the ONLY rooms that should sell mobs
            LEGACY_PET_SHOP_ROOMS = [
                3030,   # Kayla's Pet Shop (Mielikki, zone 30)
                3091,   # Jorhan's Mount Shop (Mielikki, zone 30)
                6228,   # Pet shop (Zone 62)
                10056,  # Pet shop (Zone 100)
                30012,  # Pet shop (Zone 300)
                30031,  # Pet shop (Zone 300)
            ]

            total_stats["pet_shops"] = 0
            total_stats["shop_mobs"] = 0

            for room_vnum in LEGACY_PET_SHOP_ROOMS:
                pet_result = await shop_importer.import_pet_shop_from_legacy_spec(
                    room_vnum, dry_run=dry_run
                )

                if pet_result.get("shop_found", False):
                    total_stats["pet_shops"] += 1
                    total_stats["shop_mobs"] += pet_result.get("mobs_linked", 0)

                    if verbose or debug:
                        click.echo(f"  🐾 Room {room_vnum}: Shop {pet_result.get('shop', 'unknown')} linked {pet_result.get('mobs_linked', 0)} mobs")
                elif verbose or debug:
                    error = pet_result.get("error", "Unknown error")
                    click.echo(f"  ⚠️  Room {room_vnum}: {error}")

            if total_stats["pet_shops"] > 0:
                click.echo(f"  ✅ Imported {total_stats['pet_shops']} pet/mount shops with {total_stats['shop_mobs']} mobs linked")
            else:
                click.echo(f"  ℹ️  No pet/mount shops imported")

            # PHASE 4: Import Triggers (from curated Lua files)
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 4: Importing Triggers (from Lua files)")
            click.echo(f"{'='*60}")

            # Look for triggers in fierylib/data/triggers/ (curated Lua files)
            # Go up from src/fierylib/cli.py to fierylib/data/triggers
            triggers_dir = Path(__file__).parent.parent.parent / "data" / "triggers"
            if not triggers_dir.exists():
                # Fallback: try relative to current working directory
                triggers_dir = Path("data/triggers")

            if triggers_dir.exists():
                trigger_importer = TriggerImporter(prisma)

                # Clear existing triggers if --clear was specified
                if clear and not dry_run:
                    await trigger_importer.clear_all_triggers()

                # Import triggers from Lua files
                trg_result = await trigger_importer.import_from_lua_directory(
                    triggers_dir,
                    dry_run=dry_run,
                    verbose=verbose,
                    zone=zone,
                )
                total_stats["triggers"] += trg_result.get("imported", 0) + trg_result.get("updated", 0)
                if trg_result.get("failed", 0) > 0:
                    total_stats["failed"] += trg_result["failed"]

                if trg_result["success"]:
                    click.echo(f"  ✅ Imported {trg_result.get('total', 0)} triggers from {triggers_dir}")
                else:
                    click.echo(f"  ⚠️  Imported {trg_result.get('total', 0)} triggers ({trg_result.get('failed', 0)} failed)")
                    for err in trg_result.get("errors", [])[:5]:
                        click.echo(f"      Error: {err['file']}: {err['error']}")
            else:
                click.echo(f"  ⚠️  Triggers directory not found: {triggers_dir}")
                click.echo(f"      Run 'fierylib triggers convert-legacy' to generate Lua files in data/triggers/")

            # PHASE 4b: Link Mob Triggers (parse T lines from mob files)
            click.echo(f"\n  --- Linking Mob Triggers ---")
            mob_dir = world_dir / "mob"
            if mob_dir.exists() and not dry_run:
                from fierylib.importers.mob_trigger_linker import MobTriggerLinker
                linker = MobTriggerLinker(prisma)
                link_result = await linker.link_mob_triggers(world_dir, dry_run=dry_run, verbose=verbose)
                total_stats["trigger_links"] = link_result.get("links_created", 0)
                if link_result.get("errors"):
                    total_stats["failed"] += len(link_result["errors"])
                click.echo(f"  ✅ Created {link_result.get('links_created', 0)} mob-trigger links for {link_result.get('mobs_processed', 0)} mobs")
            elif dry_run:
                click.echo(f"  ⏭️  Skipped (dry run)")
            else:
                click.echo(f"  ⚠️  Mob directory not found: {mob_dir}")

            # PHASE 4c: Link Object Triggers (parse T lines from object files)
            click.echo(f"\n  --- Linking Object Triggers ---")
            obj_dir = world_dir / "obj"
            if obj_dir.exists() and not dry_run:
                from fierylib.importers.object_trigger_linker import ObjectTriggerLinker
                obj_linker = ObjectTriggerLinker(prisma)
                obj_link_result = await obj_linker.link_object_triggers(world_dir, dry_run=dry_run, verbose=verbose)
                total_stats["object_trigger_links"] = obj_link_result.get("links_created", 0)
                if obj_link_result.get("errors"):
                    total_stats["failed"] += len(obj_link_result["errors"])
                click.echo(f"  ✅ Created {obj_link_result.get('links_created', 0)} object-trigger links for {obj_link_result.get('objects_processed', 0)} objects")
            elif dry_run:
                click.echo(f"  ⏭️  Skipped (dry run)")
            else:
                click.echo(f"  ⚠️  Object directory not found: {obj_dir}")

            # PHASE 5: Import Mail
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 5: Importing Player Mail")
            click.echo(f"{'='*60}")

            mail_file = Path(lib_path) / "etc" / "plrmail"
            if mail_file.exists():
                mail_importer = MailImporter(prisma)
                mail_stats = await mail_importer.import_from_file(mail_file, dry_run=dry_run, verbose=verbose)
                total_stats["mail"] += mail_stats.get("imported", 0)
                if mail_stats.get("errors", 0) > 0:
                    total_stats["failed"] += mail_stats["errors"]
                click.echo(f"  ✅ Imported {mail_stats.get('imported', 0)} mail messages")
            else:
                click.echo(f"  ⚠️  Mail file not found: {mail_file}")

            # PHASE 6: Import Boards
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 6: Importing Bulletin Boards")
            click.echo(f"{'='*60}")

            boards_dir = Path(lib_path) / "etc" / "boards"
            if not boards_dir.exists():
                # Try alternate location
                boards_dir = Path("/home/strider/Code/mud/fierymud/legacy/lib/etc/boards")

            if boards_dir.exists():
                board_stats = await do_import_boards(boards_dir, verbose=verbose, clear_existing=clear)
                total_stats["boards"] += board_stats.get("boards_created", 0) + board_stats.get("boards_updated", 0)
                total_stats["board_messages"] += board_stats.get("messages_created", 0)
                if board_stats.get("errors", 0) > 0:
                    total_stats["failed"] += board_stats["errors"]
                click.echo(f"  ✅ Imported {total_stats['boards']} boards with {total_stats['board_messages']} messages")
            else:
                click.echo(f"  ⚠️  Boards directory not found")

            # PHASE 7: Apply Spec Proc Flags
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 7: Applying Special Procedure Flags")
            click.echo(f"{'='*60}")

            from fierylib.importers.spec_proc_importer import SpecProcImporter
            spec_proc_importer = SpecProcImporter(prisma)

            spec_result = await spec_proc_importer.apply_spec_proc_flags(dry_run=dry_run)
            total_stats["spec_proc_flags"] = spec_result.get("flags_applied", 0)

            if spec_result["flags_applied"] > 0:
                click.echo(f"  ✅ Applied {spec_result['flags_applied']} spec_proc flags (RECEPTIONIST, POSTMASTER, etc.)")
                if verbose:
                    for detail in spec_result.get("details", []):
                        if detail.get("action") in ["applied", "would_apply"]:
                            click.echo(f"      {detail['mob_name']} ({detail['vnum']}): +{detail['flag']}")
            else:
                click.echo(f"  ℹ️  No spec_proc flags to apply (mobs may not be imported yet)")

            if spec_result.get("mobs_not_found"):
                if verbose:
                    click.echo(f"  ⚠️  {len(spec_result['mobs_not_found'])} mobs not found (from other zones)")

            # Summary
            click.echo(f"\n{'='*60}")
            click.echo(f"Import Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Zones:         {total_stats['zones']}")
            click.echo(f"  Rooms:         {total_stats['rooms']}")
            click.echo(f"  Exits:         {total_stats.get('exits_imported', 0)}")
            if total_stats.get('exits_failed', 0) > 0:
                click.echo(f"  Exits Failed:  {total_stats['exits_failed']} ⚠️")
            click.echo(f"  Mobs:          {total_stats['mobs']}")
            click.echo(f"  Objects:       {total_stats['objects']}")
            click.echo(f"  Shops:         {total_stats['shops']}")
            if total_stats.get('pet_shops', 0) > 0:
                click.echo(f"  Pet Shops:     {total_stats['pet_shops']} ({total_stats.get('shop_mobs', 0)} mobs linked)")
            click.echo(f"  Mob Resets:    {total_stats['mob_resets']}")
            click.echo(f"  Object Resets: {total_stats['object_resets']}")
            needs_review = total_stats.get('needs_review', 0)
            if needs_review > 0:
                click.echo(f"  Triggers:      {total_stats['triggers']} ({needs_review} need review)")
            else:
                click.echo(f"  Triggers:      {total_stats['triggers']}")
            click.echo(f"  Mail:          {total_stats['mail']}")
            click.echo(f"  Boards:        {total_stats['boards']} ({total_stats['board_messages']} messages)")
            if total_stats.get('spec_proc_flags', 0) > 0:
                click.echo(f"  Spec Procs:    {total_stats['spec_proc_flags']} flags applied")

            if total_stats['failed'] > 0:
                click.echo(f"  Failed:   {total_stats['failed']} ⚠️")
                if not debug:
                    click.echo(f"\n💡 Tip: Run with --debug to see detailed error messages for all failures")
            else:
                click.echo(f"  Failed:   0 ✅")

            if needs_review > 0:
                click.echo(f"\n📝 {needs_review} triggers have Lua syntax errors and need manual review in Muditor.")
                click.echo(f"   Use the Trigger Editor and filter by 'Needs Review' to fix them.")
            
            if verbose or debug:
                # Show breakdown of failures by type
                failure_types = {
                    'zones': 0,
                    'rooms': 0,
                    'mobs': 0,
                    'objects': 0,
                    'shops': 0
                }
                
                for zone_result in run_log['zones']:
                    if not zone_result.get('success'):
                        failure_types['zones'] += 1
                
                for room_result in run_log['rooms']:
                    failure_types['rooms'] += room_result.get('failed', 0)
                
                for mob_result in run_log['mobs']:
                    failure_types['mobs'] += mob_result.get('failed', 0)
                    if mob_result.get('imported', 0) == 0 and mob_result.get('total', 0) > 0:
                        failure_types['mobs'] += 1
                
                for obj_result in run_log['objects']:
                    failure_types['objects'] += obj_result.get('failed', 0)
                    if obj_result.get('imported', 0) == 0 and obj_result.get('total', 0) > 0:
                        failure_types['objects'] += 1
                
                for shp_result in run_log['shops']:
                    failure_types['shops'] += shp_result.get('failed', 0)
                    if shp_result.get('imported', 0) == 0 and shp_result.get('total', 0) > 0:
                        failure_types['shops'] += 1
                
                if any(failure_types.values()):
                    click.echo(f"\n  Failure breakdown:")
                    if failure_types['zones'] > 0:
                        click.echo(f"    - Zones:   {failure_types['zones']}")
                    if failure_types['rooms'] > 0:
                        click.echo(f"    - Rooms:   {failure_types['rooms']}")
                    if failure_types['mobs'] > 0:
                        click.echo(f"    - Mobs:    {failure_types['mobs']}")
                    if failure_types['objects'] > 0:
                        click.echo(f"    - Objects: {failure_types['objects']}")
                    if failure_types['shops'] > 0:
                        click.echo(f"    - Shops:   {failure_types['shops']}")

            if dry_run:
                click.echo(f"\n(Dry run - no database changes made)")

            # Generate failure report if there were any failures
            if total_stats['failed'] > 0:
                report_path = Path.cwd() / "import_failures.txt"
                click.echo(f"\n{'='*60}")
                click.echo(f"Generating Failure Report")
                click.echo(f"{'='*60}")

                from datetime import datetime as dt

                with open(report_path, 'w') as report:
                    report.write("FieryMUD Legacy Data Import - Failure Report\n")
                    report.write("=" * 70 + "\n")
                    report.write(f"Generated: {dt.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
                    report.write(f"Total Failures: {total_stats['failed']}\n")
                    report.write("=" * 70 + "\n\n")

                    # Reset failures
                    report.write("RESET FAILURES\n")
                    report.write("-" * 70 + "\n")
                    reset_failures = []
                    for reset_result in run_log.get('resets', []):
                        for error in reset_result.get('errors', []):
                            reset_failures.append(error)

                    if reset_failures:
                        report.write(f"Total: {len(reset_failures)} failed resets\n\n")
                        for i, failure in enumerate(reset_failures, 1):
                            report.write(f"{i}. {failure['type'].upper()} RESET\n")
                            if failure['type'] == 'mob':
                                report.write(f"   Mob: {failure.get('mob_id', 'unknown')}\n")
                                report.write(f"   Room: {failure.get('room_id', 'unknown')}\n")
                            elif failure['type'] == 'object':
                                report.write(f"   Object: {failure.get('object_id', 'unknown')}\n")
                                if 'location' in failure:
                                    report.write(f"   Location: {failure['location']}\n")
                            report.write(f"   Error: {failure.get('error', 'Unknown error')}\n")
                            report.write("\n")
                    else:
                        report.write("None\n\n")

                    # Room failures
                    report.write("\nROOM IMPORT FAILURES\n")
                    report.write("-" * 70 + "\n")
                    room_failures = []
                    for room_result in run_log.get('rooms', []):
                        for room in room_result.get('rooms', []):
                            if not room.get('success'):
                                room_failures.append(room)

                    if room_failures:
                        report.write(f"Total: {len(room_failures)} failed rooms\n\n")
                        for i, failure in enumerate(room_failures, 1):
                            report.write(f"{i}. Room {failure.get('zone_id', '?')}:{failure.get('vnum', '?')}\n")
                            report.write(f"   Name: {failure.get('name', 'unknown')}\n")
                            report.write(f"   Error: {failure.get('error', 'Unknown error')}\n")
                            report.write("\n")
                    else:
                        report.write("None\n\n")

                    # Mob failures
                    report.write("\nMOB IMPORT FAILURES\n")
                    report.write("-" * 70 + "\n")
                    mob_failures = []
                    for mob_result in run_log.get('mobs', []):
                        for mob in mob_result.get('mobs', []):
                            if not mob.get('success'):
                                mob_failures.append(mob)

                    if mob_failures:
                        report.write(f"Total: {len(mob_failures)} failed mobs\n\n")
                        for i, failure in enumerate(mob_failures, 1):
                            report.write(f"{i}. Mob {failure.get('zone_id', '?')}:{failure.get('vnum', '?')}\n")
                            report.write(f"   Keywords: {failure.get('keywords', 'unknown')}\n")
                            report.write(f"   Error: {failure.get('error', 'Unknown error')}\n")
                            report.write("\n")
                    else:
                        report.write("None\n\n")

                    # Object failures
                    report.write("\nOBJECT IMPORT FAILURES\n")
                    report.write("-" * 70 + "\n")
                    object_failures = []
                    for obj_result in run_log.get('objects', []):
                        for obj in obj_result.get('objects', []):
                            if not obj.get('success'):
                                object_failures.append(obj)

                    if object_failures:
                        report.write(f"Total: {len(object_failures)} failed objects\n\n")
                        for i, failure in enumerate(object_failures, 1):
                            report.write(f"{i}. Object {failure.get('zone_id', '?')}:{failure.get('vnum', '?')}\n")
                            report.write(f"   Keywords: {failure.get('keywords', 'unknown')}\n")
                            report.write(f"   Error: {failure.get('error', 'Unknown error')}\n")
                            report.write("\n")
                    else:
                        report.write("None\n\n")

                    # Shop failures
                    report.write("\nSHOP IMPORT FAILURES\n")
                    report.write("-" * 70 + "\n")
                    shop_failures = []
                    for shop_result in run_log.get('shops', []):
                        for shop in shop_result.get('shops', []):
                            if not shop.get('success'):
                                shop_failures.append(shop)

                    if shop_failures:
                        report.write(f"Total: {len(shop_failures)} failed shops\n\n")
                        for i, failure in enumerate(shop_failures, 1):
                            report.write(f"{i}. Shop {failure.get('zone_id', '?')}:{failure.get('vnum', '?')}\n")
                            report.write(f"   Keeper: {failure.get('keeper', 'unknown')}\n")
                            report.write(f"   Error: {failure.get('error', 'Unknown error')}\n")
                            report.write("\n")
                    else:
                        report.write("None\n\n")

                    # Summary by error type
                    report.write("\nFAILURE SUMMARY BY ERROR TYPE\n")
                    report.write("-" * 70 + "\n")
                    error_counts = {}
                    all_failures = reset_failures + room_failures + mob_failures + object_failures + shop_failures
                    for failure in all_failures:
                        error = failure.get('error', 'Unknown error')
                        # Simplify error message for grouping
                        if "No 'Zone' record" in error:
                            # Extract zone ID from failure to provide more specific message
                            zone_id = failure.get('zone_id', '?')
                            error_type = f'Zone {zone_id} does not exist (missing .zon file)'
                        elif 'not found' in error.lower():
                            if 'mob' in error.lower():
                                error_type = 'Mob not found (check mob import errors)'
                            elif 'room' in error.lower():
                                error_type = 'Room not found'
                            elif 'equipment' in error.lower():
                                error_type = 'Equipment object not found (check object import errors)'
                            elif 'object' in error.lower():
                                error_type = 'Object not found (check object import errors)'
                            else:
                                error_type = 'Entity not found'
                        else:
                            error_type = error[:50] + '...' if len(error) > 50 else error

                        error_counts[error_type] = error_counts.get(error_type, 0) + 1

                    for error_type, count in sorted(error_counts.items(), key=lambda x: x[1], reverse=True):
                        report.write(f"{count:4d}x {error_type}\n")

                    report.write("\n" + "=" * 70 + "\n")
                    report.write("END OF REPORT\n")

                click.echo(f"  📄 Failure report written to: {report_path}")
                click.echo(f"  Total failures documented: {len(reset_failures) + len(room_failures) + len(mob_failures) + len(object_failures) + len(shop_failures)}")

            # Seed users if requested
            if with_users and not dry_run:
                click.echo(f"\n{'='*60}")
                click.echo(f"Seeding Test Users")
                click.echo(f"{'='*60}")
                from fierylib.seeders import UserSeeder
                user_seeder = UserSeeder(prisma)
                await user_seeder.seed_users()
                click.echo(f"\n✅ Test users created!")
                click.echo(f"   Admin:   admin@muditor.dev / admin123 (GOD)")
                click.echo(f"   Builder: builder@muditor.dev / builder123 (BUILDER)")
                click.echo(f"   Player:  player@muditor.dev / player123 (PLAYER)")

        finally:
            await prisma.disconnect()

    asyncio.run(run_import())


@main.command()
@click.option(
    "--lib-path",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=lambda: os.getenv("LEGACY_LIB_PATH", "../lib"),
    help="Path to legacy CircleMUD lib directory",
)
@click.option(
    "--player",
    type=str,
    help="Import specific player only (by name)",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Parse and validate without importing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Enable verbose output",
)
def import_players(lib_path: str, player: str | None, dry_run: bool, verbose: bool):
    """Import legacy player/character files"""
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.importers.player_importer import PlayerImporter

    async def run_import():
        click.echo("FieryLib v0.1.0 - Player Data Importer")
        click.echo(f"Library path: {lib_path}")

        if player:
            click.echo(f"Importing player: {player}")
        else:
            click.echo("Importing all players")

        if dry_run:
            click.echo("DRY RUN - No database changes will be made\n")

        # Initialize Prisma
        prisma = Prisma()
        await prisma.connect()

        try:
            players_dir = Path(lib_path) / "players"

            if not players_dir.exists():
                click.echo(f"❌ Players directory not found: {players_dir}")
                return

            # Create importer
            importer = PlayerImporter(prisma)

            # Import players
            click.echo("\n" + "=" * 60)
            click.echo("Importing Players")
            click.echo("=" * 60 + "\n")

            stats = await importer.import_players_from_directory(
                players_dir=players_dir,
                player_name=player,
                dry_run=dry_run
            )

            click.echo("\n" + "=" * 60)
            click.echo("Import Complete")
            click.echo("=" * 60)
            click.echo(f"  Characters imported: {stats['characters']}")
            click.echo(f"  Skills assigned: {stats['skills']}")
            click.echo(f"  Spells assigned: {stats['spells']}")
            click.echo(f"  Aliases created: {stats['aliases']}")
            if stats['errors'] > 0:
                click.echo(f"  ⚠️  Errors: {stats['errors']}")

        finally:
            await prisma.disconnect()

    asyncio.run(run_import())


@main.command()
@click.option(
    "--lib-path",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=lambda: os.getenv("LEGACY_LIB_PATH", "../lib"),
    help="Path to legacy CircleMUD lib directory",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Parse and analyze without importing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Enable verbose output",
)
def import_mail(lib_path: str, dry_run: bool, verbose: bool):
    """Import player mail from legacy plrmail binary file"""
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.importers.mail_importer import MailImporter

    async def run_import():
        click.echo("FieryLib v0.1.0 - Mail Data Importer")
        click.echo(f"Library path: {lib_path}")

        if dry_run:
            click.echo("DRY RUN - No database changes will be made\n")

        # Find plrmail file
        mail_file = Path(lib_path) / "etc" / "plrmail"

        if not mail_file.exists():
            click.echo(f"❌ Mail file not found: {mail_file}")
            return

        click.echo(f"Mail file: {mail_file}")

        # Initialize Prisma
        prisma = Prisma()
        await prisma.connect()

        try:
            # Create importer
            importer = MailImporter(prisma)

            # Import mail
            click.echo("\n" + "=" * 60)
            click.echo("Importing Player Mail")
            click.echo("=" * 60 + "\n")

            stats = await importer.import_from_file(
                mail_file, dry_run=dry_run, verbose=verbose
            )

            click.echo("\n" + "=" * 60)
            click.echo("Import Complete")
            click.echo("=" * 60)
            click.echo(f"  Total blocks:        {stats['total_blocks']}")
            click.echo(f"  Header blocks:       {stats['header_blocks']}")
            click.echo(f"  Deleted blocks:      {stats['deleted_blocks']}")
            click.echo(f"  Messages imported:   {stats['imported']}")
            click.echo(f"  With attachments:    {stats['with_attachments']}")
            if stats['errors'] > 0:
                click.echo(f"  ⚠️  Errors: {stats['errors']}")

            if dry_run:
                click.echo(f"\n(Dry run - no database changes made)")

        finally:
            await prisma.disconnect()

    asyncio.run(run_import())


@main.command()
@click.option(
    "--triggers-dir",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=None,
    help="Path to triggers directory (default: data/triggers)",
)
@click.option(
    "--zone",
    type=int,
    help="Import triggers from specific zone only (e.g., 30 for zone 30)",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without importing to database",
)
@click.option(
    "--verbose", "-v",
    is_flag=True,
    default=False,
    help="Show detailed output",
)
@click.option(
    "--clear",
    is_flag=True,
    default=False,
    help="Clear existing triggers before import",
)
def import_triggers(triggers_dir: str | None, zone: int | None, dry_run: bool, verbose: bool, clear: bool):
    """Import Lua triggers from curated files.

    Reads .lua files from data/triggers/ directory structure:
        data/triggers/
        ├── 001/
        │   ├── 001_00_trigger.lua
        │   └── 001_01_another.lua
        └── 489/
            └── 489_02_lokari_init.lua

    Note: Use 'fierylib triggers convert-legacy' to generate these files
    from legacy DG Scripts (one-time migration).
    """
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.importers.trigger_importer import TriggerImporter

    async def run():
        click.echo("=" * 60)
        click.echo("FieryLib - Lua Trigger Importer")
        click.echo("=" * 60)

        # Resolve triggers directory
        if triggers_dir:
            trig_path = Path(triggers_dir)
        else:
            # Default to fierylib/data/triggers (go up from src/fierylib/cli.py)
            trig_path = Path(__file__).parent.parent.parent / "data" / "triggers"

        click.echo(f"Triggers directory: {trig_path.absolute()}")

        if zone:
            click.echo(f"Importing zone: {zone}")
        else:
            click.echo("Importing all triggers")

        if dry_run:
            click.echo("DRY RUN - No database changes will be made\n")

        if not trig_path.exists():
            click.echo(f"❌ Triggers directory not found: {trig_path}")
            click.echo(f"   Run 'fierylib triggers convert-legacy' to generate Lua files")
            return

        prisma = Prisma()
        await prisma.connect()

        try:
            importer = TriggerImporter(prisma)

            # Clear existing triggers if requested
            if clear and not dry_run:
                click.echo("\nClearing existing triggers...")
                deleted = await importer.clear_all_triggers()
                click.echo(f"  ✅ Deleted {deleted} triggers")

            # Import triggers from Lua files
            result = await importer.import_from_lua_directory(
                trig_path,
                dry_run=dry_run,
                verbose=verbose,
                zone=zone,
            )

            click.echo(f"\n{'='*60}")
            click.echo("Import Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Zones:         {result.get('total_zones', 0)}")
            click.echo(f"  Triggers:      {result['total']}")
            click.echo(f"  Created:       {result.get('imported', 0)}")
            click.echo(f"  Updated:       {result.get('updated', 0)}")
            click.echo(f"  Failed:        {result['failed']}")

            if result.get("errors"):
                click.echo(f"\n  Errors:")
                for err in result["errors"][:10]:
                    click.echo(f"    {err['file']}: {err['error']}")
                if len(result["errors"]) > 10:
                    click.echo(f"    ... and {len(result['errors']) - 10} more")

            if verbose:
                # Show breakdown by type
                stats = await importer.get_trigger_stats()
                click.echo(f"\n  By Type:")
                for ttype, count in stats["by_type"].items():
                    click.echo(f"    {ttype}: {count}")

            if dry_run:
                click.echo(f"\n(Dry run - no database changes made)")

        finally:
            await prisma.disconnect()

    asyncio.run(run())


@main.command()
@click.option(
    "--lib-path",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=lambda: os.getenv("LEGACY_LIB_PATH", "../lib"),
    help="Path to legacy CircleMUD lib directory",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without making database changes",
)
@click.option(
    "--verbose", "-v",
    is_flag=True,
    default=False,
    help="Show detailed output",
)
def link_triggers(lib_path: str, dry_run: bool, verbose: bool):
    """Link mobs and objects to triggers via junction tables.

    Parses "T <trigger_vnum>" lines from .mob and .obj files and creates
    the proper many-to-many relationships in the MobTriggers and ObjectTriggers tables.
    In DG Scripts, triggers can be shared across multiple entities.
    """
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.importers.mob_trigger_linker import MobTriggerLinker
    from fierylib.importers.object_trigger_linker import ObjectTriggerLinker

    async def run():
        click.echo("=" * 60)
        click.echo("FieryLib - Trigger Linker")
        click.echo("=" * 60)
        click.echo(f"Library path: {lib_path}")

        if dry_run:
            click.echo("DRY RUN - No database changes will be made\n")

        prisma = Prisma()
        await prisma.connect()

        try:
            world_dir = Path(lib_path) / "world"

            # Link mob triggers
            click.echo(f"\n--- Linking Mob Triggers ---")
            mob_linker = MobTriggerLinker(prisma)
            mob_result = await mob_linker.link_mob_triggers(world_dir, dry_run=dry_run, verbose=verbose)

            click.echo(f"\nMob Trigger Results:")
            click.echo(f"  Mobs processed:  {mob_result.get('mobs_processed', 0)}")
            click.echo(f"  Links created:   {mob_result.get('links_created', 0)}")
            click.echo(f"  Links skipped:   {mob_result.get('links_skipped', 0)}")

            if mob_result.get("errors"):
                click.echo(f"  Errors:          {len(mob_result['errors'])}")
                if verbose:
                    for error in mob_result["errors"][:10]:
                        click.echo(f"    - {error}")
                    if len(mob_result["errors"]) > 10:
                        click.echo(f"    ... and {len(mob_result['errors']) - 10} more")

            # Link object triggers
            click.echo(f"\n--- Linking Object Triggers ---")
            obj_linker = ObjectTriggerLinker(prisma)
            obj_result = await obj_linker.link_object_triggers(world_dir, dry_run=dry_run, verbose=verbose)

            click.echo(f"\nObject Trigger Results:")
            click.echo(f"  Objects processed: {obj_result.get('objects_processed', 0)}")
            click.echo(f"  Links created:     {obj_result.get('links_created', 0)}")
            click.echo(f"  Links skipped:     {obj_result.get('links_skipped', 0)}")

            if obj_result.get("errors"):
                click.echo(f"  Errors:            {len(obj_result['errors'])}")
                if verbose:
                    for error in obj_result["errors"][:10]:
                        click.echo(f"    - {error}")
                    if len(obj_result["errors"]) > 10:
                        click.echo(f"    ... and {len(obj_result['errors']) - 10} more")

            if dry_run:
                click.echo(f"\n(Dry run - no database changes made)")

        finally:
            await prisma.disconnect()

    asyncio.run(run())


@main.command()
@click.option(
    "--boards-dir",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=None,
    help="Path to boards directory (default: fierymud/legacy/lib/etc/boards/)",
)
@click.option(
    "--verbose", "-v",
    is_flag=True,
    default=False,
    help="Show detailed output",
)
@click.option(
    "--clear",
    is_flag=True,
    default=False,
    help="Clear existing board data before import",
)
def import_boards(boards_dir: str | None, verbose: bool, clear: bool):
    """Import bulletin boards from legacy board files.

    Parses .brd files from the boards directory and imports:
    - Board definitions (alias, title, privileges)
    - Messages with poster info, timestamps, and content
    - Edit history for messages

    Boards are linked to ITEM_BOARD objects via values.value0 = board.id
    """
    import asyncio
    from pathlib import Path
    from fierylib.importers.board_importer import import_boards as do_import_boards

    # Default boards directory
    if boards_dir is None:
        default_paths = [
            Path("/home/strider/Code/mud/fierymud/legacy/lib/etc/boards"),
            Path("../fierymud/legacy/lib/etc/boards"),
        ]
        for p in default_paths:
            if p.exists():
                boards_dir = str(p)
                break

    if boards_dir is None:
        click.echo("Error: Could not find boards directory. Please specify --boards-dir")
        return

    async def run():
        click.echo("=" * 60)
        click.echo("Importing Bulletin Boards")
        click.echo("=" * 60)

        stats = await do_import_boards(
            Path(boards_dir), verbose, clear
        )

        click.echo("\n" + "=" * 60)
        click.echo("Import Summary")
        click.echo("=" * 60)
        click.echo(f"  Boards created:   {stats['boards_created']}")
        click.echo(f"  Boards updated:   {stats['boards_updated']}")
        click.echo(f"  Messages created: {stats['messages_created']}")
        click.echo(f"  Messages skipped: {stats['messages_skipped']}")
        click.echo(f"  Edits created:    {stats['edits_created']}")
        if stats['errors'] > 0:
            click.echo(f"  Errors:           {stats['errors']}")
        else:
            click.echo(f"  Errors:           0")
        click.echo("\nImport complete!")

    asyncio.run(run())


@main.command()
@click.option(
    "--lib-path",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=lambda: os.getenv("LEGACY_LIB_PATH", "../lib"),
    help="Path to legacy CircleMUD lib directory",
)
@click.option(
    "--zone",
    type=int,
    help="Validate specific zone only",
)
def validate(lib_path: str, zone: int | None):
    """Validate legacy data files without importing"""
    click.echo(f"Validating legacy data in: {lib_path}")

    if zone:
        click.echo(f"Zone: {zone}")
    else:
        click.echo("All zones")

    # TODO: Implement validation logic
    click.echo("Validation functionality not yet implemented")


@main.command()
def init_db():
    """Initialize database schema using Prisma"""
    click.echo("Initializing database schema...")

    # TODO: Run prisma migrate or prisma db push
    click.echo("Database initialization not yet implemented")
    click.echo("Hint: Run 'prisma db push' manually for now")


@main.command()
@click.option(
    "--force",
    is_flag=True,
    default=True,
    help="Do not prompt for confirmation (default: true)",
)
@click.option(
    "--skip-generate",
    is_flag=True,
    default=False,
    help="Skip running generators during reset; will run db push + generate afterwards",
)
@click.option(
    "--seed-users",
    is_flag=True,
    default=False,
    help="Seed default users after reset",
)
def reset_db(force: bool, skip_generate: bool, seed_users: bool):
    """Completely reset the database and bring it up to date (schema + clients)."""
    click.echo("Resetting database...")

    def run(cmd: list[str]) -> tuple[int, str, str]:
        proc = subprocess.run(cmd, capture_output=True, text=True)
        if proc.stdout:
            click.echo(proc.stdout.strip())
        if proc.stderr:
            click.echo(proc.stderr.strip())
        return proc.returncode, proc.stdout, proc.stderr

    # 1) prisma migrate reset
    reset_cmd = ["prisma", "migrate", "reset"]
    if force:
        reset_cmd.append("--force")
    if skip_generate:
        reset_cmd.append("--skip-generate")

    code, _out, err = run(reset_cmd)

    # 2) If generator failed, perform safe fallback
    if code != 0:
        needs_py_gen = "prisma-client-py: not found" in (err or "")
        if not skip_generate and needs_py_gen:
            click.echo("Falling back to --skip-generate followed by db push + generate...")
            run(["prisma", "migrate", "reset", "--force", "--skip-generate"])  # ignore code
            run(["prisma", "db", "push"])  # sync schema
            run(["prisma", "generate"])     # generate clients
        else:
            click.echo("Reset command failed; attempting db push + generate to sync schema...")
            run(["prisma", "db", "push"])  # sync schema
            run(["prisma", "generate"])     # generate clients
    else:
        # 3) If we skipped generation, finish with push + generate
        if skip_generate:
            run(["prisma", "db", "push"])  # ensure schema up to date
            run(["prisma", "generate"])     # generate clients

    click.echo("✅ Database reset complete and schema is up to date.")

    # 4) Optional: seed users
    if seed_users:
        click.echo("\nSeeding users...")
        import asyncio
        from prisma import Prisma
        from fierylib.seeders import UserSeeder

        async def run_seed():
            prisma = Prisma()
            await prisma.connect()
            try:
                seeder = UserSeeder(prisma)
                await seeder.seed_users(skip_existing=False)
            finally:
                await prisma.disconnect()

        asyncio.run(run_seed())
        click.echo("✅ Users seeded.")


@main.group()
def seed():
    """Database seeding commands"""
    pass


@seed.command(name="all")
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Enable verbose output",
)
@click.option(
    "--with-users",
    is_flag=True,
    default=False,
    help="Also seed test users after other seeds",
)
def seed_all(verbose: bool, with_users: bool):
    """Run all seeders in the correct order"""
    import asyncio
    from pathlib import Path
    from prisma import Prisma

    async def run_all_seeds():
        click.echo("🌱 Running All Seeders")
        click.echo("=" * 60)

        prisma = Prisma()
        await prisma.connect()

        try:
            # 1. Skills and Spells (must be first - other things depend on these)
            click.echo("\n[1/8] Seeding spells and skills...")
            from fierylib.seeders.skill_seeder import SkillSeeder
            skill_seeder = SkillSeeder(prisma)
            await skill_seeder.seed_spells()
            await skill_seeder.seed_skills()
            click.echo("  ✅ Spells and skills seeded")

            # 2. Classes (depends on skills)
            click.echo("\n[2/8] Seeding classes...")
            from fierylib.importers.class_importer_v2 import ClassImporterV2
            classes_json = Path("data/classes.json")
            if classes_json.exists():
                class_importer = ClassImporterV2(prisma)
                await class_importer.import_from_json(classes_json)
                click.echo("  ✅ Classes seeded")
            else:
                click.echo("  ⚠️  data/classes.json not found, skipping")

            # 3. Races
            click.echo("\n[3/8] Seeding races...")
            from fierylib.importers.race_importer import import_races_from_json
            races_json = Path("data/races.json")
            if races_json.exists():
                await import_races_from_json(races_json)
                click.echo("  ✅ Races seeded")
            else:
                click.echo("  ⚠️  data/races.json not found, skipping")

            # 4. Liquids
            click.echo("\n[4/8] Seeding liquids...")
            from fierylib.seeders.liquid_seeder import LIQUID_DATA
            liquid_count = 0
            for alias, name, color_desc, drunk, hunger, thirst in LIQUID_DATA:
                await prisma.liquid.upsert(
                    where={"alias": alias},
                    data={
                        "create": {
                            "name": name,
                            "alias": alias,
                            "colorDesc": color_desc,
                            "drunkEffect": drunk,
                            "hungerEffect": hunger,
                            "thirstEffect": thirst,
                        },
                        "update": {
                            "name": name,
                            "colorDesc": color_desc,
                            "drunkEffect": drunk,
                            "hungerEffect": hunger,
                            "thirstEffect": thirst,
                        },
                    },
                )
                liquid_count += 1
            click.echo(f"  ✅ Liquids seeded: {liquid_count} total")

            # 5. Effects
            click.echo("\n[5/8] Seeding effects...")
            from fierylib.seeders.effects_seeder import EffectsSeeder
            effects_seeder = EffectsSeeder(prisma)
            await effects_seeder.seed_toolbox_categories(dry_run=False, verbose=verbose)
            effect_stats = await effects_seeder.seed(dry_run=False, verbose=verbose)
            click.echo(f"  ✅ Effects seeded: {effect_stats.get('created', 0)} created, {effect_stats.get('updated', 0)} updated")

            # 6. Magic System (ability metadata)
            click.echo("\n[6/8] Seeding magic system...")
            from fierylib.importers.magic_system_importer import import_magic_system
            magic_result = await import_magic_system(verbose=verbose)
            magic_stats = magic_result['stats']
            click.echo(f"  ✅ Magic system seeded: {magic_stats.get('abilities_created', 0)} created, {magic_stats.get('abilities_updated', 0)} updated")

            # 7. Ability Effects (links abilities to effects)
            click.echo("\n[7/8] Linking abilities to effects...")
            from fierylib.seeders.abilities_seeder import AbilitiesSeeder
            abilities_seeder = AbilitiesSeeder(prisma)
            ae_stats = await abilities_seeder.link_ability_effects(dry_run=False, verbose=verbose)
            click.echo(f"  ✅ Ability effects linked: {ae_stats.get('effects_created', 0)} links created")

            # 8. Socials
            click.echo("\n[8/8] Seeding socials...")
            from fierylib.seeders.socials_seeder import SocialsSeeder
            lib_path = Path(os.getenv("LEGACY_LIB_PATH", "../fierymud/legacy/lib"))
            socials_file = lib_path / "misc" / "socials"
            if socials_file.exists():
                socials_seeder = SocialsSeeder(prisma)
                await socials_seeder.clear_socials()
                social_stats = await socials_seeder.seed_socials(lib_path, verbose=verbose)
                click.echo(f"  ✅ Socials seeded: {social_stats.get('imported', 0)} imported")
            else:
                click.echo(f"  ⚠️  Socials file not found at {socials_file}, skipping")

            # Optional: Users
            if with_users:
                click.echo("\n[+] Seeding test users...")
                from fierylib.seeders import UserSeeder
                user_seeder = UserSeeder(prisma)
                await user_seeder.seed_users(skip_existing=True)
                click.echo("  ✅ Test users seeded")

            click.echo("\n" + "=" * 60)
            click.echo("✅ All seeders complete!")
            click.echo("=" * 60)

        finally:
            await prisma.disconnect()

    asyncio.run(run_all_seeds())


@seed.command(name="users")
@click.option(
    "--reset",
    is_flag=True,
    default=False,
    help="Reset passwords for existing users",
)
def seed_users(reset: bool):
    """Seed test users (admin, builder, testplayer)"""
    import asyncio
    from prisma import Prisma
    from fierylib.seeders import UserSeeder

    async def run_seed():
        click.echo("🌱 Seeding Test Users")
        click.echo("=" * 60)

        prisma = Prisma()
        await prisma.connect()

        try:
            user_seeder = UserSeeder(prisma)
            result = await user_seeder.seed_users(skip_existing=not reset)

            click.echo("\n✅ User seeding complete!")
            click.echo(f"\nCredentials:")
            click.echo(f"  Admin (GOD):      admin@muditor.dev / admin123")
            click.echo(f"  Builder (BUILDER): builder@muditor.dev / builder123")
            click.echo(f"  Player (PLAYER):   player@muditor.dev / player123")

            if reset:
                click.echo(f"\n⚠️  Passwords have been reset!")
        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="classes")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without importing to database",
)
@click.option(
    "--regenerate",
    is_flag=True,
    default=False,
    help="Regenerate data/classes.json from class.cpp before importing",
)
def seed_classes(dry_run: bool, regenerate: bool):
    """Import class data from data/classes.json"""
    import asyncio
    from pathlib import Path
    from fierylib.importers.class_importer_v2 import ClassImporterV2
    from fierylib.parsers.cpp_class_parser import parse_classes_cpp
    import json

    async def run_seed():
        click.echo("🌱 Seeding Class Data")
        click.echo("=" * 60)

        classes_json = Path("data/classes.json")

        # Regenerate from C++ if requested
        if regenerate:
            click.echo("Regenerating data/classes.json from class.cpp...")
            class_cpp = Path("../fierymud/legacy/src/class.cpp")
            if not class_cpp.exists():
                click.echo(f"❌ class.cpp not found at {class_cpp}")
                return

            data = parse_classes_cpp(class_cpp)
            classes_json.parent.mkdir(exist_ok=True)
            with classes_json.open('w') as f:
                json.dump(data, f, indent=2)
            click.echo(f"✓ Generated {classes_json}")

        if not classes_json.exists():
            click.echo(f"❌ Class data file not found: {classes_json}")
            click.echo("   Run with --regenerate to create it from class.cpp")
            return

        from prisma import Prisma
        prisma = Prisma()
        await prisma.connect()

        try:
            importer = ClassImporterV2(prisma)
            stats = await importer.import_from_json(classes_json, dry_run=dry_run)

            click.echo("\n✅ Class seeding complete!")
            click.echo(f"   Classes created: {stats['classes_created']}")
            click.echo(f"   Classes skipped: {stats['classes_skipped']}")
            if dry_run:
                click.echo("   (DRY RUN - no changes made)")
        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="races")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without importing to database",
)
@click.option(
    "--regenerate",
    is_flag=True,
    default=False,
    help="Regenerate data/races.json from races.cpp before importing",
)
def seed_races(dry_run: bool, regenerate: bool):
    """Import race data from data/races.json"""
    import asyncio
    from pathlib import Path
    from fierylib.importers.race_importer import import_races_from_json
    from fierylib.parsers.cpp_race_parser import parse_races_cpp
    import json

    async def run_seed():
        click.echo("🌱 Seeding Race Data")
        click.echo("=" * 60)

        races_json = Path("data/races.json")

        # Regenerate from C++ if requested
        if regenerate:
            click.echo("Regenerating data/races.json from races.cpp...")
            races_cpp = Path("../fierymud/legacy/src/races.cpp")
            if not races_cpp.exists():
                click.echo(f"❌ races.cpp not found at {races_cpp}")
                return

            data = parse_races_cpp(races_cpp)
            races_json.parent.mkdir(exist_ok=True)
            with races_json.open('w') as f:
                json.dump(data, f, indent=2)
            click.echo(f"✓ Generated {races_json}")

        if not races_json.exists():
            click.echo(f"❌ Race data file not found: {races_json}")
            click.echo("   Run with --regenerate to create it from races.cpp")
            return

        _stats = await import_races_from_json(races_json, dry_run=dry_run)

        click.echo("\n✅ Race seeding complete!")
        if dry_run:
            click.echo("   (DRY RUN - no changes made)")

    asyncio.run(run_seed())


@seed.command(name="liquids")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without importing to database",
)
def seed_liquids(dry_run: bool):
    """Seed liquid types for drink containers.

    Imports the 42 liquid types from legacy FieryMUD including:
    - Name and alias for each liquid
    - Color description (for unidentified containers)
    - Drunk, hunger, and thirst effects per sip
    """
    import asyncio
    from prisma import Prisma
    from fierylib.seeders.liquid_seeder import LIQUID_DATA

    async def run_seed():
        click.echo("🥤 Seeding Liquid Types")
        click.echo("=" * 60)

        if dry_run:
            click.echo("DRY RUN - No changes will be made\n")
            for i, (alias, name, color, drunk, hunger, thirst) in enumerate(LIQUID_DATA):
                alcoholic = "yes" if drunk > 0 else "no"
                click.echo(f"  {i:2d}. {name:<20s} | {color:<20s} | alc={alcoholic}")
            click.echo(f"\n  Total: {len(LIQUID_DATA)} liquid types")
            return

        prisma = Prisma()
        await prisma.connect()

        try:
            created = 0

            for alias, name, color_desc, drunk, hunger, thirst in LIQUID_DATA:
                await prisma.liquid.upsert(
                    where={"alias": alias},
                    data={
                        "create": {
                            "name": name,
                            "alias": alias,
                            "colorDesc": color_desc,
                            "drunkEffect": drunk,
                            "hungerEffect": hunger,
                            "thirstEffect": thirst,
                        },
                        "update": {
                            "name": name,
                            "colorDesc": color_desc,
                            "drunkEffect": drunk,
                            "hungerEffect": hunger,
                            "thirstEffect": thirst,
                        },
                    },
                )
                created += 1

            click.echo(f"\n✅ Seeded {created} liquid types")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="abilities")
def seed_abilities_deprecated():
    """[DEPRECATED] Use 'seed magic-system' or 'import-legacy' instead.

    The JSON-based abilities seeder has been removed because the
    all_spell_implementations.json file contained incorrect data.

    Abilities are now seeded via:
    - 'fierylib import-legacy' - imports from legacy lib/ files
    - 'fierylib seed magic-system' - imports from data/*.json files
    """
    click.echo("❌ This command has been deprecated.")
    click.echo("")
    click.echo("The all_spell_implementations.json file was removed because it")
    click.echo("contained incorrect damage type mappings.")
    click.echo("")
    click.echo("Use one of these alternatives instead:")
    click.echo("  fierylib import-legacy     - Import from legacy lib/ files")
    click.echo("  fierylib seed magic-system - Import from data/*.json files")
    click.echo("")
    click.echo("The authoritative source for ability metadata is now:")
    click.echo("  docs/extraction-reports/abilities.csv (from skills.cpp)")


@seed.command(name="skills")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without importing to database",
)
def seed_skills(dry_run: bool):
    """Import skills from legacy codebase (if skill seeder exists)"""
    import asyncio
    from pathlib import Path

    click.echo("🌱 Seeding Skills")
    click.echo("=" * 60)
    click.echo("⚠️  Skill seeder not yet implemented")
    click.echo("   Skills should be imported from skills.cpp similar to classes/races")


@seed.command(name="effects")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Preview effects without importing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
def seed_effects(dry_run: bool, verbose: bool):
    """Seed the 18 consolidated parameterized effects from data/effects.json.

    Creates reusable effects that spells and abilities can link to:
    - Combat: damage (instant/DoT/chain/lifesteal), heal, modify (all stat mods)
    - Status: status (simple/CC/stealth/detection/resistance/reflect)
    - Utility: cleanse, dispel, reveal, globe
    - Movement: teleport, extract, move, interrupt
    - Creation: create, summon, resurrect
    - Transform: transform (shapechange), enchant (apply to objects)
    - Room: room (effects + barriers)
    """
    import asyncio
    from prisma import Prisma
    from fierylib.seeders.effects_seeder import EffectsSeeder

    async def run_seed():
        click.echo("🌱 Seeding Magic System Effects")
        click.echo("=" * 60)

        if dry_run:
            click.echo("DRY RUN - No database changes will be made\n")

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = EffectsSeeder(prisma)

            # Seed toolbox categories first (builds the category mapping)
            click.echo("\n📁 Seeding Toolbox Categories...")
            cat_stats = await seeder.seed_toolbox_categories(dry_run=dry_run, verbose=verbose)
            if not dry_run:
                click.echo(f"   Categories: {cat_stats['created']} created, {cat_stats['updated']} updated")

            # Seed effects (uses category mapping from above)
            click.echo("\n📦 Seeding Effects...")
            stats = await seeder.seed(dry_run=dry_run, verbose=verbose)

            # Summary
            click.echo(f"\n{'='*60}")
            click.echo("Seeding Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Toolbox Categories:")
            click.echo(f"    Created:  {cat_stats['created']}")
            click.echo(f"    Updated:  {cat_stats['updated']}")
            click.echo(f"  Effects:")
            click.echo(f"    Total:    {stats['total']}")
            click.echo(f"    Created:  {stats['created']}")
            click.echo(f"    Updated:  {stats['updated']}")
            click.echo(f"    Skipped:  {stats['skipped']}")

            if stats['errors'] > 0:
                click.echo(f"    Errors:   {stats['errors']} ⚠️")
            else:
                click.echo(f"    Errors:   0 ✅")

            if dry_run:
                click.echo(f"\n(Dry run - no database changes made)")
            else:
                click.echo(f"\n✅ Effects seeding complete!")

            # Show categories breakdown
            click.echo(f"\n📚 Consolidated 18 Effects:")
            click.echo(f"   Combat (3):     damage, heal, modify")
            click.echo(f"   Status (1):     status (simple/CC/stealth/detect/resist/reflect)")
            click.echo(f"   Utility (4):    cleanse, dispel, reveal, globe")
            click.echo(f"   Movement (4):   teleport, extract, move, interrupt")
            click.echo(f"   Creation (3):   create, summon, resurrect")
            click.echo(f"   Transform (2):  transform, enchant")
            click.echo(f"   Room (1):       room (effects + barriers)")

        except Exception as e:
            click.echo(f"❌ Error: {e}")
            if verbose:
                import traceback
                traceback.print_exc()
        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="magic-system")
@click.option(
    "--verbose", "-v",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
@click.option(
    "--data-dir",
    type=click.Path(exists=True),
    default=None,
    help="Path to data directory containing effects.json and abilities.json",
)
def seed_magic_system(verbose: bool, data_dir: str | None):
    """Import effects and abilities from JSON files.

    This is the primary way to seed the magic system. It reads from:
    - data/effects.json - 18 consolidated parameterized effect definitions
    - data/abilities.json - All abilities with their effect links
    - data/forms.json - Transform form templates (optional)

    The JSON files are the source of truth for the magic system.
    """
    import asyncio
    from pathlib import Path
    from fierylib.importers.magic_system_importer import import_magic_system

    async def run():
        click.echo("=" * 60)
        click.echo("Importing Magic System from JSON")
        click.echo("=" * 60)

        path = Path(data_dir) if data_dir else None
        result = await import_magic_system(data_dir=path, verbose=verbose)
        stats = result['stats']
        warnings = result['warnings']

        click.echo("\n" + "=" * 60)
        click.echo("Import Summary")
        click.echo("=" * 60)
        click.echo(f"  Effects created:     {stats['effects_created']}")
        click.echo(f"  Effects updated:     {stats['effects_updated']}")
        click.echo(f"  Abilities created:   {stats['abilities_created']}")
        click.echo(f"  Abilities updated:   {stats['abilities_updated']}")
        click.echo(f"  Effect links:        {stats['effect_links_created']}")
        if stats['errors'] > 0:
            click.echo(f"  Errors:              {stats['errors']} ⚠️")
        else:
            click.echo(f"  Errors:              0 ✅")

        if warnings:
            click.echo(f"\n  Warnings:            {len(warnings)} ⚠️")
            click.echo("  Missing effects referenced by abilities:")
            for warning in warnings:
                click.echo(f"    - {warning}")

        click.echo("\n✅ Import complete!")

    asyncio.run(run())


@seed.command(name="ability-descriptions")
@click.option(
    "--verbose", "-v",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Show what would change without updating",
)
@click.option(
    "--help-dir",
    type=click.Path(exists=True),
    default=None,
    help="Path to help files directory (default: fierymud/legacy/lib/text/help/)",
)
def seed_ability_descriptions(verbose: bool, dry_run: bool, help_dir: str | None):
    """Update ability descriptions from help files.

    Parses CircleMUD help files (.hlp) and updates ability descriptions
    in the database with the matching help text.

    Also updates sphere information if available in help entries.
    """
    import asyncio
    from pathlib import Path
    from fierylib.importers.magic_system_importer import update_descriptions_from_help_files

    # Default help directory
    if help_dir is None:
        # Try to find fierymud help directory
        default_paths = [
            Path("/home/strider/Code/mud/fierymud/legacy/lib/text/help"),
            Path("../fierymud/legacy/lib/text/help"),
        ]
        for p in default_paths:
            if p.exists():
                help_dir = str(p)
                break

    if help_dir is None:
        click.echo("Error: Could not find help directory. Please specify --help-dir")
        return

    async def run():
        click.echo("=" * 60)
        click.echo("Updating Ability Descriptions from Help Files")
        click.echo("=" * 60)

        if dry_run:
            click.echo("\n*** DRY RUN - No changes will be made ***\n")

        stats = await update_descriptions_from_help_files(
            Path(help_dir), verbose, dry_run
        )

        click.echo("\n" + "=" * 60)
        click.echo("Update Summary")
        click.echo("=" * 60)
        click.echo(f"  Matched:         {stats['matched']}")
        click.echo(f"  Updated:         {stats['updated']}")
        click.echo(f"  No match found:  {stats['skipped_no_match']}")
        click.echo(f"  Same/no change:  {stats['skipped_same']}")
        if stats['errors'] > 0:
            click.echo(f"  Errors:          {stats['errors']} ⚠️")
        else:
            click.echo(f"  Errors:          0 ✅")
        click.echo("\n✅ Update complete!")

    asyncio.run(run())


@seed.command(name="help-entries")
@click.option(
    "--verbose", "-v",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
@click.option(
    "--clear",
    is_flag=True,
    default=False,
    help="Clear existing help entries before import",
)
@click.option(
    "--help-dir",
    type=click.Path(exists=True),
    default=None,
    help="Path to help files directory (default: fierymud/legacy/lib/text/help/)",
)
def seed_help_entries(verbose: bool, clear: bool, help_dir: str | None):
    """Import help entries from CircleMUD help files.

    Parses all .hlp files and imports them into the HelpEntry table.
    These can then be viewed and edited in Muditor.
    """
    import asyncio
    from pathlib import Path
    from fierylib.importers.help_importer import import_help_entries

    # Default help directory
    if help_dir is None:
        default_paths = [
            Path("/home/strider/Code/mud/fierymud/legacy/lib/text/help"),
            Path("../fierymud/legacy/lib/text/help"),
        ]
        for p in default_paths:
            if p.exists():
                help_dir = str(p)
                break

    if help_dir is None:
        click.echo("Error: Could not find help directory. Please specify --help-dir")
        return

    async def run():
        click.echo("=" * 60)
        click.echo("Importing Help Entries from Help Files")
        click.echo("=" * 60)

        stats = await import_help_entries(
            Path(help_dir), verbose, clear
        )

        click.echo("\n" + "=" * 60)
        click.echo("Import Summary")
        click.echo("=" * 60)
        click.echo(f"  Created:  {stats['created']}")
        click.echo(f"  Updated:  {stats['updated']}")
        if stats['errors'] > 0:
            click.echo(f"  Errors:   {stats['errors']} ⚠️")
        else:
            click.echo(f"  Errors:   0 ✅")
        click.echo("\n✅ Import complete!")

    asyncio.run(run())


@seed.command(name="ability-effects")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Preview links without writing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress for each ability",
)
def seed_ability_effects(dry_run: bool, verbose: bool):
    """Link abilities to their effects from data/abilities.json.

    Creates AbilityEffect records linking abilities to their parameterized
    effects based on the effects array in abilities.json.

    Each effect entry has: effect (name), order, params, trigger.
    """
    import asyncio
    from prisma import Prisma
    from fierylib.seeders.abilities_seeder import AbilitiesSeeder, load_abilities_from_json

    async def run_link():
        abilities_data = load_abilities_from_json()
        abilities_with_effects = sum(1 for a in abilities_data if a.get("effects"))

        click.echo("🔗 Linking Abilities to Effects")
        click.echo("=" * 60)
        click.echo(f"  Found {len(abilities_data)} abilities ({abilities_with_effects} with effects)")

        if dry_run:
            click.echo("\nDRY RUN - No database changes will be made\n")

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = AbilitiesSeeder(prisma)
            stats = await seeder.link_ability_effects(dry_run=dry_run, verbose=verbose)

            # Summary
            click.echo(f"\n{'='*60}")
            click.echo("Linking Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Abilities linked:   {stats['linked']}")
            click.echo(f"  Effects created:    {stats['effects_created']}")
            click.echo(f"  Skipped (no fx):    {stats['skipped']}")
            click.echo(f"  Errors:             {stats['errors']}")

            if dry_run:
                click.echo(f"\n(Dry run - no database changes made)")
            else:
                click.echo(f"\n✅ Ability effects linking complete!")

        except Exception as e:
            click.echo(f"❌ Error: {e}")
            if verbose:
                import traceback
                traceback.print_exc()
        finally:
            await prisma.disconnect()

    asyncio.run(run_link())


@seed.command(name="config")
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
def seed_config(verbose: bool):
    """Seed game configuration values.

    Creates all GameConfig entries with default values based on
    constants from the FieryMUD C++ codebase. These values can be
    edited via Muditor's admin interface.

    Categories: server, security, timing, combat, progression, character
    """
    import asyncio
    from prisma import Prisma
    from fierylib.seeders import ConfigSeeder

    async def run_seed():
        click.echo("🌱 Seeding Game Configuration")
        click.echo("=" * 60)

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = ConfigSeeder(prisma)
            stats = await seeder.seed_all(verbose=verbose)

            click.echo(f"\n{'='*60}")
            click.echo("Configuration Seeding Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Server:      {stats['server']} configs")
            click.echo(f"  Security:    {stats['security']} configs")
            click.echo(f"  Timing:      {stats['timing']} configs")
            click.echo(f"  Combat:      {stats['combat']} configs")
            click.echo(f"  Progression: {stats['progression']} configs")
            click.echo(f"  Character:   {stats['character']} configs")
            click.echo(f"  ─────────────────────────────")
            click.echo(f"  Total:       {stats['total']} configs")
            click.echo(f"\n✅ Configuration seeding complete!")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="levels")
@click.option(
    "--max-level",
    type=int,
    default=105,
    help="Maximum level to seed (default: 105)",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
def seed_levels(max_level: int, verbose: bool):
    """Seed level definitions.

    Creates LevelDefinition entries for all levels with:
    - Experience requirements (using level^2.5 * 1000 formula)
    - HP/Mana/Movement gains per level
    - Immortal flags and permissions for levels 100+

    Immortal hierarchy:
      100: Avatar (LVL_IMMORT)
      101: Demi-God (LVL_GOD)
      102: Lesser God (LVL_GRGOD)
      103: Greater God (LVL_HEAD_B)
      104: Implementer (LVL_HEAD_C)
      105: Overlord (LVL_IMPL)
    """
    import asyncio
    from prisma import Prisma
    from fierylib.seeders import LevelSeeder

    async def run_seed():
        click.echo("🌱 Seeding Level Definitions")
        click.echo("=" * 60)
        click.echo(f"  Maximum level: {max_level}")

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = LevelSeeder(prisma)
            stats = await seeder.seed_levels(max_level=max_level, verbose=verbose)

            click.echo(f"\n{'='*60}")
            click.echo("Level Seeding Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Created:  {stats['created']}")
            click.echo(f"  Updated:  {stats['updated']}")
            click.echo(f"  Total:    {stats['total']}")
            click.echo(f"\n✅ Level seeding complete!")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="text")
@click.option(
    "--text-dir",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=None,
    help="Path to text directory to import from (optional)",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
def seed_text(text_dir: str | None, verbose: bool):
    """Seed system text and login messages.

    Creates SystemText entries for:
    - MOTD (Message of the Day)
    - Immortal MOTD
    - News, Credits, Policies, Background

    Creates LoginMessage entries for:
    - Welcome banner
    - Login prompts
    - Character creation flow

    Optionally imports from a text directory (e.g., fierymud/data/text/).
    """
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.seeders import TextSeeder

    async def run_seed():
        click.echo("🌱 Seeding System Text & Login Messages")
        click.echo("=" * 60)

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = TextSeeder(prisma)

            # Seed defaults
            stats = await seeder.seed_all(verbose=verbose)

            # Optionally import from directory
            if text_dir:
                click.echo(f"\n  Importing from: {text_dir}")
                import_stats = await seeder.import_from_directory(
                    Path(text_dir), verbose=verbose
                )
                stats["imported"] = import_stats["imported"]
                stats["skipped"] = import_stats["skipped"]

            click.echo(f"\n{'='*60}")
            click.echo("Text Seeding Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  System text:    {stats['system_text']}")
            click.echo(f"  Login messages: {stats['login_messages']}")
            if text_dir:
                click.echo(f"  Imported:       {stats.get('imported', 0)}")
                click.echo(f"  Skipped:        {stats.get('skipped', 0)}")
            click.echo(f"  ─────────────────────────────")
            click.echo(f"  Total:          {stats['total']}")
            click.echo(f"\n✅ Text seeding complete!")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="game-settings")
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
def seed_game_settings(verbose: bool):
    """Seed all game settings (config + levels + text).

    This is a convenience command that runs:
    - seed config
    - seed levels
    - seed text

    Use this for initial database setup.
    """
    import asyncio
    from prisma import Prisma
    from fierylib.seeders import ConfigSeeder, LevelSeeder, TextSeeder

    async def run_seed():
        click.echo("🌱 Seeding All Game Settings")
        click.echo("=" * 60)

        prisma = Prisma()
        await prisma.connect()

        try:
            # Config
            click.echo("\n📋 Game Configuration")
            click.echo("-" * 40)
            config_seeder = ConfigSeeder(prisma)
            config_stats = await config_seeder.seed_all(verbose=verbose)

            # Levels
            click.echo("\n📊 Level Definitions")
            click.echo("-" * 40)
            level_seeder = LevelSeeder(prisma)
            level_stats = await level_seeder.seed_levels(verbose=verbose)

            # Text
            click.echo("\n📝 System Text & Login Messages")
            click.echo("-" * 40)
            text_seeder = TextSeeder(prisma)
            text_stats = await text_seeder.seed_all(verbose=verbose)

            click.echo(f"\n{'='*60}")
            click.echo("Game Settings Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Config entries:  {config_stats['total']}")
            click.echo(f"  Level entries:   {level_stats['total']}")
            click.echo(f"  Text entries:    {text_stats['total']}")
            click.echo(f"  ─────────────────────────────")
            total = config_stats['total'] + level_stats['total'] + text_stats['total']
            click.echo(f"  Total:           {total}")
            click.echo(f"\n✅ All game settings seeded!")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="socials")
@click.option(
    "--lib-path",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=lambda: os.getenv("LEGACY_LIB_PATH", "../lib"),
    help="Path to legacy CircleMUD lib directory",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Parse and validate without importing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
@click.option(
    "--clear",
    is_flag=True,
    default=False,
    help="Clear all existing socials before importing",
)
def seed_socials(lib_path: str, dry_run: bool, verbose: bool, clear: bool):
    """Import social commands from legacy lib/misc/socials file.

    Converts legacy CircleMUD template codes ($n, $N, $m, etc.) to modern
    readable syntax ({actor.name}, {target.pronoun.objective}, etc.).

    See docs/MESSAGE_TEMPLATES.md for the template specification.
    """
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.seeders import SocialsSeeder

    async def run_seed():
        click.echo("🌱 Seeding Social Commands")
        click.echo("=" * 60)
        click.echo(f"  Library path: {lib_path}")

        if dry_run:
            click.echo("  DRY RUN - No database changes will be made\n")

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = SocialsSeeder(prisma)

            # Optionally clear existing socials
            if clear and not dry_run:
                deleted = await seeder.clear_socials()
                click.echo(f"  Cleared {deleted} existing socials")

            # Import socials
            stats = await seeder.seed_socials(
                Path(lib_path),
                dry_run=dry_run,
                verbose=verbose,
            )

            # Summary
            click.echo(f"\n{'='*60}")
            click.echo("Import Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Parsed:   {stats['parsed']}")
            click.echo(f"  Created:  {stats['imported']}")
            click.echo(f"  Updated:  {stats['updated']}")
            click.echo(f"  Skipped:  {stats['skipped']}")

            if stats['errors'] > 0:
                click.echo(f"  Errors:   {stats['errors']} ⚠️")
                if verbose:
                    for error in stats['error_details'][:10]:
                        click.echo(f"    - {error}")
                    if len(stats['error_details']) > 10:
                        click.echo(f"    ... and {len(stats['error_details']) - 10} more")
            else:
                click.echo(f"  Errors:   0 ✅")

            if dry_run:
                click.echo(f"\n(Dry run - no database changes made)")
            else:
                click.echo(f"\n✅ Social seeding complete!")
                click.echo(f"\n📚 Template syntax documented in: docs/MESSAGE_TEMPLATES.md")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="commands")
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
def seed_commands(verbose: bool):
    """Seed MUD command definitions.

    Populates the Command table with all FieryMUD commands, including:
    - Command name and aliases
    - Category (MOVEMENT, COMBAT, COMMUNICATION, etc.)
    - Description (used for 'help' in-game)
    - Usage syntax
    - Whether the command is immortal-only
    - Required permission flags

    This makes Muditor the source of truth for command permissions.
    The MUD reads from this table at runtime.
    """
    import asyncio
    from prisma import Prisma
    from fierylib.seeders import CommandSeeder

    async def run_seed():
        click.echo("🌱 Seeding MUD Commands")
        click.echo("=" * 60)

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = CommandSeeder(prisma)
            stats = await seeder.seed_commands(verbose=verbose)

            # Summary
            click.echo(f"\n{'='*60}")
            click.echo("Seed Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Total:    {stats['total']}")
            click.echo(f"  Created:  {stats['created']}")
            click.echo(f"  Updated:  {stats['updated']}")

            click.echo(f"\n✅ Command seeding complete!")
            click.echo(f"\nCommands are now available in Muditor for permission management.")
            click.echo(f"The MUD will read command permissions from the database at runtime.")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@seed.command(name="quests")
@click.option(
    "--lib-path",
    type=click.Path(exists=True, file_okay=False, dir_okay=True),
    default=lambda: os.getenv("LEGACY_LIB_PATH", "../fierymud/legacy/lib"),
    help="Path to legacy CircleMUD lib directory",
)
@click.option(
    "--zone-id",
    type=int,
    default=0,
    help="Zone ID for imported quests (default: 0 for global)",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Parse and validate without importing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed progress",
)
@click.option(
    "--clear",
    is_flag=True,
    default=False,
    help="Clear existing quests in zone before importing",
)
def seed_quests(lib_path: str, zone_id: int, dry_run: bool, verbose: bool, clear: bool):
    """Import legacy quest definitions from lib/misc/quests file.

    This command reads the legacy CircleMUD quest definitions and creates
    Quest records with placeholder phases for each stage.

    The imported quests will need to be filled in with objectives, rewards,
    and proper descriptions using Muditor's quest editor.
    """
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.seeders.quest_seeder import seed_legacy_quests, clear_legacy_quests

    async def run_seed():
        click.echo("🌱 Seeding Legacy Quests")
        click.echo("=" * 60)

        quests_file = Path(lib_path) / "misc" / "quests"
        click.echo(f"Quest file: {quests_file}")
        click.echo(f"Target zone: {zone_id}")

        if not quests_file.exists():
            click.echo(f"❌ Quest file not found: {quests_file}")
            return

        if dry_run:
            click.echo("DRY RUN - No database changes will be made\n")

        prisma = Prisma()
        await prisma.connect()

        try:
            if clear and not dry_run:
                click.echo(f"Clearing existing quests in zone {zone_id}...")
                deleted = await clear_legacy_quests(prisma, zone_id)
                click.echo(f"  Deleted {deleted} existing quests")

            imported = await seed_legacy_quests(
                prisma,
                quests_file,
                zone_id=zone_id,
                dry_run=dry_run,
                verbose=verbose,
            )

            click.echo(f"\n{'='*60}")
            click.echo("Seed Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Imported: {imported} quests")

            if not dry_run and imported > 0:
                click.echo(f"\n✅ Quest seeding complete!")
                click.echo(f"\nQuests are now available in Muditor for editing.")
                click.echo(f"Use the quest editor to add objectives, rewards, and descriptions.")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


@main.group()
def layout():
    """Auto-layout tools for generating room coordinates"""
    pass


@layout.command(name="generate")
@click.option(
    "--start-zone",
    type=int,
    default=30,
    help="Starting zone ID (e.g., 30 for zone 30)",
)
@click.option(
    "--start-id",
    type=int,
    default=1,
    help="Starting room ID within the zone (e.g., 1 for zone 30 room 1)",
)
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Calculate layout without updating database",
)
@click.option(
    "--show-conflicts",
    is_flag=True,
    default=False,
    help="Show detailed conflict report",
)
@click.option(
    "--group-by-sector",
    is_flag=True,
    default=True,
    help="Group isolated rooms by sector type",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed placement information (zone, vnum, x, y, z)",
)
def generate_layout(
    start_zone: int,
    start_id: int,
    dry_run: bool,
    show_conflicts: bool,
    group_by_sector: bool,
    verbose: bool,
):
    """Generate automatic 3D layout for all rooms"""
    import asyncio
    from prisma import Prisma
    from fierylib.layout import LayoutConfig, LayoutEngine
    from fierylib.layout.graph_builder import load_room_graph

    async def run_layout():
        click.echo(f"FieryLib Layout Generator")
        click.echo(f"{'='*60}")
        click.echo(f"Starting room: Zone {start_zone}, ID {start_id}")
        click.echo(f"Group by sector: {group_by_sector}")

        if dry_run:
            click.echo("DRY RUN - No database changes will be made\n")

        # Initialize Prisma
        prisma = Prisma()
        await prisma.connect()

        try:
            # Load room graph from database
            click.echo("\nLoading rooms from database...")
            graph = await load_room_graph(prisma)
            click.echo(f"✅ Loaded {len(graph)} rooms")
            click.echo(f"   Zones: {len(graph.zones)}")
            click.echo(f"   Isolated rooms: {len(graph.isolated_rooms)}")

            # Configure layout engine
            config = LayoutConfig(
                start_room_zone=start_zone,
                start_room_id=start_id,
                group_by_sector=group_by_sector,
                dry_run=dry_run,
                verbose=verbose,
            )

            # Generate layout
            click.echo("\nGenerating layout...")
            engine = LayoutEngine(config)
            result = engine.generate_layout(graph)

            if not result["success"]:
                click.echo(f"❌ Layout generation failed: {result.get('error')}")
                return

            # Display results
            click.echo(f"\n{'='*60}")
            click.echo(f"Layout Results")
            click.echo(f"{'='*60}")
            click.echo(f"  Total rooms:        {result['total_rooms']}")
            click.echo(f"  Main component:     {result['main_component']} (connected to start room)")
            click.echo(f"  Disconnected:       {result['disconnected']}")
            click.echo(f"  Isolated:           {result['isolated']} (no exits)")
            click.echo(f"  Total placed:       {result['placed']}")
            click.echo(f"  Zones:              {result['zones']}")
            click.echo(f"  Position conflicts: {result['conflicts']}")

            # Show conflicts if requested
            if show_conflicts and result["conflicts"] > 0:
                click.echo(f"\n{'='*60}")
                click.echo(f"Conflict Report")
                click.echo(f"{'='*60}")
                conflicts = engine.get_conflict_report()
                for i, conflict in enumerate(conflicts[:20], 1):  # Limit to first 20
                    click.echo(
                        f"\n{i}. Position {conflict['position']} - {conflict['room_count']} rooms:"
                    )
                    for room in conflict["rooms"]:
                        click.echo(
                            f"   - Zone {room['zone_id']}, ID {room['room_id']}: {room['name']}"
                        )
                if len(conflicts) > 20:
                    click.echo(f"\n... and {len(conflicts) - 20} more conflicts")

            # Update database
            if not dry_run:
                click.echo(f"\nUpdating database...")
                update_result = await engine.update_database(prisma)
                if update_result["success"]:
                    click.echo(f"✅ Updated {update_result['updated']} rooms")
                    if update_result.get("errors"):
                        click.echo(
                            f"⚠️  {update_result['errors']} rooms had errors"
                        )
                else:
                    click.echo(f"❌ Database update failed")
            else:
                click.echo(f"\n(Dry run - no database changes made)")

        finally:
            await prisma.disconnect()

    asyncio.run(run_layout())


# Register command groups from commands submodule
from fierylib.commands.triggers import triggers
main.add_command(triggers)


if __name__ == "__main__":
    main()
