"""Import help entries from CircleMUD help files into the database."""

import json
import click
import asyncio
from pathlib import Path
from typing import Dict, List, Any, Optional
from prisma import Prisma

from ..parsers.help_parser import HelpFileParser, parse_all_help_files, HelpEntry
from ..converters.color_converter import convert_legacy_colors, strip_legacy_colors


class HelpImporter:
    """Import help entries from .hlp files."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma
        self.stats = {
            "created": 0,
            "updated": 0,
            "skipped": 0,
            "errors": 0,
        }

    def _categorize_entry(self, entry: HelpEntry) -> Optional[str]:
        """Determine category based on entry content."""
        keywords_lower = [k.lower() for k in entry.keywords]

        # Check for spell/skill indicators
        if entry.sphere or entry.classes:
            if entry.usage and "cast" in entry.usage.lower():
                return "spell"
            elif entry.usage and "chant" in entry.usage.lower():
                return "chant"
            elif entry.usage and ("use" in entry.usage.lower() or "skill" in entry.content.lower()):
                return "skill"
            return "spell"  # Default for entries with sphere/classes

        # Check keywords for common patterns
        for kw in keywords_lower:
            if kw in ("toggle", "score", "who", "look", "inventory", "equipment"):
                return "command"
            if kw.startswith("spell_") or kw.startswith("skill_"):
                return "reference"

        # Check content for indicators
        content_lower = entry.content.lower()
        if "usage:" in content_lower:
            return "command"
        if "subclass" in content_lower or "class" in content_lower:
            return "class"
        if "race" in content_lower or "allowed races" in content_lower:
            return "race"
        if "area" in content_lower or "zone" in content_lower:
            return "area"

        return None

    async def import_help_files(
        self,
        help_dir: Path,
        verbose: bool = False,
        clear_existing: bool = False,
    ) -> Dict[str, int]:
        """Import all help files from a directory.

        Args:
            help_dir: Directory containing .hlp files
            verbose: Show detailed output
            clear_existing: Delete all existing help entries before import

        Returns:
            Dictionary with import statistics
        """

        if clear_existing:
            click.echo("  Clearing existing help entries...")
            deleted = await self.prisma.helpentry.delete_many()
            click.echo(f"  Deleted {deleted} entries")

        click.echo(f"\nParsing help files from {help_dir}...")
        parser = parse_all_help_files(help_dir)
        click.echo(f"  Found {len(parser.entries)} unique entries")

        # Track which entries we've processed (by primary keyword)
        processed = set()

        click.echo("\nImporting help entries...")

        for keyword, entry in parser.entries.items():
            # Skip if we've already processed this entry (via another keyword)
            primary_keyword = entry.keywords[0].lower() if entry.keywords else keyword
            if primary_keyword in processed:
                continue
            processed.add(primary_keyword)

            try:
                await self._import_entry(entry, keyword, verbose)
            except Exception as e:
                self.stats["errors"] += 1
                click.echo(f"  Error importing '{keyword}': {e}")

        return self.stats

    async def _import_entry(self, entry: HelpEntry, keyword: str, verbose: bool):
        """Import a single help entry."""

        # Normalize keywords for storage (strip color codes)
        keywords = [strip_legacy_colors(k).lower().strip() for k in entry.keywords if k.strip()]

        # Generate title from first keyword (strip any color codes)
        title = entry.keywords[0] if entry.keywords else keyword
        title = strip_legacy_colors(title)
        title = title.replace("_", " ").title()

        # Determine category
        category = self._categorize_entry(entry)

        # Convert legacy color codes to XML-Lite markup
        content = convert_legacy_colors(entry.content)

        # Build data for database
        data: Dict[str, Any] = {
            "keywords": keywords,
            "title": title,
            "content": content,
            "minLevel": entry.min_level,
        }

        # Only add optional fields if they have values
        if category:
            data["category"] = category
        if entry.usage:
            data["usage"] = convert_legacy_colors(entry.usage)
        if entry.duration:
            data["duration"] = entry.duration
        if entry.sphere:
            data["sphere"] = entry.sphere
        if entry.classes:
            data["classes"] = json.dumps(entry.classes)

        # Check if entry exists (by primary keyword)
        primary_kw = keywords[0] if keywords else keyword.lower()

        # Look for existing entry with matching keyword
        existing = await self.prisma.helpentry.find_first(
            where={"keywords": {"has": primary_kw}}
        )

        if existing:
            await self.prisma.helpentry.update(
                where={"id": existing.id},
                data=data,
            )
            self.stats["updated"] += 1
            if verbose:
                click.echo(f"  Updated: {title}")
        else:
            await self.prisma.helpentry.create(data=data)
            self.stats["created"] += 1
            if verbose:
                click.echo(f"  Created: {title}")


async def import_help_entries(
    help_dir: Path,
    verbose: bool = False,
    clear_existing: bool = False,
) -> Dict[str, int]:
    """Main entry point for importing help entries."""
    prisma = Prisma()
    await prisma.connect()

    try:
        importer = HelpImporter(prisma)
        return await importer.import_help_files(help_dir, verbose, clear_existing)
    finally:
        await prisma.disconnect()


@click.command(name="help-entries")
@click.option("--verbose", "-v", is_flag=True, help="Show detailed output")
@click.option("--clear", is_flag=True, help="Clear existing entries before import")
@click.argument("help_dir", type=click.Path(exists=True), required=False)
def import_help_cli(verbose: bool, clear: bool, help_dir: Optional[str]):
    """Import help entries from CircleMUD help files.

    HELP_DIR: Path to directory containing .hlp help files
    (default: fierymud/legacy/lib/text/help/)
    """

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
        click.echo("Error: Could not find help directory. Please specify path.")
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


if __name__ == "__main__":
    import_help_cli()
