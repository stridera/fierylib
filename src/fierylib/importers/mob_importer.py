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
from fierylib.combat_formulas import (
    calculate_damage_dice_modern,
    calculate_mob_role,
    calculate_realistic_hp_dice,
    get_set_hit,
    normalize_boss_hp_dice,
    convert_legacy_to_modern_stats,
    calculate_placeholder_stats,
)


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
        self.zone_stats_cache = {}  # zone_id -> {avg_level, stddev_level, avg_hp, stddev_hp}

    async def get_zone_statistics(self, zone_id: int) -> dict:
        """
        Calculate zone statistics for role classification.

        Args:
            zone_id: Zone ID to calculate stats for

        Returns:
            Dict with avg_level, stddev_level, avg_hp, stddev_hp
        """
        # Check cache first
        if zone_id in self.zone_stats_cache:
            return self.zone_stats_cache[zone_id]

        # Query ALL mobs from this zone (don't exclude any levels - we need accurate stats)
        mobs = await self.prisma.mobs.find_many(where={"zoneId": zone_id})

        if not mobs or len(mobs) == 0:
            # No mobs, use defaults
            stats = {
                "avg_level": 1.0,
                "stddev_level": 0.0,
                "avg_hp": 0.0,
                "stddev_hp": 0.0,
            }
        else:
            # Calculate level statistics
            levels = [mob.level for mob in mobs]
            avg_level = sum(levels) / len(levels)

            if len(levels) > 1:
                variance_level = sum((x - avg_level) ** 2 for x in levels) / len(levels)
                stddev_level = variance_level**0.5
            else:
                stddev_level = 0.0

            # Calculate HP statistics (estimated HP from dice: num * (size+1)/2 + bonus)
            hp_values = []
            for mob in mobs:
                # Calculate estimated HP from dice
                hp_num = mob.hpDiceNum or 0
                hp_size = mob.hpDiceSize or 0
                hp_bonus = mob.hpDiceBonus or 0
                estimated_hp = int(hp_num * (hp_size + 1) / 2.0 + hp_bonus)
                hp_values.append(estimated_hp)

            avg_hp = sum(hp_values) / len(hp_values) if hp_values else 0.0

            if len(hp_values) > 1 and avg_hp > 0:
                variance_hp = sum((x - avg_hp) ** 2 for x in hp_values) / len(hp_values)
                stddev_hp = variance_hp**0.5
            else:
                stddev_hp = 0.0

            stats = {
                "avg_level": avg_level,
                "stddev_level": stddev_level,
                "avg_hp": avg_hp,
                "stddev_hp": stddev_hp,
            }

        # Cache for reuse
        self.zone_stats_cache[zone_id] = stats
        return stats

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

        # Map Class enum value to database class_id (database IDs are 1-indexed, enum is 0-indexed)
        class_id = mob.mob_class.value + 1 if hasattr(mob.mob_class, "value") else None

        # Convert BitFlags to lists and normalize (NO_CHARM → NOCHARM)
        mob_flags = mob.mob_flags.json_repr() if isinstance(mob.mob_flags, BitFlags) else (mob.mob_flags or [])
        mob_flags = normalize_flags(mob_flags)
        effect_flags = mob.effect_flags.json_repr() if isinstance(mob.effect_flags, BitFlags) else (mob.effect_flags or [])
        effect_flags = normalize_flags(effect_flags)

        # Calculate new combat stats (only if not dry run, to avoid DB queries)
        if not dry_run:
            # Get zone statistics for role classification
            zone_stats = await self.get_zone_statistics(mob_zone_id)

            # Get legacy HP dice from file
            file_hp_num = mob.hp_dice.num if mob.hp_dice else 0
            file_hp_size = mob.hp_dice.size if mob.hp_dice else 0
            file_hp_bonus = mob.hp_dice.bonus if mob.hp_dice else 0

            # Calculate base HP from level using FieryMUD's formula
            # This is what the game adds to the file HP at runtime
            base_hp_from_level = get_set_hit(level=mob.level, race_factor=100, class_factor=100)

            # Calculate target HP: file_dice + level_bonus + file_bonus
            # This matches what the game will calculate (before race/class multipliers)
            file_dice_avg = int(file_hp_num * (file_hp_size + 1) / 2.0) if file_hp_num > 0 and file_hp_size > 0 else 0
            target_hp = file_dice_avg + base_hp_from_level + file_hp_bonus

            # For role classification, use target HP
            estimated_hp = target_hp

            # Calculate mob role using multi-factor analysis
            mob_role = calculate_mob_role(
                level=mob.level,
                estimated_hp=estimated_hp,
                zone_avg_level=zone_stats["avg_level"],
                zone_stddev_level=zone_stats["stddev_level"],
                zone_avg_hp=zone_stats["avg_hp"],
                zone_stddev_hp=zone_stats["stddev_hp"],
            )

            # Determine if boss (for HP dice normalization)
            is_boss = mob_role in ["BOSS", "RAID_BOSS"]

            # Calculate realistic HP dice to store in database
            # We want dice that average to target_hp (which includes level bonus)
            # This way race/class multipliers will be applied correctly at runtime
            if file_hp_num == 0 and file_hp_size == 0:
                # File has 0d0+X - convert to realistic dice
                # Convert TOTAL target HP (including level bonus) to dice
                new_hp_num, new_hp_size, new_hp_bonus = calculate_realistic_hp_dice(
                    target_hp=target_hp,
                    level=mob.level,
                    is_boss=is_boss
                )
            else:
                # File has explicit dice - keep it but ADD the level bonus
                # This preserves intentional dice variance while adding level scaling
                new_hp_num = file_hp_num
                new_hp_size = file_hp_size
                new_hp_bonus = file_hp_bonus + base_hp_from_level

            # Update estimated HP with new dice for consistency
            estimated_hp = int(new_hp_num * (new_hp_size + 1) / 2.0 + new_hp_bonus)

            # Calculate new damage dice (for ALL mobs)
            new_damage_dice_num, new_damage_dice_size, new_damage_dice_bonus = calculate_damage_dice_modern(
                level=mob.level,
                race_factor=100,  # TODO: Get from race table once implemented
                class_factor=100,  # No class for mobs, use 100
                is_boss=is_boss
            )

            # OUTLIER DETECTION for non-0d0 mobs
            if mob.damage_dice.num > 0 or mob.damage_dice.size > 0:
                old_avg = (mob.damage_dice.num * (mob.damage_dice.size + 1) / 2.0) + mob.damage_dice.bonus
                new_avg = (new_damage_dice_num * (new_damage_dice_size + 1) / 2.0) + new_damage_dice_bonus

                if old_avg > 0:
                    diff_pct = abs(new_avg - old_avg) / old_avg * 100
                    if diff_pct > 30:
                        print(f"OUTLIER: Zone {mob_zone_id} Mob {vnum} ({mob.short_desc})")
                        print(f"  Old: {mob.damage_dice.num}d{mob.damage_dice.size}+{mob.damage_dice.bonus} (avg {old_avg:.1f})")
                        print(f"  New: {new_damage_dice_num}d{new_damage_dice_size}+{new_damage_dice_bonus} (avg {new_avg:.1f})")
                        print(f"  Difference: {diff_pct:.1f}%")

            # Convert legacy stats to modern
            modern_stats = convert_legacy_to_modern_stats(
                mob_data={"level": mob.level, "hitRoll": mob.hit_roll, "armorClass": mob.ac},
                race_data={}  # TODO: Get from race table once implemented
            )

            # Calculate placeholder stats (attackPower, spellPower, resistances, etc.)
            placeholder_stats = calculate_placeholder_stats(
                level=mob.level,
                role=mob_role,
                mob_class=mob.mob_class.name if hasattr(mob.mob_class, "name") else str(mob.mob_class).upper(),
                race=race,
                lifeforce=life_force,
                composition=composition,
                mob_flags=mob_flags,
                effect_flags=effect_flags,
            )

            # Merge placeholder stats into modern_stats
            modern_stats.update(placeholder_stats)
        else:
            # Dry run - use defaults
            mob_role = "NORMAL"
            new_hp_num = mob.hp_dice.num if mob.hp_dice else 0
            new_hp_size = mob.hp_dice.size if mob.hp_dice else 0
            new_hp_bonus = mob.hp_dice.bonus if mob.hp_dice else 0
            estimated_hp = 0
            new_damage_dice_num = mob.damage_dice.num
            new_damage_dice_size = mob.damage_dice.size
            new_damage_dice_bonus = mob.damage_dice.bonus
            modern_stats = {}

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
            await self.prisma.mobs.upsert(
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
                        "classId": class_id,
                        "name": mob.short_desc or "",
                        "roomDescription": mob.long_desc or "",
                        "examineDescription": mob.desc or "",
                        "mobFlags": mob_flags,
                        "effectFlags": effect_flags,
                        "alignment": mob.alignment,
                        "level": mob.level,
                        "role": mob_role,
                        "hpDiceNum": new_hp_num,
                        "hpDiceSize": new_hp_size,
                        "hpDiceBonus": new_hp_bonus,
                        "estimatedHp": estimated_hp,
                        "armorClass": mob.ac,
                        "hitRoll": mob.hit_roll,
                        "damageDiceNum": new_damage_dice_num,
                        "damageDiceSize": new_damage_dice_size,
                        "damageDiceBonus": new_damage_dice_bonus,
                        **modern_stats,
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
                        "classId": class_id,
                        "name": mob.short_desc or "",
                        "roomDescription": mob.long_desc or "",
                        "examineDescription": mob.desc or "",
                        "mobFlags": {"set": mob_flags},
                        "effectFlags": {"set": effect_flags},
                        "alignment": mob.alignment,
                        "level": mob.level,
                        "role": mob_role,
                        "hpDiceNum": new_hp_num,
                        "hpDiceSize": new_hp_size,
                        "hpDiceBonus": new_hp_bonus,
                        "estimatedHp": estimated_hp,
                        "armorClass": mob.ac,
                        "hitRoll": mob.hit_roll,
                        "damageDiceNum": new_damage_dice_num,
                        "damageDiceSize": new_damage_dice_size,
                        "damageDiceBonus": new_damage_dice_bonus,
                        **modern_stats,
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

            # CRITICAL: Recalculate all mob roles after import completes
            # (zone statistics need complete data for accurate classification)
            if not dry_run and len(mobs) > 0:
                await self.recalculate_mob_roles_for_zone(zone_id)

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

    async def recalculate_mob_roles_for_zone(self, zone_id: int) -> None:
        """
        Recalculate mob roles for an entire zone after import completes.

        This is necessary because role classification depends on zone statistics,
        which are incomplete during the initial import (mobs imported one-by-one).

        Post-processing: The highest HP mob in each zone is marked as BOSS (zone boss).

        Args:
            zone_id: Zone ID to recalculate roles for
        """
        # Clear cached zone statistics to force recalculation
        if zone_id in self.zone_stats_cache:
            del self.zone_stats_cache[zone_id]

        # Get complete zone statistics now that all mobs are imported
        zone_stats = await self.get_zone_statistics(zone_id)

        # Query all mobs in zone
        mobs = await self.prisma.mobs.find_many(where={"zoneId": zone_id})

        # Track highest HP mob for boss promotion
        highest_hp_mob = None
        highest_hp = 0

        # Recalculate and update each mob's role
        for mob in mobs:
            # Calculate estimated HP
            estimated_hp = int(mob.hpDiceNum * (mob.hpDiceSize + 1) / 2.0 + mob.hpDiceBonus)

            # Calculate role with complete zone statistics
            mob_role = calculate_mob_role(
                level=mob.level,
                estimated_hp=estimated_hp,
                zone_avg_level=zone_stats["avg_level"],
                zone_stddev_level=zone_stats["stddev_level"],
                zone_avg_hp=zone_stats["avg_hp"],
                zone_stddev_hp=zone_stats["stddev_hp"],
            )

            # Track highest HP mob
            if estimated_hp > highest_hp:
                highest_hp = estimated_hp
                highest_hp_mob = mob

            # Update mob role if it changed
            if mob.role != mob_role:
                await self.prisma.mobs.update(
                    where={"zoneId_id": {"zoneId": zone_id, "id": mob.id}},
                    data={"role": mob_role}
                )

        # POST-PROCESSING: Promote highest HP mob to BOSS
        # This ensures each zone has a clear boss mob (typically the zone's end boss)
        if highest_hp_mob and highest_hp_mob.role != "BOSS":
            # Only promote if mob is already MINIBOSS or ELITE (not random high-HP trash)
            if highest_hp_mob.role in ["MINIBOSS", "ELITE"]:
                await self.prisma.mobs.update(
                    where={"zoneId_id": {"zoneId": zone_id, "id": highest_hp_mob.id}},
                    data={"role": "BOSS"}
                )
                print(f"  🎯 Promoted zone boss: {highest_hp_mob.name} ({highest_hp} HP) → BOSS")
