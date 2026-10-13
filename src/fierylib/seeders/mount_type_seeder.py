"""Summon-mount tiers (MountType table).

The legacy ``mount_types`` table (act.other.cpp) was hard-coded in the game's summonmount
command: four tiers per alignment side (Paladin = "good", Anti-Paladin = "evil"), each with a
level and alignment gate, a mount mob prototype (zone 0, ids 45-52) and HP / movement bonuses.
Tier 1 is each side's base mount (always applies); ``min_alignment`` is a magnitude (an evil
summoner needs alignment <= -min_alignment).

Mirrored by ``data/sql/2026-10-13-mount-types.sql`` (a test keeps the two in sync). Rows that
already exist for a (tier, side) are never touched, so builder edits in Muditor survive a
reseed; a tier whose mount mob is not imported is skipped (the game then uses its built-in
table).
"""

# (tier, side, min_level, min_alignment, mob_zone_id, mob_id, hp_bonus, mv_bonus)
MOUNT_TYPES = [
    (1, "good", 0, 0, 0, 48, 0, 0),
    (1, "evil", 0, 0, 0, 47, 0, 0),
    (2, "good", 30, 700, 0, 49, 0, 0),
    (2, "evil", 30, 700, 0, 50, 0, 0),
    (3, "good", 60, 900, 0, 45, 50, 50),
    (3, "evil", 60, 900, 0, 46, 50, 50),
    (4, "good", 90, 1000, 0, 51, 100, 100),
    (4, "evil", 90, 1000, 0, 52, 100, 100),
]


class MountTypeSeeder:
    def __init__(self, prisma):
        self.prisma = prisma

    async def seed_mount_types(self, verbose: bool = False) -> dict:
        """Create missing tiers; returns {"changed": rows inserted}.

        Raw SQL so it works with a Python Prisma client generated before the MountType model
        existed (the Python generator cannot parse the Prisma 7 schema).
        """
        changed = 0
        for tier, side, min_level, min_align, zone, mob, hp, mv in MOUNT_TYPES:
            n = await self.prisma.execute_raw(
                'INSERT INTO "MountType" ("tier", "alignment_side", "min_level", '
                '"min_alignment", "mob_zone_id", "mob_id", "hp_bonus", "mv_bonus") '
                "SELECT $1::int, $2::text, $3::int, $4::int, $5::int, $6::int, $7::int, $8::int "
                'WHERE EXISTS (SELECT 1 FROM "Mobs" WHERE "zone_id" = $5::int AND "id" = $6::int) '
                'ON CONFLICT ("tier", "alignment_side") DO NOTHING',
                tier,
                side,
                min_level,
                min_align,
                zone,
                mob,
                hp,
                mv,
            )
            changed += n
            if verbose:
                print(f"  tier {tier} {side}: mob {zone}:{mob} ({n} row(s))")
        return {"changed": changed}
