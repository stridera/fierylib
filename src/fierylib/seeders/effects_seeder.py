"""Effects seeding functionality for the new parameterized effects system"""

import click
import asyncio
import json
from pathlib import Path
from typing import List, Dict, Any
from prisma import Prisma


# Toolbox categories for the visual effect editor
# Each category has a display name, color, order, and list of effect names
TOOLBOX_CATEGORIES = [
    {
        "name": "Damage & Healing",
        "colour": "#e53935",
        "displayOrder": 1,
        "effects": ["damage", "heal"],
    },
    {
        "name": "Status & Buffs",
        "colour": "#8e24aa",
        "displayOrder": 2,
        "effects": ["status", "modify", "globe"],
    },
    {
        "name": "Cleansing & Dispel",
        "colour": "#43a047",
        "displayOrder": 3,
        "effects": ["cleanse", "dispel", "reveal"],
    },
    {
        "name": "Movement & Position",
        "colour": "#00897b",
        "displayOrder": 4,
        "effects": ["teleport", "move", "extract"],
    },
    {
        "name": "Combat",
        "colour": "#1e88e5",
        "displayOrder": 5,
        "effects": ["interrupt", "transform"],
    },
    {
        "name": "Creation & Summoning",
        "colour": "#5e35b1",
        "displayOrder": 6,
        "effects": ["summon", "create", "enchant"],
    },
    {
        "name": "Room Effects",
        "colour": "#f4511e",
        "displayOrder": 7,
        "effects": ["room"],
    },
    {
        "name": "Special",
        "colour": "#6d4c41",
        "displayOrder": 8,
        "effects": ["resurrect"],
    },
    {
        "name": "Gates",
        "colour": "#00acc1",
        "displayOrder": 9,
        "effects": [],  # Gates are not effects, but kept for toolbox organization
    },
]


def load_effects_from_json() -> List[Dict[str, Any]]:
    """Load effects from the data/effects.json file."""
    effects_path = Path(__file__).parent.parent.parent.parent / "data" / "effects.json"
    with open(effects_path, 'r') as f:
        return json.load(f)


class EffectsSeeder:
    """Seeds the parameterized effects into the Effect table"""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma
        self._category_map: Dict[str, int] = {}  # effect_name -> category_id

    async def seed_toolbox_categories(self, dry_run: bool = False, verbose: bool = False) -> Dict[str, int]:
        """
        Seed toolbox categories for the visual effect editor.

        Returns:
            Stats dictionary with counts
        """
        stats = {"created": 0, "updated": 0}

        # Build effect -> category_id mapping
        self._category_map = {}

        for cat_data in TOOLBOX_CATEGORIES:
            try:
                # Check if category exists
                existing = await self.prisma.toolboxcategory.find_first(
                    where={"name": cat_data["name"]}
                )

                if dry_run:
                    # In dry-run mode, just report what would happen
                    if existing:
                        stats["updated"] += 1
                        if verbose:
                            click.echo(f"  [DRY] Would update category: {cat_data['name']}")
                    else:
                        stats["created"] += 1
                        if verbose:
                            click.echo(f"  [DRY] Would create category: {cat_data['name']}")
                    continue

                # Actually create/update the category
                if existing:
                    await self.prisma.toolboxcategory.update(
                        where={"id": existing.id},
                        data={
                            "colour": cat_data["colour"],
                            "displayOrder": cat_data["displayOrder"],
                        }
                    )
                    category_id = existing.id
                    stats["updated"] += 1
                    if verbose:
                        click.echo(f"  Updated category: {cat_data['name']}")
                else:
                    result = await self.prisma.toolboxcategory.create(
                        data={
                            "name": cat_data["name"],
                            "colour": cat_data["colour"],
                            "displayOrder": cat_data["displayOrder"],
                        }
                    )
                    category_id = result.id
                    stats["created"] += 1
                    if verbose:
                        click.echo(f"  + Created category: {cat_data['name']}")

                # Map effects to this category
                for effect_name in cat_data["effects"]:
                    self._category_map[effect_name] = category_id

            except Exception as e:
                click.echo(f"  Error seeding category {cat_data['name']}: {e}")

        return stats

    async def seed(self, dry_run: bool = False, verbose: bool = False) -> Dict[str, int]:
        """
        Seed all effects into the database from data/effects.json.

        Args:
            dry_run: If True, only validate without writing
            verbose: If True, show detailed output for each effect

        Returns:
            Stats dictionary with counts
        """
        effects = load_effects_from_json()
        stats = {"total": len(effects), "created": 0, "updated": 0, "skipped": 0, "errors": 0}

        for effect_data in effects:
            name = effect_data["name"]

            if dry_run:
                if verbose:
                    click.echo(f"  [DRY] Would upsert: {name} ({effect_data['effectType']})")
                stats["skipped"] += 1
                continue

            try:
                # Check if effect exists
                existing = await self.prisma.effect.find_unique(where={"name": name})

                # Look up category ID from the mapping built by seed_toolbox_categories()
                category_id = self._category_map.get(name)

                data = {
                    "name": name,
                    "effectType": effect_data["effectType"],
                    "description": effect_data.get("description"),
                    "tags": effect_data.get("tags", []),
                    "defaultParams": json.dumps(effect_data.get("defaultParams", {})),
                    "paramSchema": json.dumps(effect_data.get("paramSchema")) if effect_data.get("paramSchema") else None,
                    "categoryId": category_id,
                }

                if existing:
                    await self.prisma.effect.update(
                        where={"name": name},
                        data=data
                    )
                    if verbose:
                        click.echo(f"  Updated: {name}")
                    stats["updated"] += 1
                else:
                    await self.prisma.effect.create(data=data)
                    if verbose:
                        click.echo(f"  + Created: {name}")
                    stats["created"] += 1
            except Exception as e:
                click.echo(f"  Error seeding {name}: {e}")
                stats["errors"] += 1

        return stats

    async def cleanup_old_effects(self, verbose: bool = False) -> int:
        """Remove old effects that no longer exist in the consolidated schema."""
        # Get current effect names from effects.json
        effects = load_effects_from_json()
        current_effect_names = {e["name"] for e in effects}

        # Find effects in DB that are no longer in our schema
        all_db_effects = await self.prisma.effect.find_many()
        old_effects = [e for e in all_db_effects if e.name not in current_effect_names]

        if not old_effects:
            return 0

        # Delete old effects (AbilityEffects will cascade delete)
        for effect in old_effects:
            try:
                await self.prisma.effect.delete(where={"name": effect.name})
                if verbose:
                    click.echo(f"  - Removed old effect: {effect.name}")
            except Exception as e:
                click.echo(f"  Error removing {effect.name}: {e}")

        return len(old_effects)


@click.command(name="effects")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without writing to database",
)
@click.option(
    "--cleanup",
    is_flag=True,
    default=False,
    help="Remove old effects not in current schema",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed output",
)
def seed_effects(dry_run: bool, cleanup: bool, verbose: bool):
    """Seed the parameterized effects into the database from data/effects.json"""

    async def run_seed():
        effects = load_effects_from_json()
        click.echo(f"Seeding Effects ({len(effects)} parameterized effects)")
        click.echo("=" * 60)

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = EffectsSeeder(prisma)

            # Cleanup old effects if requested
            if cleanup and not dry_run:
                removed = await seeder.cleanup_old_effects(verbose)
                if removed:
                    click.echo(f"  Removed {removed} old effects")

            # Seed toolbox categories first (builds the category mapping)
            click.echo()
            click.echo("Seeding Toolbox Categories...")
            cat_stats = await seeder.seed_toolbox_categories(dry_run=dry_run, verbose=verbose)
            if not dry_run:
                click.echo(f"  Categories: {cat_stats['created']} created, {cat_stats['updated']} updated")

            # Seed effects (uses category mapping from above)
            click.echo()
            click.echo("Seeding Effects...")
            stats = await seeder.seed(dry_run=dry_run, verbose=verbose)

            click.echo()
            click.echo("Summary:")
            click.echo(f"  Categories: {cat_stats['created']} created, {cat_stats['updated']} updated")
            click.echo(f"  Effects: {stats['created']} created, {stats['updated']} updated, {stats['skipped']} skipped")

            if dry_run:
                click.echo()
                click.echo("(DRY RUN - no changes made)")
            else:
                click.echo()
                click.echo("Effects seeding complete!")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())
