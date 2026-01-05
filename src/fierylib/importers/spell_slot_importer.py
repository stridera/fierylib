"""
Spell Slot Importer - Imports spell slot progression data

This is static configuration data from the legacy C++ code (spell_mem.cpp).
The spells_of_circle array defines how many spell slots are available
at each level for each spell circle.
"""

import click
from prisma import Prisma


# Legacy spell slot data from spell_mem.cpp
# Format: spells_of_circle[level][circle] = slots
# Circles 1-14 (index 0 is unused)
# Levels 0-105 (0 is unused, 101-105 are immortal levels)
SPELL_SLOTS = [
    # Level 0 - unused
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    # Level 1 - Circle 1 unlocks
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    # Level 9 - Circle 2 unlocks
    [0, 7, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    # Level 17 - Circle 3 unlocks
    [0, 7, 6, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    # Level 25 - Circle 4 unlocks
    [0, 7, 7, 6, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    # Level 33 - Circle 5 unlocks
    [0, 7, 7, 6, 6, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    # Level 41 - Circle 6 unlocks
    [0, 7, 7, 6, 6, 6, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 2, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 3, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 4, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 5, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 6, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0],
    # Level 49 - Circle 7 unlocks
    [0, 7, 7, 7, 6, 6, 6, 1, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 2, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 3, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 4, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 5, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 5, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 0, 0, 0, 0, 0, 0, 0],
    # Level 57 - Circle 8 unlocks
    [0, 7, 7, 7, 6, 6, 6, 6, 1, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 2, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 3, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 4, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 5, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 5, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 6, 0, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 6, 6, 6, 6, 6, 0, 0, 0, 0, 0, 0],
    # Level 65 - Circle 9 unlocks
    [0, 7, 7, 7, 7, 6, 6, 6, 6, 1, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 7, 6, 6, 6, 6, 2, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 7, 6, 6, 6, 6, 3, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 7, 6, 6, 6, 6, 4, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 7, 6, 6, 6, 6, 5, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 7, 6, 6, 6, 6, 5, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 7, 6, 6, 6, 6, 5, 0, 0, 0, 0, 0],
    [0, 7, 7, 7, 7, 6, 6, 6, 6, 6, 0, 0, 0, 0, 0],
    # Level 73 - Circle 10 unlocks
    [0, 8, 7, 7, 7, 6, 6, 6, 6, 6, 1, 0, 0, 0, 0],
    [0, 8, 7, 7, 7, 6, 6, 6, 6, 6, 2, 0, 0, 0, 0],
    [0, 8, 7, 7, 7, 6, 6, 6, 6, 6, 3, 0, 0, 0, 0],
    [0, 8, 7, 7, 7, 6, 6, 6, 6, 6, 4, 0, 0, 0, 0],
    [0, 8, 7, 7, 7, 6, 6, 6, 6, 6, 5, 0, 0, 0, 0],
    [0, 8, 7, 7, 7, 6, 6, 6, 6, 6, 5, 0, 0, 0, 0],
    [0, 8, 7, 7, 7, 6, 6, 6, 6, 6, 5, 0, 0, 0, 0],
    [0, 8, 7, 7, 7, 6, 6, 6, 6, 6, 6, 0, 0, 0, 0],
    # Level 81 - Circle 11 unlocks
    [0, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 1, 0, 0, 0],
    [0, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 2, 0, 0, 0],
    [0, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 3, 0, 0, 0],
    [0, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 4, 0, 0, 0],
    [0, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 4, 0, 0, 0],
    [0, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 4, 0, 0, 0],
    [0, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 4, 0, 0, 0],
    [0, 8, 8, 7, 7, 7, 6, 6, 6, 6, 6, 4, 0, 0, 0],
    # Level 89 - Circle 12 unlocks
    [0, 8, 8, 7, 7, 7, 7, 6, 6, 6, 6, 5, 1, 0, 0],
    [0, 8, 8, 8, 7, 7, 7, 6, 6, 6, 6, 5, 2, 0, 0],
    [0, 8, 8, 8, 7, 7, 7, 6, 6, 6, 6, 5, 3, 0, 0],
    [0, 8, 8, 8, 8, 7, 7, 7, 6, 6, 6, 5, 4, 0, 0],
    [0, 8, 8, 8, 8, 7, 7, 7, 6, 6, 6, 5, 4, 0, 0],
    [0, 8, 8, 8, 8, 8, 7, 7, 7, 6, 6, 5, 4, 0, 0],
    [0, 8, 8, 8, 8, 8, 7, 7, 7, 6, 6, 5, 4, 0, 0],
    [0, 8, 8, 8, 8, 8, 8, 7, 7, 6, 6, 5, 4, 0, 0],
    # Level 97 - Circle 13 unlocks
    [0, 9, 9, 8, 8, 8, 8, 8, 7, 7, 6, 5, 4, 1, 0],
    [0, 9, 9, 9, 9, 9, 9, 8, 7, 7, 6, 5, 4, 2, 0],
    [0, 10, 10, 10, 10, 10, 10, 9, 8, 7, 6, 5, 4, 3, 0],
    # Level 100
    [0, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 8, 7, 6, 0],
    # Immortal levels 101-105
    [0, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 8, 7, 6, 0],
    [0, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 8, 7, 6, 0],
    [0, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 8, 7, 6, 0],
    [0, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 8, 7, 6, 0],
    [0, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 8, 7, 6, 0],
]


class SpellSlotImporter:
    """Imports spell slot progression data"""

    def __init__(self, prisma_client: Prisma):
        self.prisma = prisma_client

    async def import_spell_slots(
        self,
        dry_run: bool = False,
        verbose: bool = False
    ) -> dict:
        """
        Import spell slot progression data.

        Args:
            dry_run: If True, validate but don't write to database
            verbose: If True, print detailed progress

        Returns:
            Dict with import results
        """
        stats = {
            "rows_created": 0,
            "rows_skipped": 0,
            "errors": 0,
        }

        click.echo("  Importing spell slot progression...")

        # Clear existing data (we're importing the full table)
        if not dry_run:
            await self.prisma.spellslotprogression.delete_many()
            if verbose:
                click.echo("    Cleared existing spell slot progression data")

        # Import only non-zero entries to keep the table sparse
        entries_to_create = []
        for level, slots_by_circle in enumerate(SPELL_SLOTS):
            if level == 0:
                continue  # Skip level 0

            for circle, slots in enumerate(slots_by_circle):
                if circle == 0 or slots == 0:
                    continue  # Skip circle 0 and zero-slot entries

                entries_to_create.append({
                    "level": level,
                    "circle": circle,
                    "slots": slots,
                })

        if verbose:
            click.echo(f"    Found {len(entries_to_create)} non-zero entries")

        if dry_run:
            stats["rows_created"] = len(entries_to_create)
            click.echo(f"  ✅ [DRY RUN] Would create {stats['rows_created']} spell slot entries")
            return stats

        # Batch create for efficiency
        try:
            # Prisma Python doesn't have createMany, so we batch manually
            batch_size = 100
            for i in range(0, len(entries_to_create), batch_size):
                batch = entries_to_create[i:i + batch_size]
                for entry in batch:
                    await self.prisma.spellslotprogression.create(data=entry)
                    stats["rows_created"] += 1

                if verbose and i % 500 == 0:
                    click.echo(f"    Created {stats['rows_created']}/{len(entries_to_create)} entries")

        except Exception as e:
            click.echo(f"    ✗ Error importing spell slots: {e}")
            stats["errors"] += 1

        click.echo(f"  ✅ Spell slot progression: {stats['rows_created']} entries created")
        return stats


async def import_spell_slots(
    dry_run: bool = False,
    verbose: bool = False
) -> dict:
    """
    Convenience function to import spell slot progression.

    Args:
        dry_run: If True, validate but don't write
        verbose: If True, print detailed progress

    Returns:
        Dict with import results
    """
    async with Prisma() as prisma:
        importer = SpellSlotImporter(prisma)
        return await importer.import_spell_slots(dry_run=dry_run, verbose=verbose)
