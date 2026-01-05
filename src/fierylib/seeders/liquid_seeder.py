"""Liquid types seeding functionality - imports liquid metadata for drink containers"""

import click
import asyncio
import logging

logger = logging.getLogger(__name__)

# Liquid data extracted from legacy/src/objects.hpp liquid_types array
# Format: (alias, name, color_desc, drunk_effect, hunger_effect, thirst_effect)
LIQUID_DATA = [
    ("water", "water", "clear", 0, 0, 10),
    ("beer", "beer", "brown", 3, 2, 5),
    ("wine", "wine", "clear", 5, 2, 5),
    ("ale", "ale", "brown", 2, 2, 5),
    ("dark-ale", "dark ale", "dark", 1, 2, 5),
    ("whisky", "whisky", "golden", 6, 1, 4),
    ("lemonade", "lemonade", "yellow", 0, 1, 8),
    ("firebreather", "firebreather", "green", 10, 0, 0),
    ("local-speciality", "local speciality", "clear", 3, 3, 3),
    ("slime-mold-juice", "slime mold juice", "light green", 0, 4, -8),
    ("milk", "milk", "white", 0, 3, 6),
    ("black-tea", "black tea", "brown", 0, 1, 6),
    ("coffee", "coffee", "black", 0, 1, 6),
    ("blood", "blood", "red", 0, 2, -1),
    ("salt-water", "salt water", "clear", 0, 1, -2),
    ("rum", "rum", "light brown", 5, 2, 3),
    ("nectar", "nectar", "yellow", -1, 12, 12),
    ("sake", "sake", "clearish", 6, 1, 4),
    ("cider", "cider", "dark brown", 1, 1, 5),
    ("tomato-soup", "tomato soup", "thick red", 0, 7, 3),
    ("potato-soup", "potato soup", "thick, light brown", 0, 8, 4),
    ("chai", "chai", "light brown", 0, 2, 5),
    ("apple-juice", "apple juice", "dark yellow", 0, 2, 6),
    ("orange-juice", "orange juice", "fruity orange", 0, 3, 5),
    ("pineapple-juice", "pineapple juice", "thin yellow", 0, 2, 6),
    ("grape-juice", "grape juice", "deep purple", 0, 2, 6),
    ("pomegranate-juice", "pomegranate juice", "dark red", 0, 3, 6),
    ("melonade", "melonade", "pink", 0, 1, 8),
    ("cocoa", "cocoa", "thick brown", 0, 3, 5),
    ("espresso", "espresso", "dark brown", 0, 1, 4),
    ("cappuccino", "cappuccino", "light brown", 0, 2, 4),
    ("mango-lassi", "mango lassi", "thick yellow", 0, 4, 4),
    ("rosewater", "rosewater", "light pink", 0, 0, 0),
    ("green-tea", "green tea", "pale green", 0, 1, 6),
    ("chamomile-tea", "chamomile tea", "clearish", 0, 1, 7),
    ("gin", "gin", "clear", 5, 0, 3),
    ("brandy", "brandy", "amber", 5, 0, 3),
    ("mead", "mead", "golden", 2, 0, 3),
    ("champagne", "champagne", "sparkly", 7, 0, 1),
    ("vodka", "vodka", "clear", 6, 0, 3),
    ("tequila", "tequila", "gold", 5, 0, 3),
    ("absinthe", "absinthe", "greenish", 8, 0, 2),
]


@click.command(name="liquids")
@click.option(
    "--dry-run",
    is_flag=True,
    default=False,
    help="Validate without importing to database",
)
def seed_liquids(dry_run: bool):
    """Seed liquid types for drink containers"""
    from prisma import Prisma

    async def run_seed():
        click.echo("🥤 Seeding Liquid Types")
        click.echo("=" * 60)

        if dry_run:
            click.echo("DRY RUN - No changes will be made\n")
            for i, (alias, name, color, drunk, hunger, thirst) in enumerate(LIQUID_DATA):
                alcoholic = "yes" if drunk > 0 else "no"
                click.echo(f"  {i:2d}. {name:<20s} | {color:<20s} | alc={alcoholic}")
            click.echo(f"\n  Total: {len(LIQUID_DATA)} liquid types")
            return

        prisma = Prisma()
        await prisma.connect()

        try:
            created = 0
            updated = 0

            for alias, name, color_desc, drunk, hunger, thirst in LIQUID_DATA:
                result = await prisma.liquid.upsert(
                    where={"alias": alias},
                    data={
                        "create": {
                            "name": name,
                            "alias": alias,
                            "colorDesc": color_desc,
                            "drunkEffect": drunk,
                            "hungerEffect": hunger,
                            "thirstEffect": thirst,
                        },
                        "update": {
                            "name": name,
                            "colorDesc": color_desc,
                            "drunkEffect": drunk,
                            "hungerEffect": hunger,
                            "thirstEffect": thirst,
                        },
                    },
                )

                # Check if this was a create or update by comparing timestamps
                # (Prisma doesn't return this info directly, so we just count)
                created += 1

            click.echo(f"\n✅ Seeded {created} liquid types")

        finally:
            await prisma.disconnect()

    asyncio.run(run_seed())
