"""
Socials Seeder - Imports social commands from legacy CircleMUD files to PostgreSQL.

Uses the socials parser to convert legacy templates to modern syntax.
See /docs/MESSAGE_TEMPLATES.md for the template specification.
"""

import click
from pathlib import Path
from prisma import Prisma
from prisma.enums import Position

from fierylib.parsers.socials_parser import parse_socials, Social


# Map string position names to Prisma enum values
# Note: PRONE, KNEELING, FLYING were removed from Position enum
# PRONE → RESTING (lying down), KNEELING → SITTING, FLYING → STANDING (now a MovementMode)
POSITION_ENUM_MAP = {
    "PRONE": Position.RESTING,
    "SITTING": Position.SITTING,
    "KNEELING": Position.SITTING,
    "STANDING": Position.STANDING,
    "FLYING": Position.STANDING,
    "RESTING": Position.RESTING,
    "SLEEPING": Position.SLEEPING,
}


class SocialsSeeder:
    """Seeds social commands from legacy CircleMUD files."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    async def seed_socials(
        self,
        lib_path: Path,
        dry_run: bool = False,
        verbose: bool = False,
    ) -> dict:
        """
        Import socials from legacy lib directory.

        Args:
            lib_path: Path to the legacy lib directory
            dry_run: If True, parse but don't write to database
            verbose: If True, show detailed progress

        Returns:
            Dictionary with import statistics
        """
        stats = {
            "parsed": 0,
            "imported": 0,
            "updated": 0,
            "skipped": 0,
            "errors": 0,
            "error_details": [],
        }

        # Parse socials file
        try:
            socials = parse_socials(lib_path)
            stats["parsed"] = len(socials)
            click.echo(f"  Parsed {len(socials)} socials from {lib_path / 'misc/socials'}")
        except FileNotFoundError as e:
            click.echo(f"  Error: {e}")
            stats["errors"] = 1
            stats["error_details"].append(str(e))
            return stats

        if dry_run:
            click.echo(f"  DRY RUN - No database changes")
            if verbose:
                for social in socials[:10]:
                    click.echo(f"    {social.name}: {social.char_no_arg[:50] if social.char_no_arg else 'N/A'}...")
                if len(socials) > 10:
                    click.echo(f"    ... and {len(socials) - 10} more")
            return stats

        # Import each social
        for social in socials:
            try:
                result = await self._upsert_social(social)
                if result == "created":
                    stats["imported"] += 1
                    if verbose:
                        click.echo(f"    Created: {social.name}")
                elif result == "updated":
                    stats["updated"] += 1
                    if verbose:
                        click.echo(f"    Updated: {social.name}")
                else:
                    stats["skipped"] += 1
            except Exception as e:
                stats["errors"] += 1
                error_msg = f"{social.name}: {str(e)[:100]}"
                stats["error_details"].append(error_msg)
                if verbose:
                    click.echo(f"    Error: {error_msg}")

        return stats

    async def _upsert_social(self, social: Social) -> str:
        """
        Insert or update a single social in the database.

        Args:
            social: Parsed social data

        Returns:
            "created", "updated", or "unchanged"
        """
        position = POSITION_ENUM_MAP.get(social.min_victim_position, Position.STANDING)

        # Check if social exists
        existing = await self.prisma.social.find_unique(
            where={"name": social.name}
        )

        data = {
            "hide": social.hide,
            "minVictimPosition": position,
            "charNoArg": social.char_no_arg,
            "othersNoArg": social.others_no_arg,
            "charFound": social.char_found,
            "othersFound": social.others_found,
            "victFound": social.vict_found,
            "notFound": social.not_found,
            "charAuto": social.char_auto,
            "othersAuto": social.others_auto,
        }

        if existing:
            # Update existing
            await self.prisma.social.update(
                where={"name": social.name},
                data=data,
            )
            return "updated"
        else:
            # Create new
            await self.prisma.social.create(
                data={
                    "name": social.name,
                    **data,
                }
            )
            return "created"

    async def clear_socials(self) -> int:
        """
        Delete all socials from the database.

        Returns:
            Number of socials deleted
        """
        result = await self.prisma.social.delete_many()
        # Prisma Python client returns int directly from delete_many
        return result if isinstance(result, int) else result.count


async def seed_socials_from_lib(
    prisma: Prisma,
    lib_path: Path,
    dry_run: bool = False,
    verbose: bool = False,
) -> dict:
    """
    Convenience function to seed socials.

    Args:
        prisma: Connected Prisma client
        lib_path: Path to legacy lib directory
        dry_run: If True, don't write to database
        verbose: If True, show detailed progress

    Returns:
        Import statistics dictionary
    """
    seeder = SocialsSeeder(prisma)
    return await seeder.seed_socials(lib_path, dry_run=dry_run, verbose=verbose)
