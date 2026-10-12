"""Per-sphere display colours (SphereStyle table).

The game used to hard-code two copies of this palette (spells/skills listings and the
`<fire>`-style tag aliases). The colour is an XML-Lite tag body without brackets
("red", "b:cyan"). GENERIC has no colour (NULL = the listing's dim fallback).

Mirrored by ``data/sql/2026-10-12-sphere-colors.sql`` (a test keeps the two in sync).
Existing non-NULL colours are never overwritten, so builder edits in Muditor survive a
reseed.
"""

# (SpellSphere enum value, colour tag body or None)
SPHERE_STYLES = [
    ("FIRE", "red"),
    ("WATER", "cyan"),
    ("AIR", "b:cyan"),
    ("EARTH", "yellow"),
    ("HEALING", "green"),
    ("DEATH", "b:black"),
    ("PROTECTION", "b:white"),
    ("ENCHANTMENT", "magenta"),
    ("SUMMONING", "b:magenta"),
    ("DIVINATION", "b:yellow"),
    ("GENERIC", None),
]


class SphereStyleSeeder:
    def __init__(self, prisma):
        self.prisma = prisma

    async def seed_sphere_styles(self, verbose: bool = False) -> dict:
        """Create missing rows and fill NULL colours; returns {"changed": rows touched}.

        Raw SQL so it works with a Python Prisma client generated before the SphereStyle
        model existed (the Python generator cannot parse the Prisma 7 schema).
        """
        changed = 0
        for sphere, color in SPHERE_STYLES:
            n = await self.prisma.execute_raw(
                'INSERT INTO "SphereStyle" ("sphere", "color") VALUES ($1::"SpellSphere", $2) '
                'ON CONFLICT ("sphere") DO UPDATE SET "color" = EXCLUDED."color" '
                'WHERE "SphereStyle"."color" IS NULL AND EXCLUDED."color" IS NOT NULL',
                sphere,
                color,
            )
            changed += n
            if verbose:
                print(f"  {sphere}: {color} ({n} row(s))")
        return {"changed": changed}
