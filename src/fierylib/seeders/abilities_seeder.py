"""Abilities seeding functionality - imports abilities from abilities.json and links their effects."""

import click
import asyncio
import json
from pathlib import Path
from typing import List, Dict, Any, Optional
from prisma import Prisma


def load_abilities_from_json() -> List[Dict[str, Any]]:
    """Load abilities from the data/abilities.json file."""
    abilities_path = Path(__file__).parent.parent.parent.parent / "data" / "abilities.json"
    with open(abilities_path, 'r') as f:
        return json.load(f)


class AbilitiesSeeder:
    """Seeds abilities into the database and links their effects."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma
        self._effect_cache: Dict[str, int] = {}  # effect_name -> id
        self._ability_cache: Dict[str, int] = {}  # plainName -> id

    async def _load_effect_cache(self) -> None:
        """Load all effects into cache for fast lookup."""
        effects = await self.prisma.effect.find_many()
        for effect in effects:
            self._effect_cache[effect.name.lower()] = effect.id

    async def _load_ability_cache(self) -> None:
        """Load all abilities into cache for fast lookup."""
        abilities = await self.prisma.ability.find_many()
        for ability in abilities:
            self._ability_cache[ability.plainName.lower()] = ability.id

    async def link_ability_effects(
        self,
        dry_run: bool = False,
        verbose: bool = False
    ) -> Dict[str, int]:
        """
        Link abilities to their effects based on abilities.json data.

        Returns:
            Stats dictionary with counts
        """
        stats = {"linked": 0, "effects_created": 0, "skipped": 0, "errors": 0}

        # Load caches
        await self._load_effect_cache()
        await self._load_ability_cache()

        abilities_data = load_abilities_from_json()

        for ability_data in abilities_data:
            effects = ability_data.get("effects", [])
            if not effects:
                stats["skipped"] += 1
                continue

            # Find the ability by plainName
            plain_name = ability_data.get("plainName", "").lower()
            ability_id = self._ability_cache.get(plain_name)

            if not ability_id:
                # Try matching by name
                name = ability_data.get("name", "").lower().replace(" ", "_")
                ability_id = self._ability_cache.get(name)

            if not ability_id:
                if verbose:
                    click.echo(f"  Warning: Ability not found: {ability_data.get('name')}")
                stats["errors"] += 1
                continue

            if dry_run:
                if verbose:
                    click.echo(f"  [DRY] Would link {len(effects)} effects to {ability_data.get('name')}")
                stats["linked"] += 1
                stats["effects_created"] += len(effects)
                continue

            try:
                # Delete existing effects for this ability
                await self.prisma.abilityeffect.delete_many(
                    where={"abilityId": ability_id}
                )

                # Create new effect links
                for effect_data in effects:
                    effect_name = effect_data.get("effect", "").lower()
                    effect_id = self._effect_cache.get(effect_name)

                    if not effect_id:
                        if verbose:
                            click.echo(f"  Warning: Effect not found: {effect_name}")
                        continue

                    await self.prisma.abilityeffect.create(
                        data={
                            "abilityId": ability_id,
                            "effectId": effect_id,
                            "overrideParams": json.dumps(effect_data.get("params", {})),
                            "order": effect_data.get("order", 0),
                            "trigger": effect_data.get("trigger"),
                            "chancePct": effect_data.get("chancePct", 100),
                            "condition": effect_data.get("condition"),
                        }
                    )
                    stats["effects_created"] += 1

                stats["linked"] += 1
                if verbose:
                    click.echo(f"  Linked {len(effects)} effects to {ability_data.get('name')}")

            except Exception as e:
                click.echo(f"  Error linking {ability_data.get('name')}: {e}")
                stats["errors"] += 1

        return stats


@click.command(name="link-effects")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without writing to database",
)
@click.option(
    "--verbose",
    is_flag=True,
    default=False,
    help="Show detailed output",
)
def link_ability_effects_cmd(dry_run: bool, verbose: bool):
    """Link abilities to their effects from abilities.json."""

    async def run_link():
        abilities = load_abilities_from_json()
        abilities_with_effects = sum(1 for a in abilities if a.get("effects"))
        click.echo(f"Linking Ability Effects ({abilities_with_effects} abilities with effects)")
        click.echo("=" * 60)

        prisma = Prisma()
        await prisma.connect()

        try:
            seeder = AbilitiesSeeder(prisma)
            stats = await seeder.link_ability_effects(dry_run=dry_run, verbose=verbose)

            click.echo()
            click.echo("Summary:")
            click.echo(f"  Abilities linked: {stats['linked']}")
            click.echo(f"  Effects created: {stats['effects_created']}")
            click.echo(f"  Skipped (no effects): {stats['skipped']}")
            click.echo(f"  Errors: {stats['errors']}")

            if dry_run:
                click.echo()
                click.echo("(DRY RUN - no changes made)")
            else:
                click.echo()
                click.echo("Ability effects linking complete!")

        finally:
            await prisma.disconnect()

    asyncio.run(run_link())
