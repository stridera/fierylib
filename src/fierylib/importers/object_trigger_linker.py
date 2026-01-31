"""
Object Trigger Linker - Links objects to triggers via ObjectTriggers junction table

This module parses "T <trigger_vnum>" lines from legacy object files and creates
the proper many-to-many relationships in the ObjectTriggers table.

In DG Scripts:
- Triggers have their own vnums (e.g., 1240)
- Objects reference triggers via "T <trigger_vnum>" lines after the values
- A trigger can be attached to multiple objects (many-to-many relationship)

Example object file format:
    #1240
    longsword sword noisy talking~
    a &5TALKING&0 steel longsword~
    ...
    T 1240
    X
    1008
    #1241
    ...

This module:
1. Parses object files to extract object_vnum -> [trigger_vnums] mappings
2. Converts vnums to database IDs
3. Populates the ObjectTriggers junction table
"""

from pathlib import Path
from typing import Optional

from fierylib.converters import convert_zone_id, EntityResolver


def parse_object_trigger_attachments(obj_file: Path) -> dict[int, list[int]]:
    """
    Parse a legacy object file and extract trigger attachments.

    Args:
        obj_file: Path to .obj file

    Returns:
        Dict mapping object_vnum -> list of trigger_vnums
        Example: {1240: [1240], 3050: [3000, 3001]}
    """
    content = obj_file.read_text(encoding='latin-1')
    lines = content.split('\n')

    attachments: dict[int, list[int]] = {}
    current_obj_vnum: Optional[int] = None

    for line in lines:
        line = line.strip()

        # Check for object vnum header (#1240)
        if line.startswith('#') and line[1:].isdigit():
            current_obj_vnum = int(line[1:])
            # Don't include 0 (end-of-file marker)
            if current_obj_vnum == 0:
                current_obj_vnum = None
            continue

        # Check for trigger attachment (T 1240)
        if line.startswith('T ') and current_obj_vnum is not None:
            parts = line.split()
            if len(parts) >= 2 and parts[1].isdigit():
                trigger_vnum = int(parts[1])
                if current_obj_vnum not in attachments:
                    attachments[current_obj_vnum] = []
                attachments[current_obj_vnum].append(trigger_vnum)

    return attachments


def parse_all_object_trigger_attachments(world_dir: Path) -> dict[int, list[int]]:
    """
    Parse all object files in a directory and extract trigger attachments.

    Args:
        world_dir: Path to world/obj directory

    Returns:
        Combined dict mapping object_vnum -> list of trigger_vnums
    """
    all_attachments: dict[int, list[int]] = {}

    obj_dir = world_dir / "obj"
    if not obj_dir.exists():
        return all_attachments

    for obj_file in sorted(obj_dir.glob("*.obj")):
        file_attachments = parse_object_trigger_attachments(obj_file)
        all_attachments.update(file_attachments)

    return all_attachments


class ObjectTriggerLinker:
    """Links objects to triggers via ObjectTriggers junction table"""

    def __init__(self, prisma_client):
        """
        Initialize the linker.

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client
        self.resolver = EntityResolver(prisma_client)

    async def link_object_triggers(
        self,
        world_dir: Path,
        dry_run: bool = False,
        verbose: bool = False
    ) -> dict:
        """
        Parse object files and create ObjectTriggers junction entries.

        Args:
            world_dir: Path to world directory (containing obj/ subdirectory)
            dry_run: If True, validate but don't write to database
            verbose: If True, print detailed progress

        Returns:
            Dict with linking results
        """
        # Parse all trigger attachments from object files
        attachments = parse_all_object_trigger_attachments(world_dir)

        if verbose:
            print(f"Found {len(attachments)} objects with trigger attachments")
            total_attachments = sum(len(v) for v in attachments.values())
            print(f"Total trigger attachments: {total_attachments}")

        results = {
            "success": True,
            "objects_processed": 0,
            "links_created": 0,
            "links_skipped": 0,
            "errors": [],
        }

        # Clear existing ObjectTriggers entries (we're rebuilding from scratch)
        if not dry_run:
            await self.prisma.objecttriggers.delete_many()
            if verbose:
                print("Cleared existing ObjectTriggers entries")

        # Process each object's trigger attachments
        for obj_vnum, trigger_vnums in attachments.items():
            # Use EntityResolver to properly resolve object vnum
            # Context zone is calculated from vnum for initial lookup
            context_zone = obj_vnum // 100
            obj_result = await self.resolver.resolve_object(obj_vnum, context_zone=context_zone)

            if not obj_result:
                results["errors"].append(
                    f"Object {obj_vnum} not found in database"
                )
                continue

            obj_zone_id = obj_result.zone_id
            obj_local_id = obj_result.id
            results["objects_processed"] += 1

            for trigger_vnum in trigger_vnums:
                # Use EntityResolver to properly resolve trigger vnum
                # Use same context zone as the object (triggers are usually in same zone)
                trigger_result = await self.resolver.resolve_trigger(trigger_vnum, context_zone=obj_zone_id)

                if not trigger_result:
                    if verbose:
                        print(f"  Warning: Trigger {trigger_vnum} not found (tried zone {obj_zone_id} and {trigger_vnum // 100}), skipping")
                    results["links_skipped"] += 1
                    continue

                trigger_zone_id = trigger_result.zone_id
                trigger_local_id = trigger_result.id

                if dry_run:
                    results["links_created"] += 1
                    continue

                try:
                    # Create ObjectTriggers entry with composite FK to trigger
                    await self.prisma.objecttriggers.create(
                        data={
                            "objectZoneId": obj_zone_id,
                            "objectId": obj_local_id,
                            "triggerZoneId": trigger_zone_id,
                            "triggerId": trigger_local_id,
                        }
                    )
                    results["links_created"] += 1

                    if verbose:
                        print(f"  Linked object {obj_vnum} ({obj_zone_id}:{obj_local_id}) to trigger {trigger_zone_id}:{trigger_local_id}")

                except Exception as e:
                    # Skip duplicates silently (same trigger attached multiple times)
                    if "Unique constraint" in str(e):
                        results["links_skipped"] += 1
                    else:
                        results["errors"].append(
                            f"Error linking object {obj_vnum} to trigger {trigger_vnum}: {e}"
                        )

        if verbose:
            print(f"\nResults:")
            print(f"  Objects processed: {results['objects_processed']}")
            print(f"  Links created: {results['links_created']}")
            print(f"  Links skipped: {results['links_skipped']}")
            if results["errors"]:
                print(f"  Errors: {len(results['errors'])}")

        return results

    async def get_stats(self) -> dict:
        """
        Get statistics about ObjectTriggers entries.

        Returns:
            Dict with statistics
        """
        total = await self.prisma.objecttriggers.count()

        # Count unique objects with triggers
        objects_with_triggers = await self.prisma.query_raw(
            """
            SELECT COUNT(DISTINCT (object_zone_id, object_id))
            FROM "ObjectTriggers"
            """
        )

        # Count unique triggers attached to objects
        triggers_attached = await self.prisma.query_raw(
            """
            SELECT COUNT(DISTINCT (trigger_zone_id, trigger_id))
            FROM "ObjectTriggers"
            """
        )

        return {
            "total_links": total,
            "objects_with_triggers": objects_with_triggers[0]["count"] if objects_with_triggers else 0,
            "triggers_attached": triggers_attached[0]["count"] if triggers_attached else 0,
        }
