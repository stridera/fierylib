"""Level definition seeder for FieryMUD.

Seeds all 105 levels with experience requirements, stat gains, and immortal permissions.
Based on the level constants from legacy/src/defines.hpp.
"""

import click
import math
from prisma import Prisma


class LevelSeeder:
    """Seeds level definitions into the LevelDefinition table."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    def calculate_exp_for_level(self, level: int, exponent: float = 2.5, multiplier: int = 1000) -> int:
        """Calculate experience required for a level using the standard formula.

        Formula: level^exponent * multiplier
        """
        if level <= 1:
            return 0
        return int(math.pow(level, exponent) * multiplier)

    def get_immortal_permissions(self, level: int) -> list[str]:
        """Get permissions for immortal levels based on legacy FieryMUD hierarchy.

        Returns Permission enum values matching the Prisma schema.
        """
        permissions = []

        # Level 100 - Avatar (LVL_IMMORT)
        if level >= 100:
            permissions.extend([
                "TELEPORT",      # goto
                "TRANSFER",      # transfer players
                "INVISIBLE",     # immortal invisibility
                "NOHASSLE",      # immune to mob aggro
                "WIZNET",        # immortal chat channel
            ])

        # Level 101 - Demi-God (LVL_GOD)
        if level >= 101:
            permissions.extend([
                "ZONE_RESET",    # zreset
                "ADVANCE",       # change player levels
                "RESTORE",       # fully restore players
                "SNOOP",         # monitor player sessions
            ])

        # Level 102 - Lesser God (LVL_GRGOD)
        if level >= 102:
            permissions.extend([
                "FREEZE",        # freeze players
                "THAW",          # unfreeze players
                "DC",            # disconnect players
                "FORCE",         # force players to execute commands
            ])

        # Level 103 - Greater God (LVL_HEAD_B / GAMEMASTER)
        if level >= 103:
            permissions.extend([
                "BAN",           # ban players/IPs
                "UNBAN",         # remove bans
                "SQUELCH",       # squelch players from channels
                "WIZLOCK",       # lock out mortals
                "NOTITLE",       # remove player titles
            ])

        # Level 104 - Implementer (LVL_HEAD_C / ADMIN / BUILDER)
        if level >= 104:
            permissions.extend([
                "OLC",           # online creation system
                "BUILD",         # builder commands
                "SYSLOG",        # view system logs
                "LOG",           # toggle logging on players
            ])

        # Level 105 - Overlord (LVL_IMPL)
        if level >= 105:
            permissions.extend([
                "SHUTDOWN",      # shut down the MUD
                "CODE",          # coding/debugging commands
                "ADMIN",         # administrative commands
                "GOD",           # full god-level access
                "SUMMON",        # summon players
            ])

        return permissions

    def get_level_name(self, level: int) -> str | None:
        """Get the display name for special levels."""
        level_names = {
            100: "Avatar",
            101: "Demi-God",
            102: "Lesser God",
            103: "Greater God",
            104: "Implementer",
            105: "Overlord",
        }
        return level_names.get(level)

    async def seed_levels(
        self,
        max_level: int = 105,
        exp_exponent: float = 2.5,
        exp_multiplier: int = 1000,
        verbose: bool = False,
    ) -> dict:
        """Seed all level definitions.

        Args:
            max_level: Maximum level to seed (default 105)
            exp_exponent: Exponent for experience formula
            exp_multiplier: Multiplier for experience formula
            verbose: Show detailed output

        Returns:
            Statistics dict with created/updated counts
        """
        stats = {"created": 0, "updated": 0, "total": 0}

        for level in range(1, max_level + 1):
            exp_required = self.calculate_exp_for_level(level, exp_exponent, exp_multiplier)
            is_immortal = level >= 100
            name = self.get_level_name(level)
            permissions = self.get_immortal_permissions(level) if is_immortal else []

            # HP/Stamina gains per level.
            #
            # ``hp_gain`` is the class-agnostic baseline added to the
            # per-class roll at level-up:
            #   gain = (LevelDef.hp_gain * race.hp_factor / 100).max(1)
            #          + Class.hp_per_level
            #          + roll(Class.hit_dice)
            # Initially flattened to 5 (Step 2, May 2026), then bumped
            # to 8 in Step 4 / Path C after the empirical sweep in
            # gear-curves §7 showed solo warrior losing at L15+ with
            # the 5 baseline. 8 keeps the per-class spread the
            # ``Class.hp_per_level`` + ``Class.hit_dice`` provide while
            # restoring enough HP to survive contemporary trash mob
            # damage curves.
            if is_immortal:
                hp_gain = 50  # Immortals get fixed large gains
                stamina_gain = 50
            else:
                hp_gain = 8
                stamina_gain = 5 + (level // 20)  # 5-9 per level

            # Check if level already exists
            existing = await self.prisma.leveldefinition.find_unique(
                where={"level": level}
            )

            if existing:
                await self.prisma.leveldefinition.update(
                    where={"level": level},
                    data={
                        "name": name,
                        "expRequired": exp_required,
                        "hpGain": hp_gain,
                        "staminaGain": stamina_gain,
                        "isImmortal": is_immortal,
                        "permissions": permissions,
                    },
                )
                stats["updated"] += 1
            else:
                await self.prisma.leveldefinition.create(
                    data={
                        "level": level,
                        "name": name,
                        "expRequired": exp_required,
                        "hpGain": hp_gain,
                        "staminaGain": stamina_gain,
                        "isImmortal": is_immortal,
                        "permissions": permissions,
                    },
                )
                stats["created"] += 1

            stats["total"] += 1

            if verbose:
                if is_immortal:
                    click.echo(f"    Level {level} ({name}): Immortal, {len(permissions)} permissions")
                elif level % 10 == 0:
                    click.echo(f"    Level {level}: {exp_required:,} XP, +{hp_gain} HP")

        return stats
