#!/usr/bin/env python3
"""
Test script for layout generation
Run this to test the layout algorithm
"""

import asyncio
from prisma import Prisma
from fierylib.layout import LayoutConfig, LayoutEngine
from fierylib.layout.graph_builder import load_room_graph


async def test_layout():
    print("Testing Layout Generation")
    print("=" * 60)

    # Initialize Prisma
    prisma = Prisma()
    await prisma.connect()

    try:
        # Load room graph
        print("\n1. Loading rooms from database...")
        graph = await load_room_graph(prisma)
        print(f"   ✓ Loaded {len(graph)} rooms")
        print(f"   ✓ Found {len(graph.zones)} zones")
        print(f"   ✓ Found {len(graph.isolated_rooms)} isolated rooms")

        # Configure layout
        config = LayoutConfig(
            start_room_zone=30,
            start_room_id=1,
            group_by_sector=True,
            dry_run=True,  # Don't update DB for testing
        )

        # Generate layout
        print("\n2. Generating layout...")
        engine = LayoutEngine(config)
        result = engine.generate_layout(graph)

        if not result["success"]:
            print(f"   ✗ Failed: {result.get('error')}")
            return

        print(f"   ✓ Layout generated successfully")
        print(f"\n3. Results:")
        print(f"   - Total rooms:  {result['total_rooms']}")
        print(f"   - Placed:       {result['placed']}")
        print(f"   - Isolated:     {result['isolated']}")
        print(f"   - Conflicts:    {result['conflicts']}")

        # Show sample positions
        print(f"\n4. Sample room positions:")
        sample_count = 0
        for room in graph.rooms.values():
            if room.is_placed and room.position and sample_count < 10:
                print(
                    f"   Zone {room.zone_id:3d}, ID {room.room_id:3d}: "
                    f"({room.position[0]:4d}, {room.position[1]:4d}, {room.position[2]:2d}) "
                    f"- {room.name[:40]}"
                )
                sample_count += 1

        # Show conflicts if any
        if result["conflicts"] > 0:
            print(f"\n5. Conflict details (first 5):")
            conflicts = engine.get_conflict_report()
            for i, conflict in enumerate(conflicts[:5], 1):
                print(f"\n   Conflict {i} at {conflict['position']}:")
                for room in conflict["rooms"][:3]:  # First 3 rooms
                    print(
                        f"     - Zone {room['zone_id']}, ID {room['room_id']}: {room['name']}"
                    )

        print("\n" + "=" * 60)
        print("Test completed successfully!")
        print("Run with --dry-run=False to update the database")

    except Exception as e:
        print(f"\n✗ Error: {e}")
        import traceback

        traceback.print_exc()

    finally:
        await prisma.disconnect()


if __name__ == "__main__":
    asyncio.run(test_layout())
