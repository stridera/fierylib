"""
Mob Trigger Linker - Links mobs to triggers via MobTriggers junction table

This module parses "T <trigger_vnum>" lines from legacy mob files and creates
the proper many-to-many relationships in the MobTriggers table.

In DG Scripts:
- Triggers have their own vnums (e.g., 3000)
- Mobs reference triggers via "T <trigger_vnum>" lines after the "E" marker
- A trigger can be attached to multiple mobs (many-to-many relationship)

Example mob file format:
    #3005
    receptionist recep inn innkeeper~
    a pretty half-elven receptionist~
    ...
    E
    T 3000
    T 3001
    #3006
    ...

This module:
1. Parses mob files to extract mob_vnum -> [trigger_vnums] mappings
2. Converts vnums to database IDs
3. Populates the MobTriggers junction table
"""

import re
from pathlib import Path
from typing import Optional

from fierylib.converters import convert_zone_id, EntityResolver


def parse_mob_trigger_attachments(mob_file: Path) -> dict[int, list[int]]:
    """
    Parse a legacy mob file and extract trigger attachments.

    Args:
        mob_file: Path to .mob file

    Returns:
        Dict mapping mob_vnum -> list of trigger_vnums
        Example: {3005: [3000, 3001], 3013: [3093, 3094]}
    """
    content = mob_file.read_text(encoding='latin-1')
    lines = content.split('\n')

    attachments: dict[int, list[int]] = {}
    current_mob_vnum: Optional[int] = None

    for line in lines:
        line = line.strip()

        # Check for mob vnum header (#3005)
        if line.startswith('#') and line[1:].isdigit():
            current_mob_vnum = int(line[1:])
            # Don't include 0 (end-of-file marker)
            if current_mob_vnum == 0:
                current_mob_vnum = None
            continue

        # Check for trigger attachment (T 3000)
        if line.startswith('T ') and current_mob_vnum is not None:
            parts = line.split()
            if len(parts) >= 2 and parts[1].isdigit():
                trigger_vnum = int(parts[1])
                if current_mob_vnum not in attachments:
                    attachments[current_mob_vnum] = []
                attachments[current_mob_vnum].append(trigger_vnum)

    return attachments


def parse_all_mob_trigger_attachments(world_dir: Path) -> dict[int, list[int]]:
    """
    Parse all mob files in a directory and extract trigger attachments.

    Args:
        world_dir: Path to world/mob directory

    Returns:
        Combined dict mapping mob_vnum -> list of trigger_vnums
    """
    all_attachments: dict[int, list[int]] = {}

    mob_dir = world_dir / "mob"
    if not mob_dir.exists():
        return all_attachments

    for mob_file in sorted(mob_dir.glob("*.mob")):
        file_attachments = parse_mob_trigger_attachments(mob_file)
        all_attachments.update(file_attachments)

    return all_attachments


class MobTriggerLinker:
    """Links mobs to triggers via MobTriggers junction table"""

    def __init__(self, prisma_client):
        """
        Initialize the linker.

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client
        self.resolver = EntityResolver(prisma_client)

    async def build_trigger_vnum_to_id_map(self) -> dict[int, int]:
        """
        Build a mapping from trigger vnum to database trigger ID.

        Returns:
            Dict mapping vnum -> trigger_id
        """
        triggers = await self.prisma.triggers.find_many(
            where={"vnum": {"not": None}}
        )
        return {t.vnum: t.id for t in triggers if t.vnum is not None}

    async def link_mob_triggers(
        self,
        world_dir: Path,
        dry_run: bool = False,
        verbose: bool = False
    ) -> dict:
        """
        Parse mob files and create MobTriggers junction entries.

        Args:
            world_dir: Path to world directory (containing mob/ subdirectory)
            dry_run: If True, validate but don't write to database
            verbose: If True, print detailed progress

        Returns:
            Dict with linking results
        """
        # Parse all trigger attachments from mob files
        attachments = parse_all_mob_trigger_attachments(world_dir)

        if verbose:
            print(f"Found {len(attachments)} mobs with trigger attachments")
            total_attachments = sum(len(v) for v in attachments.values())
            print(f"Total trigger attachments: {total_attachments}")

        # Build trigger vnum -> id mapping
        trigger_map = await self.build_trigger_vnum_to_id_map()

        if verbose:
            print(f"Trigger vnum map has {len(trigger_map)} entries")

        results = {
            "success": True,
            "mobs_processed": 0,
            "links_created": 0,
            "links_skipped": 0,
            "errors": [],
        }

        # Clear existing MobTriggers entries (we're rebuilding from scratch)
        if not dry_run:
            await self.prisma.mobtriggers.delete_many()
            if verbose:
                print("Cleared existing MobTriggers entries")

        # Process each mob's trigger attachments
        for mob_vnum, trigger_vnums in attachments.items():
            # Resolve mob vnum to composite ID using EntityResolver
            # Context zone is calculated from vnum, but resolver will verify against database
            context_zone = mob_vnum // 100
            mob_result = await self.resolver.resolve_mob(mob_vnum, context_zone=context_zone)

            if not mob_result:
                results["errors"].append(
                    f"Mob {mob_vnum} not found in database"
                )
                continue

            mob_zone_id = mob_result.zone_id
            mob_local_id = mob_result.id
            results["mobs_processed"] += 1

            for trigger_vnum in trigger_vnums:
                trigger_id = trigger_map.get(trigger_vnum)

                if trigger_id is None:
                    if verbose:
                        print(f"  Warning: Trigger {trigger_vnum} not found, skipping")
                    results["links_skipped"] += 1
                    continue

                if dry_run:
                    results["links_created"] += 1
                    continue

                try:
                    # Create MobTriggers entry
                    await self.prisma.mobtriggers.create(
                        data={
                            "mobZoneId": mob_zone_id,
                            "mobId": mob_local_id,
                            "triggerId": trigger_id,
                        }
                    )
                    results["links_created"] += 1

                    if verbose:
                        print(f"  Linked mob {mob_vnum} to trigger {trigger_vnum} (id:{trigger_id})")

                except Exception as e:
                    # Skip duplicates silently (same trigger attached multiple times)
                    if "Unique constraint" in str(e):
                        results["links_skipped"] += 1
                    else:
                        results["errors"].append(
                            f"Error linking mob {mob_vnum} to trigger {trigger_vnum}: {e}"
                        )

        if verbose:
            print(f"\nResults:")
            print(f"  Mobs processed: {results['mobs_processed']}")
            print(f"  Links created: {results['links_created']}")
            print(f"  Links skipped: {results['links_skipped']}")
            if results["errors"]:
                print(f"  Errors: {len(results['errors'])}")

        return results

    async def get_stats(self) -> dict:
        """
        Get statistics about MobTriggers entries.

        Returns:
            Dict with statistics
        """
        total = await self.prisma.mobtriggers.count()

        # Count unique mobs with triggers
        mobs_with_triggers = await self.prisma.raw_query(
            """
            SELECT COUNT(DISTINCT (mob_zone_id, mob_id))
            FROM "MobTriggers"
            """
        )

        # Count unique triggers attached to mobs
        triggers_attached = await self.prisma.raw_query(
            """
            SELECT COUNT(DISTINCT trigger_id)
            FROM "MobTriggers"
            """
        )

        return {
            "total_links": total,
            "mobs_with_triggers": mobs_with_triggers[0]["count"] if mobs_with_triggers else 0,
            "triggers_attached": triggers_attached[0]["count"] if triggers_attached else 0,
        }
