"""Race seeding functionality"""

import click
import asyncio
from pathlib import Path
from fierylib.importers.race_importer import import_races_from_json

@click.command(name="races")
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
    import json
    from fierylib.parsers.cpp_race_parser import parse_races_cpp

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
