"""
Room Trigger Linker - Links rooms to triggers via RoomTriggers junction table

This module parses "T <trigger_vnum>" lines from legacy world (.wld) files and creates
the proper many-to-many relationships in the RoomTriggers table.

In DG Scripts:
- Triggers have their own vnums (e.g., 48200)
- Rooms reference triggers via "T <trigger_vnum>" lines after the "S" marker
- A trigger can be attached to multiple rooms (many-to-many relationship)

Example .wld file format:
    #3033
    The Lobby~
    ...
    0 -1 3032
    S
    T 48200
    #3034
    Dark Alley~
    ...

This module:
1. Parses .wld files to extract room_vnum -> [trigger_vnums] mappings
2. Converts vnums to composite database keys
3. Populates the RoomTriggers junction table
"""

from pathlib import Path
from typing import Optional


def parse_room_trigger_attachments(wld_file: Path) -> dict[int, list[int]]:
    """
    Parse a legacy .wld file and extract trigger attachments.

    T lines appear after the S (end-of-room) marker, before the next # room header.

    Args:
        wld_file: Path to .wld file

    Returns:
        Dict mapping room_vnum -> list of trigger_vnums
        Example: {3033: [48200], 12389: [12317, 12318, 12319]}
    """
    content = wld_file.read_text(encoding='latin-1')
    lines = content.split('\n')

    attachments: dict[int, list[int]] = {}
    current_room_vnum: Optional[int] = None

    for line in lines:
        line = line.strip()

        # Check for room vnum header (#3033)
        if line.startswith('#') and line[1:].isdigit():
            current_room_vnum = int(line[1:])
            # Don't include 0 (end-of-file marker)
            if current_room_vnum == 0:
                current_room_vnum = None
            continue

        # Check for trigger attachment (T 48200)
        if line.startswith('T ') and current_room_vnum is not None:
            parts = line.split()
            if len(parts) >= 2 and parts[1].isdigit():
                trigger_vnum = int(parts[1])
                if current_room_vnum not in attachments:
                    attachments[current_room_vnum] = []
                attachments[current_room_vnum].append(trigger_vnum)

    return attachments


def parse_all_room_trigger_attachments(world_dir: Path) -> dict[int, list[int]]:
    """
    Parse all .wld files in a directory and extract trigger attachments.

    Args:
        world_dir: Path to world directory (containing wld/ subdirectory)

    Returns:
        Combined dict mapping room_vnum -> list of trigger_vnums
    """
    all_attachments: dict[int, list[int]] = {}

    wld_dir = world_dir / "wld"
    if not wld_dir.exists():
        return all_attachments

    for wld_file in sorted(wld_dir.glob("*.wld")):
        file_attachments = parse_room_trigger_attachments(wld_file)
        all_attachments.update(file_attachments)

    return all_attachments


class RoomTriggerLinker:
    """Links rooms to triggers via RoomTriggers junction table"""

    def __init__(self, prisma_client):
        """
        Initialize the linker.

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client

    async def link_room_triggers(
        self,
        world_dir: Path,
        dry_run: bool = False,
        verbose: bool = False
    ) -> dict:
        """
        Parse .wld files and create RoomTriggers junction entries.

        Args:
            world_dir: Path to world directory (containing wld/ subdirectory)
            dry_run: If True, validate but don't write to database
            verbose: If True, print detailed progress

        Returns:
            Dict with linking results
        """
        # Parse all trigger attachments from .wld files
        attachments = parse_all_room_trigger_attachments(world_dir)

        if verbose:
            print(f"Found {len(attachments)} rooms with trigger attachments")
            total_attachments = sum(len(v) for v in attachments.values())
            print(f"Total trigger attachments: {total_attachments}")

        # Build vnum lookup dicts: legacy vnum → (zoneId, id)
        triggers = await self.prisma.triggers.find_many()
        trigger_by_vnum: dict[int, tuple[int, int]] = {}
        for t in triggers:
            trigger_by_vnum[t.zoneId * 100 + t.id] = (t.zoneId, t.id)

        rooms = await self.prisma.room.find_many()
        room_by_vnum: dict[int, tuple[int, int]] = {}
        for r in rooms:
            room_by_vnum[r.zoneId * 100 + r.id] = (r.zoneId, r.id)

        if verbose:
            print(f"Trigger vnum lookup entries: {len(trigger_by_vnum)}")
            print(f"Room vnum lookup entries: {len(room_by_vnum)}")

        results = {
            "success": True,
            "rooms_processed": 0,
            "links_created": 0,
            "links_skipped": 0,
            "errors": [],
        }

        # Clear existing RoomTriggers entries (we're rebuilding from scratch)
        if not dry_run:
            await self.prisma.roomtriggers.delete_many()
            if verbose:
                print("Cleared existing RoomTriggers entries")

        # Process each room's trigger attachments
        for room_vnum, trigger_vnums in attachments.items():
            room_key = room_by_vnum.get(room_vnum)

            if room_key is None:
                results["errors"].append(
                    f"Room {room_vnum} not found in database"
                )
                continue

            room_zone_id, room_local_id = room_key
            results["rooms_processed"] += 1

            for trigger_vnum in trigger_vnums:
                trigger_key = trigger_by_vnum.get(trigger_vnum)

                if trigger_key is None:
                    if verbose:
                        print(f"  Warning: Trigger {trigger_vnum} not found, skipping")
                    results["links_skipped"] += 1
                    continue

                trigger_zone_id, trigger_local_id = trigger_key

                if dry_run:
                    results["links_created"] += 1
                    continue

                try:
                    # Create RoomTriggers entry with composite FKs
                    await self.prisma.roomtriggers.create(
                        data={
                            "roomZoneId": room_zone_id,
                            "roomId": room_local_id,
                            "triggerZoneId": trigger_zone_id,
                            "triggerId": trigger_local_id,
                        }
                    )
                    results["links_created"] += 1

                    if verbose:
                        print(f"  Linked room {room_vnum} ({room_zone_id}:{room_local_id}) to trigger {trigger_zone_id}:{trigger_local_id}")

                except Exception as e:
                    # Skip duplicates silently (same trigger attached multiple times)
                    if "Unique constraint" in str(e):
                        results["links_skipped"] += 1
                    else:
                        results["errors"].append(
                            f"Error linking room {room_vnum} to trigger {trigger_vnum}: {e}"
                        )

        if verbose:
            print(f"\nResults:")
            print(f"  Rooms processed: {results['rooms_processed']}")
            print(f"  Links created: {results['links_created']}")
            print(f"  Links skipped: {results['links_skipped']}")
            if results["errors"]:
                print(f"  Errors: {len(results['errors'])}")

        return results

    async def get_stats(self) -> dict:
        """
        Get statistics about RoomTriggers entries.

        Returns:
            Dict with statistics
        """
        total = await self.prisma.roomtriggers.count()

        # Count unique rooms with triggers
        rooms_with_triggers = await self.prisma.query_raw(
            """
            SELECT COUNT(DISTINCT (room_zone_id, room_id))
            FROM "RoomTriggers"
            """
        )

        # Count unique triggers attached to rooms
        triggers_attached = await self.prisma.query_raw(
            """
            SELECT COUNT(DISTINCT (trigger_zone_id, trigger_id))
            FROM "RoomTriggers"
            """
        )

        return {
            "total_links": total,
            "rooms_with_triggers": rooms_with_triggers[0]["count"] if rooms_with_triggers else 0,
            "triggers_attached": triggers_attached[0]["count"] if triggers_attached else 0,
        }
