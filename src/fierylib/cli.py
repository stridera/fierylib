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
def import_legacy(lib_path: str, zone: int | None, dry_run: bool, verbose: bool, debug: bool, with_users: bool):
    """Import legacy CircleMUD data to PostgreSQL database"""
    import asyncio
    from pathlib import Path
    from prisma import Prisma
    from fierylib.importers import ZoneImporter, RoomImporter, MobImporter, ObjectImporter, ShopImporter, ResetImporter

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

            total_stats = {
                "zones": 0,
                "rooms": 0,
                "mobs": 0,
                "objects": 0,
                "shops": 0,
                "mob_resets": 0,
                "object_resets": 0,
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

            # PHASE 1: Parse all zones once, create Zone DB records, store resets in memory
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 1: Parsing Zones and Extracting Resets")
            click.echo(f"{'='*60}")

            zone_reset_map = {}  # zone_id -> ZoneResetData

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
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 2: Importing Entities")
            click.echo(f"{'='*60}")

            # Initialize vnum maps for incremental building
            vnum_maps = {
                'rooms': {},    # vnum -> (zone_id, id)
                'mobs': {},     # vnum -> (zone_id, id)
                'objects': {}   # vnum -> (zone_id, id)
            }

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

                click.echo(f"\n{'='*60}")
                click.echo(f"Processing Zone {zone_id} Entities")
                click.echo(f"{'='*60}")

                # Import rooms (with door resets and vnum map building)
                wld_file = wld_dir / f"{zone_num}.wld"
                if wld_file.exists():
                    door_reset_lookup = zone_reset_map[zone_id].door_resets
                    room_result = await room_importer.import_rooms_from_file(
                        wld_file, zone_id, dry_run=dry_run,
                        door_reset_lookup=door_reset_lookup,
                        vnum_map=vnum_maps['rooms']
                    )
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

            # PHASE 3: Apply mob/object resets using prebuilt vnum maps
            click.echo(f"\n{'='*60}")
            click.echo(f"Phase 3: Applying Mob/Object Resets")
            click.echo(f"{'='*60}")

            # Pass prebuilt vnum maps to reset importer (no DB queries needed!)
            reset_importer.set_vnum_maps(
                room_map=vnum_maps['rooms'],
                mob_map=vnum_maps['mobs'],
                object_map=vnum_maps['objects']
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

            # Summary
            click.echo(f"\n{'='*60}")
            click.echo(f"Import Summary")
            click.echo(f"{'='*60}")
            click.echo(f"  Zones:        {total_stats['zones']}")
            click.echo(f"  Rooms:        {total_stats['rooms']}")
            click.echo(f"  Mobs:         {total_stats['mobs']}")
            click.echo(f"  Objects:      {total_stats['objects']}")
            click.echo(f"  Shops:        {total_stats['shops']}")
            click.echo(f"  Mob Resets:   {total_stats['mob_resets']}")
            click.echo(f"  Object Resets: {total_stats['object_resets']}")
            
            if total_stats['failed'] > 0:
                click.echo(f"  Failed:   {total_stats['failed']} ⚠️")
                if not debug:
                    click.echo(f"\n💡 Tip: Run with --debug to see detailed error messages for all failures")
            else:
                click.echo(f"  Failed:   0 ✅")
            
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


@seed.command(name="abilities")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without importing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Enable verbose output",
)
def seed_abilities(dry_run: bool, verbose: bool):
    """Import all 368 abilities from documentation (ABILITIES_COMPLETE.md + all_spell_implementations.json)"""
    import asyncio
    from prisma import Prisma
    from fierylib.seeders.abilities_seeder import seed_abilities

    async def run_seed():
        click.echo("🌱 Seeding Abilities")
        click.echo("=" * 60)

        if dry_run:
            click.echo("⚠️  DRY RUN mode not yet implemented for abilities seeder")
            click.echo("   This command will import abilities to the database")
            return

        prisma = Prisma()
        await prisma.connect()

        try:
            imported_count = await seed_abilities(prisma)

            click.echo("\n✅ Ability seeding complete!")
            click.echo(f"   Imported {imported_count} abilities from documentation")
            click.echo(f"\n📚 Data sources:")
            click.echo(f"   - docs/ABILITIES_COMPLETE.md (metadata)")
            click.echo(f"   - docs/all_spell_implementations.json (implementations)")

        except FileNotFoundError as e:
            click.echo(f"❌ Error: {e}")
            click.echo("\n💡 Make sure the documentation files exist:")
            click.echo("   - /home/strider/Code/mud/docs/ABILITIES_COMPLETE.md")
            click.echo("   - /home/strider/Code/mud/docs/all_spell_implementations.json")
        except Exception as e:
            click.echo(f"❌ Unexpected error: {e}")
            if verbose:
                import traceback
                traceback.print_exc()
        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())


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


if __name__ == "__main__":
    main()
