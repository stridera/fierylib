"""Level definition seeder for FieryMUD.

Seeds all 105 levels with experience requirements, stat gains, and immortal permissions.
Based on the level constants from legacy/src/defines.hpp.

Experience curve: ported exactly from legacy ``init_exp_table`` /
``exp_next_level`` (fierymud_legacy/src/utils.cpp). ``LevelDefinition.expRequired``
holds the class-neutral table (gain factor 1.0); the per-class "exp needed to
level" factor lives in ``Class.expGainFactor`` (seeded from
``data/classes.json``) and the game multiplies at load time, truncating, as
legacy does.
"""

import json
from pathlib import Path

import click
from prisma import Prisma

LVL_IMMORT = 100
LVL_IMPL = 105

# Legacy ``eval[]`` in init_exp_table: (level, static_add, level_mod, multiplier).
_EVAL = (
    (0, 44000, 8, 12500),
    (17, 144000, 16, 17500),
    (25, 284000, 24, 22500),
    (33, 464000, 32, 25000),
    (49, 864000, 48, 30000),
    (90, 2094000, 89, 60000),
    (92, 2214000, 91, 70000),
    (95, 2424000, 94, 80000),
    (96, 2504000, 95, 90000),
    (98, 2684000, 97, 100000),
)

CLASSES_JSON = Path(__file__).resolve().parents[3] / "data" / "classes.json"


def _eval_segment(level: int) -> tuple[int, int, int, int]:
    """Last ``_EVAL`` entry whose starting level is <= ``level``."""
    seg = _EVAL[0]
    for entry in _EVAL:
        if level >= entry[0]:
            seg = entry
    return seg


def legacy_exp_table() -> list[int]:
    """Legacy ``exp_table[0..LVL_IMPL]``: XP needed to finish level N (reach N+1).

    Port of ``init_exp_table`` in fierymud_legacy/src/utils.cpp.
    """
    table: list[int] = []
    last_exp = 0
    for lvl in range(LVL_IMPL + 1):
        if lvl < 9:
            exp = ((lvl * lvl) + lvl) // 2 * 5500
        elif lvl < 99:
            _, static_add, level_mod, mult = _eval_segment(lvl)
            exp = static_add + (lvl - level_mod) * mult + last_exp
        elif lvl == 99:
            _, static_add, level_mod, mult = _eval_segment(lvl)
            exp = static_add + (lvl - level_mod) * mult
            _, static_add, level_mod, mult = _eval_segment(lvl + 1)
            exp += static_add + (lvl + 1 - level_mod) * mult
            exp += last_exp
        else:
            exp = 300000001 + 2 * (lvl - LVL_IMMORT - 1)
        table.append(exp)
        last_exp = exp
    return table


def exp_required_for_level(level: int) -> int:
    """Class-neutral cumulative XP needed to *reach* ``level`` (1..LVL_IMPL).

    Legacy ``exp_next_level(level - 1)`` at gain factor 1. Level 1 is 0.
    """
    if level <= 1:
        return 0
    return legacy_exp_table()[level - 1]


def class_exp_factors(path: Path = CLASSES_JSON) -> dict[str, float]:
    """``plainName`` -> legacy ``exp_gain_factor`` from ``data/classes.json``."""
    data = json.loads(path.read_text(encoding="utf-8"))
    return {
        c["plainName"]: float(c["expGainFactor"])
        for c in data.get("classes", [])
        if c.get("plainName") and "expGainFactor" in c
    }


class LevelSeeder:
    """Seeds level definitions into the LevelDefinition table."""

    def __init__(self, prisma: Prisma):
        self.prisma = prisma

    def calculate_exp_for_level(self, level: int) -> int:
        """Class-neutral XP needed to reach ``level`` (legacy exp table)."""
        return exp_required_for_level(level)

    async def seed_class_exp_factors(self) -> int:
        """Set ``Class.expGainFactor`` from ``data/classes.json``. Returns rows updated."""
        updated = 0
        for plain_name, factor in class_exp_factors().items():
            result = await self.prisma.characterclass.update_many(
                where={"plainName": plain_name},
                data={"expGainFactor": factor},
            )
            updated += result if isinstance(result, int) else 0
        return updated

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
        verbose: bool = False,
    ) -> dict:
        """Seed all level definitions.

        Args:
            max_level: Maximum level to seed (default 105)
            verbose: Show detailed output

        Returns:
            Statistics dict with created/updated counts
        """
        stats = {"created": 0, "updated": 0, "total": 0}

        stats["class_factors"] = await self.seed_class_exp_factors()

        for level in range(1, max_level + 1):
            exp_required = self.calculate_exp_for_level(level)
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
