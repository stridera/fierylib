#!/usr/bin/env python3
"""
Example: Import zones from legacy CircleMUD files

This script demonstrates how to use ZoneImporter to import
zone data from lib/ directory into PostgreSQL.

Usage:
    python examples/import_zones.py                    # Import all zones
    python examples/import_zones.py --zone 30          # Import zone 30 only
    python examples/import_zones.py --dry-run          # Validate without importing
"""

import asyncio
import sys
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from prisma import Prisma
from fierylib.importers import ZoneImporter


async def main():
    """Main import function"""
    import argparse

    parser = argparse.ArgumentParser(description="Import zones from legacy files")
    parser.add_argument(
        "--lib-path",
        type=Path,
        default=Path("../lib"),
        help="Path to legacy lib directory",
    )
    parser.add_argument(
        "--zone", type=int, help="Import specific zone only (e.g., 30)"
    )
    parser.add_argument(
        "--dry-run", action="store_true", help="Validate without importing"
    )

    args = parser.parse_args()

    # Initialize Prisma client
    prisma = Prisma()
    await prisma.connect()

    try:
        importer = ZoneImporter(prisma)

        world_dir = args.lib_path / "world"
        zon_dir = world_dir / "zon"

        if not zon_dir.exists():
            print(f"❌ Zone directory not found: {zon_dir}")
            return

        if args.zone:
            # Import specific zone
            zone_file = zon_dir / f"{args.zone}.zon"
            if not zone_file.exists():
                print(f"❌ Zone file not found: {zone_file}")
                return

            print(f"Importing zone {args.zone} from {zone_file}...")
            result = await importer.import_zone_from_file(zone_file, dry_run=args.dry_run)

            if result["success"]:
                action = result["action"]
                print(
                    f"✅ Zone {result['zone_id']} ({result['zone_name']}): {action}"
                )
            else:
                print(f"❌ Failed: {result.get('error', 'Unknown error')}")

        else:
            # Import all zones
            print(f"Importing all zones from {zon_dir}...")
            results = await importer.import_all_zones(world_dir, dry_run=args.dry_run)

            print(f"\nResults:")
            print(f"  Total zones: {results['total']}")
            print(f"  Imported: {results['imported']}")
            print(f"  Failed: {results['failed']}")

            if args.dry_run:
                print(f"\n  (Dry run - no database changes made)")

            # Show details for failed zones
            if results["failed"] > 0:
                print(f"\nFailed zones:")
                for zone_result in results["zones"]:
                    if not zone_result["success"]:
                        print(f"  - {zone_result.get('file', 'unknown')}: {zone_result.get('error', 'Unknown error')}")

    finally:
        await prisma.disconnect()


if __name__ == "__main__":
    asyncio.run(main())
