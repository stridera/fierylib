"""
Mob Importer - Imports mobile (NPC) data from legacy files to PostgreSQL

Handles:
- Mobs with composite primary keys (zoneId, vnum)
- Mob stats, flags, and equipment
- Position, gender, race, class mappings
- Money and dice expressions
"""

from typing import Optional
from pathlib import Path
import sys
import re

from mud.types.mob import Mob
from mud.mudfile import MudData
from mud.bitflags import BitFlags
from fierylib.converters import legacy_id_to_composite, normalize_flags


def clamp_int32(value: int) -> int:
    """
    Clamp value to PostgreSQL Int (32-bit signed) range

    Prevents integer overflow when importing legacy mob wealth values.

    Args:
        value: Raw calculated wealth value

    Returns:
        Clamped value within Int32 range [-2147483648, 2147483647]
    """
    INT32_MAX = 2147483647
    INT32_MIN = -2147483648
    return max(INT32_MIN, min(INT32_MAX, value))


def pascal_to_screaming_snake(name: str) -> str:
    """
    Convert PascalCase to SCREAMING_SNAKE_CASE
    
    Examples:
        DragonGeneral -> DRAGON_GENERAL
        FaerieUnseelie -> FAERIE_UNSEELIE
        HalfElf -> HALF_ELF
    """
    # Insert underscore before uppercase letters (except at start)
    snake = re.sub(r'(?<=[a-z])(?=[A-Z])', '_', name)
    return snake.upper()


class MobImporter:
    """Imports mob data to PostgreSQL using Prisma"""

    def __init__(self, prisma_client):
        """
        Initialize mob importer

        Args:
            prisma_client: Prisma client instance
        """
        self.prisma = prisma_client
        self.vnum_map = {}  # vnum -> (zone_id, id) - built during import

    async def import_mob(self, mob: Mob, zone_id: int, dry_run: bool = False) -> dict:
        """
        Import a single mob to the database

        Args:
            mob: Parsed Mob object
            zone_id: Zone ID from filename (may differ from mob's actual zone)
            dry_run: If True, validate but don't write to database

        Returns:
            Dict with import results
        """
        # Use zone ID from filename (authoritative source)
        # Calculate ID by removing zone offset from vnum (supports >100 items per zone)
        # Example: In 117.mob, #11700 → (zone: 117, id: 0), #11800 → (zone: 117, id: 100)
        mob_zone_id = zone_id
        vnum = mob.id - (zone_id * 100)

        # Map enum values to strings (enums are already in SCREAMING_SNAKE_CASE)
        position = mob.position.name if hasattr(mob.position, "name") else str(mob.position).upper()
        default_position = mob.default_position.name if hasattr(mob.default_position, "name") else str(mob.default_position).upper()
        gender = mob.gender.name if hasattr(mob.gender, "name") else str(mob.gender).upper()
        race = mob.race.name if hasattr(mob.race, "name") else str(mob.race).upper()
        size = mob.size.name if hasattr(mob.size, "name") else str(mob.size).upper()
        life_force = mob.life_force.name if hasattr(mob.life_force, "name") else str(mob.life_force).upper()
        composition = mob.composition.name if hasattr(mob.composition, "name") else str(mob.composition).upper()
        stance = mob.stance.name if hasattr(mob.stance, "name") else str(mob.stance).upper()
        damage_type = mob.damage_type.name if hasattr(mob.damage_type, "name") else str(mob.damage_type).upper()
        mob_class = mob.mob_class.name if hasattr(mob.mob_class, "name") else str(mob.mob_class).upper()

        # Convert BitFlags to lists and normalize (NO_CHARM → NOCHARM)
        mob_flags = mob.mob_flags.json_repr() if isinstance(mob.mob_flags, BitFlags) else (mob.mob_flags or [])
        mob_flags = normalize_flags(mob_flags)
        effect_flags = mob.effect_flags.json_repr() if isinstance(mob.effect_flags, BitFlags) else (mob.effect_flags or [])
        effect_flags = normalize_flags(effect_flags)

        if dry_run:
            return {
                "success": True,
                "zone_id": mob_zone_id,
                "vnum": vnum,
                "keywords": mob.keywords,
                "action": "validated",
            }

        try:
            # Build vnum map entry (for reset lookups later)
            legacy_vnum = (zone_id * 100) + vnum if zone_id != 1000 else vnum
            if self.vnum_map is not None:
                self.vnum_map[legacy_vnum] = (mob_zone_id, vnum)

            # Upsert mob with composite key
            await self.prisma.mob.upsert(
                where={
                    "zoneId_id": {
                        "zoneId": mob_zone_id,
                        "id": vnum,
                    }
                },
                data={
                    "create": {
                        "id": vnum,
                        "zoneId": mob_zone_id,
                        "keywords": mob.keywords.split() if mob.keywords else [],
                        "mobClass": mob_class,
                        "shortDesc": mob.short_desc or "",
                        "longDesc": mob.long_desc or "",
                        "desc": mob.desc or "",
                        "mobFlags": mob_flags,
                        "effectFlags": effect_flags,
                        "alignment": mob.alignment,
                        "level": mob.level,
                        "hpDiceNum": mob.hp_dice.num,
                        "hpDiceSize": mob.hp_dice.size,
                        "hpDiceBonus": mob.hp_dice.bonus,
                        "armorClass": mob.ac,
                        "hitRoll": mob.hit_roll,
                        "damageDiceNum": mob.damage_dice.num,
                        "damageDiceSize": mob.damage_dice.size,
                        "damageDiceBonus": mob.damage_dice.bonus,
                        "copper": mob.money.copper,
                        "silver": mob.money.silver,
                        "gold": mob.money.gold,
                        "platinum": mob.money.platinum,
                        "position": position,
                        "gender": gender,
                        "race": race,
                        "size": size,
                        "strength": mob.stats.strength,
                        "intelligence": mob.stats.intelligence,
                        "wisdom": mob.stats.wisdom,
                        "dexterity": mob.stats.dexterity,
                        "constitution": mob.stats.constitution,
                        "charisma": mob.stats.charisma,
                        "perception": mob.perception,
                        "concealment": mob.concealment,
                        "lifeForce": life_force,
                        "composition": composition,
                        "stance": stance,
                        "damageType": damage_type,
                    },
                    "update": {
                        "keywords": mob.keywords.split() if mob.keywords else [],
                        "mobClass": mob_class,
                        "shortDesc": mob.short_desc or "",
                        "longDesc": mob.long_desc or "",
                        "desc": mob.desc or "",
                        "mobFlags": {"set": mob_flags},
                        "effectFlags": {"set": effect_flags},
                        "alignment": mob.alignment,
                        "level": mob.level,
                        "hpDiceNum": mob.hp_dice.num,
                        "hpDiceSize": mob.hp_dice.size,
                        "hpDiceBonus": mob.hp_dice.bonus,
                        "armorClass": mob.ac,
                        "hitRoll": mob.hit_roll,
                        "damageDiceNum": mob.damage_dice.num,
                        "damageDiceSize": mob.damage_dice.size,
                        "damageDiceBonus": mob.damage_dice.bonus,
                        "copper": mob.money.copper,
                        "silver": mob.money.silver,
                        "gold": mob.money.gold,
                        "platinum": mob.money.platinum,
                        "position": position,
                        "gender": gender,
                        "race": race,
                        "size": size,
                        "strength": mob.stats.strength,
                        "intelligence": mob.stats.intelligence,
                        "wisdom": mob.stats.wisdom,
                        "dexterity": mob.stats.dexterity,
                        "constitution": mob.stats.constitution,
                        "charisma": mob.stats.charisma,
                        "perception": mob.perception,
                        "concealment": mob.concealment,
                        "lifeForce": life_force,
                        "composition": composition,
                        "stance": stance,
                        "damageType": damage_type,
                    },
                },
            )

            return {
                "success": True,
                "zone_id": mob_zone_id,
                "vnum": vnum,
                "keywords": mob.keywords,
                "action": "imported",
            }

        except Exception as e:
            return {
                "success": False,
                "zone_id": mob_zone_id,
                "vnum": vnum,
                "keywords": mob.keywords,
                "action": "failed",
                "error": str(e),
            }

    async def import_mobs_from_file(
        self, mob_file_path: Path, zone_id: int, dry_run: bool = False,
        vnum_map: dict = None
    ) -> dict:
        """
        Import mobs from a legacy .mob file

        Args:
            mob_file_path: Path to .mob file
            zone_id: Zone ID from filename (e.g., 30 from "30.mob") - REQUIRED
            dry_run: If True, validate but don't write to database
            vnum_map: Optional dict to populate with vnum -> (zone_id, id) mappings during import

        Returns:
            Dict with import results including zones_in_file list
        """
        # Store parameter for use during import
        if vnum_map is not None:
            self.vnum_map = vnum_map

        try:
            # Read file
            with open(mob_file_path, "r") as f:
                content = f.read()

            # Parse mobs
            lines = content.split("\n")
            mud_data = MudData(lines)
            mobs = Mob.parse(mud_data)

            # Use zone_id from filename for ALL mobs (supports unlimited mobs per zone)
            zones_in_file = {zone_id}

            results = {
                "success": True,
                "file": str(mob_file_path),
                "zones_in_file": sorted(zones_in_file),
                "total": len(mobs),
                "imported": 0,
                "failed": 0,
                "mobs": [],
            }

            # Handle empty mob files (no mobs to import is not an error)
            if len(mobs) == 0:
                return results

            for mob in mobs:
                # Always use zone_id from filename (supports unlimited mobs per zone)
                result = await self.import_mob(mob, zone_id, dry_run=dry_run)
                results["mobs"].append(result)

                if result["success"]:
                    results["imported"] += 1
                else:
                    results["failed"] += 1
                    results["success"] = False

            return results

        except FileNotFoundError:
            return {
                "success": False,
                "file": str(mob_file_path),
                "zone_id": zone_id,
                "error": f"File not found: {mob_file_path}",
            }
        except Exception as e:
            return {
                "success": False,
                "file": str(mob_file_path),
                "zone_id": zone_id,
                "error": f"Parse error: {str(e)}",
            }
