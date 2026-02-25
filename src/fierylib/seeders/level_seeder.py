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

            # HP/Stamina gains per level (simplified formula)
            # Higher levels = more gains, immortals get significant bonuses
            if is_immortal:
                hp_gain = 50  # Immortals get fixed large gains
                stamina_gain = 50
            else:
                # Mortal gains scale with level
                hp_gain = 10 + (level // 10)  # 10-19 per level
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
