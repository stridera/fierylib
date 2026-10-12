"""Spell-slot recovery time per circle (SpellCircle table).

fierymud-rs used to hard-code these as CIRCLE_RECOVER_TIME (legacy spell_mem.cpp
``circle_recover_time[]``). The value is the base seconds a spent slot of the circle takes to
recover, before the caster's focus rate. Circle 14 is extrapolated (the legacy table stops
at 12 entries).

Mirrored by ``data/sql/2026-10-12-spell-circle-recover.sql`` (a test keeps the two in sync).
Existing non-NULL times are never overwritten, so builder edits in Muditor survive a reseed.
"""

# (circle, recover_secs)
SPELL_CIRCLES = [
    (1, 30),
    (2, 35),
    (3, 50),
    (4, 65),
    (5, 80),
    (6, 95),
    (7, 130),
    (8, 145),
    (9, 165),
    (10, 210),
    (11, 250),
    (12, 290),
    (13, 310),
    (14, 330),
]


class SpellCircleSeeder:
    def __init__(self, prisma):
        self.prisma = prisma

    async def seed_spell_circles(self, verbose: bool = False) -> dict:
        """Create missing rows and fill NULL times; returns {"changed": rows touched}.

        Raw SQL so it works with a Python Prisma client generated before the SpellCircle
        model existed (the Python generator cannot parse the Prisma 7 schema).
        """
        changed = 0
        for circle, recover_secs in SPELL_CIRCLES:
            n = await self.prisma.execute_raw(
                'INSERT INTO "SpellCircle" ("circle", "recover_secs") VALUES ($1, $2) '
                'ON CONFLICT ("circle") DO UPDATE SET "recover_secs" = EXCLUDED."recover_secs" '
                'WHERE "SpellCircle"."recover_secs" IS NULL',
                circle,
                recover_secs,
            )
            changed += n
            if verbose:
                print(f"  circle {circle}: {recover_secs}s ({n} row(s))")
        return {"changed": changed}
