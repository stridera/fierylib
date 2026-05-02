"""Achievement catalog seeder.

Achievements are referenced by stable `code` strings from runtime
event hooks (e.g. ``grant_achievement(player, "first_kill")``).
Codes are immutable once shipped — the runtime catalog references
them by string. Title/description/sort_order are safe to edit.

Two flavors are seeded here:

  - Hardcoded combat / progression achievements (first_kill, level_*).
  - One ``zone_<id>_cleared`` row per zone with rooms, generated from
    a live DB query so new zones are picked up automatically.
"""

import click
import logging
from prisma import Prisma

logger = logging.getLogger(__name__)


# Static achievements. Each tuple: (code, title, description, category,
# hidden, sort_order). category must match the AchievementCategory enum.
STATIC_ACHIEVEMENTS = [
    (
        "first_kill",
        "First Blood",
        "Defeat your first foe in combat.",
        "COMBAT",
        False,
        10,
    ),
    (
        "level_5",
        "Apprentice",
        "Reach level 5.",
        "MISC",
        False,
        50,
    ),
    (
        "level_15",
        "Journeyman",
        "Reach level 15.",
        "MISC",
        False,
        150,
    ),
    (
        "level_30",
        "Expert",
        "Reach level 30.",
        "MISC",
        False,
        300,
    ),
    (
        "level_50",
        "Master",
        "Reach level 50.",
        "MISC",
        False,
        500,
    ),
    (
        "level_75",
        "Grandmaster",
        "Reach level 75.",
        "MISC",
        False,
        750,
    ),
    (
        "level_100",
        "Avatar",
        "Reach level 100 — ascend to immortality.",
        "MISC",
        False,
        1000,
    ),
]


class AchievementSeeder:
    """Upsert achievement catalog rows."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    async def seed(self) -> dict:
        created = 0
        updated = 0

        # Static achievements.
        for code, title, desc, category, hidden, sort_order in STATIC_ACHIEVEMENTS:
            existed = await self.prisma.achievement.find_unique(where={"code": code})
            await self.prisma.achievement.upsert(
                where={"code": code},
                data={
                    "create": {
                        "code": code,
                        "title": title,
                        "description": desc,
                        "category": category,
                        "hidden": hidden,
                        "sortOrder": sort_order,
                    },
                    "update": {
                        "title": title,
                        "description": desc,
                        "category": category,
                        "hidden": hidden,
                        "sortOrder": sort_order,
                    },
                },
            )
            if existed:
                updated += 1
            else:
                created += 1

        # Zone-clear achievements: one per zone with rooms.
        zone_rows = await self.prisma.query_raw(
            'SELECT z.id, z.name, COUNT(r.id)::int AS room_count '
            'FROM "Zones" z JOIN "Room" r ON r.zone_id = z.id '
            'GROUP BY z.id, z.name HAVING COUNT(r.id) > 0 '
            'ORDER BY z.id'
        )
        for row in zone_rows:
            zone_id = row["id"]
            zone_name = row["name"]
            code = f"zone_{zone_id}_cleared"
            title = f"Walked: {zone_name}"
            desc = f"Visit every room in {zone_name}."
            existed = await self.prisma.achievement.find_unique(where={"code": code})
            await self.prisma.achievement.upsert(
                where={"code": code},
                data={
                    "create": {
                        "code": code,
                        "title": title,
                        "description": desc,
                        "category": "EXPLORATION",
                        "hidden": False,
                        "sortOrder": zone_id * 10,
                    },
                    "update": {
                        "title": title,
                        "description": desc,
                        "category": "EXPLORATION",
                        "hidden": False,
                        "sortOrder": zone_id * 10,
                    },
                },
            )
            if existed:
                updated += 1
            else:
                created += 1

        return {"created": created, "updated": updated}


async def seed_achievements_async() -> dict:
    prisma = Prisma()
    await prisma.connect()
    try:
        return await AchievementSeeder(prisma).seed()
    finally:
        await prisma.disconnect()


@click.command(name="achievements")
def seed_achievements():
    """Seed the achievement catalog."""
    import asyncio

    click.echo("🏆 Seeding Achievements")
    click.echo("=" * 60)
    stats = asyncio.run(seed_achievements_async())
    click.echo(f"  Created:  {stats['created']}")
    click.echo(f"  Updated:  {stats['updated']}")
    click.echo("✅ Done")
