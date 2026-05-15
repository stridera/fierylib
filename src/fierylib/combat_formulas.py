"""Combat stat calculation formulas ported from legacy C++ code."""

from typing import Tuple
import math


# =============================================================================
# DICE FACTOR LOOKUP TABLES
# Ported from legacy/src/races.cpp and legacy/src/class.cpp
# These multipliers adjust damage dice based on race and class.
# =============================================================================

# Race dice factors (from races.cpp)
# Format: RACE_NAME -> dice_factor percentage (100 = normal)
RACE_DICE_FACTORS = {
    "HUMAN": 100,
    "ELF": 80,
    "DWARF": 100,
    "HALFLING": 80,
    "GNOME": 75,
    "TROLL": 120,
    "DROW": 80,
    "OGRE": 120,
    "ORC": 100,
    "HALF_ELF": 90,
    "HALF_ORC": 100,
    "GOLIATH": 110,
    "DUERGAR": 100,
    "HUMANOID": 100,
    "ANIMAL": 100,
    "UNDEAD": 100,
    "DRAGON": 120,
    "GIANT": 120,
    "DEMON": 110,
    "ELEMENTAL": 100,
    "PLANT": 80,
    "FAERIE": 70,
    "CELESTIAL": 100,
    "SVERFNEBLIN": 90,
    "NYMPH": 70,
    "ABERRATION": 100,
    "DRAGONBORN": 100,
    "GOLEM": 120,
    "GOBLIN": 80,
    "INSECT": 80,
    "FISH": 60,
}

# Class dice factors (from class.cpp)
# Format: CLASS_NAME -> dice_factor percentage (100 = normal)
CLASS_DICE_FACTORS = {
    "SORCERER": 80,
    "CLERIC": 80,
    "THIEF": 100,
    "WARRIOR": 120,
    "PALADIN": 120,
    "ANTI_PALADIN": 120,
    "RANGER": 100,
    "DRUID": 80,
    "SHAMAN": 80,
    "ASSASSIN": 100,
    "MERCENARY": 120,
    "NECROMANCER": 80,
    "CONJURER": 80,
    "MONK": 100,
    "BERSERKER": 120,
    "ROGUE": 100,
    "BARD": 80,
    "PYROMANCER": 80,
    "CRYOMANCER": 80,
    "ILLUSIONIST": 80,
    "PRIEST": 80,
    "DIABOLIST": 80,
    "HUNTER": 100,
    "MYSTIC": 80,
    "LAYMAN": 100,  # Default "no class"
}


def get_race_dice_factor(race: str) -> int:
    """
    Get the dice factor for a race.

    Args:
        race: Race name (e.g., "HUMANOID", "DRAGON")

    Returns:
        Dice factor percentage (100 = normal, 120 = 20% more damage)
    """
    return RACE_DICE_FACTORS.get(race.upper(), 100)


def get_class_dice_factor(class_name: str) -> int:
    """
    Get the dice factor for a class.

    Args:
        class_name: Class name (e.g., "WARRIOR", "SORCERER")

    Returns:
        Dice factor percentage (100 = normal, 120 = 20% more damage)
    """
    return CLASS_DICE_FACTORS.get(class_name.upper(), 100)


def get_set_hit(level: int, race_factor: int = 100, class_factor: int = 100) -> int:
    """
    Calculate mob base HP bonus (EX_MAIN_HP) - port of db.cpp:220-274.

    This is the level-based HP that FieryMUD calculates at runtime, which is the
    PRIMARY source of mob HP (dice are often 0d0+bonus).

    Args:
        level: Mob level (1-100)
        race_factor: Race HP factor (50-150, default 100)
        class_factor: Class HP factor (50-150, default 100)

    Returns:
        Base HP bonus value (added to dice roll result)
    """
    xmain = 0

    # Level-based tiers (different formulas per range)
    if level < 20:
        xmain = int(3 * (float(level) * float(level / 1.25)))
    elif level < 35:
        xmain = int(3 * (float(level) * float(level / 1.35)))
    elif level < 50:
        xmain = int(3 * (float(level) * float(level) / 1.25))
    else:  # level >= 50
        xmain = int(3 * (float(level) * float(level) / 1.25))

    # Level bracket deductions
    if level <= 5:
        pass  # No deduction
    elif level <= 10:
        xmain -= 25
    elif level <= 20:
        xmain -= 100
    elif level <= 30:
        xmain -= 200
    else:  # level > 30
        xmain -= 2000

    # Apply race/class factors (averaged)
    sfactor = int((race_factor + class_factor) / 2)
    xmain = int((float(sfactor * xmain) / 100))

    # Final adjustment (level-based divisor)
    return int(xmain / (2 - (level / 100.0)))


def get_set_hd(level: int, race_factor: int = 100, class_factor: int = 100) -> int:
    """
    Calculate mob base damage bonus.

    Port of legacy db.cpp:276-337 get_set_hd() function with state=1.

    Args:
        level: Mob level (1-100)
        race_factor: Race hit_damage_factor (50-150, default 100)
        class_factor: Class hit_damage_factor (50-150, default 100)

    Returns:
        Base damroll value
    """
    # Tier-based base damroll
    if level < 10:
        dam = level / 4.0  # L1-9:  0-2 damroll
    elif level < 20:
        dam = level / 4.0  # L10-19: 2-4 damroll
    elif level < 35:
        dam = level / 4.3  # L20-34: 4-7 damroll
    elif level < 50:
        dam = level / 4.6  # L35-49: 7-10 damroll
    else:  # level >= 50
        dam = level / 4.4  # L50+: 11-22 damroll

    # Apply class/race factor modifiers
    sfactor = (class_factor + race_factor) / 2.0
    dam = dam * (sfactor / 100.0)

    return int(dam)


def get_set_dice(level: int, race_factor: int, class_factor: int) -> Tuple[int, int]:
    """
    Calculate mob damage dice (number and size).

    Port of legacy db.cpp:339-392 get_set_dice() function.

    Args:
        level: Mob level (1-100)
        race_factor: Race damage_dice_factor (50-150, default 100)
        class_factor: Class damage_dice_factor (50-150, default 100)

    Returns:
        Tuple of (num_dice, dice_size)
    """
    # DICE NUMBER (with race/class factors)
    if level < 10:
        dice = max(1, int((level / 3.0) + 0.5))
    elif level < 30:
        dice = int((level / 3.0) + 0.5)
    elif level <= 50:
        dice = int((level / 3.0) + 0.5)
    else:  # level > 50
        dice = int((level / 2.5) + 0.5)

    # Apply combined race/class factor
    sfactor = (race_factor + class_factor) / 2.0
    dice = int((sfactor * dice) / 100.0)
    dice = max(1, dice)  # Minimum 1 die

    # DICE SIZE (NO race/class factors)
    if level < 10:
        face = 3
    elif level < 26:
        face = 4
    elif level < 36:
        face = 4
    elif level <= 50:
        face = 5
    elif level <= 60:
        face = 8
    else:  # level > 60
        face = 10

    return (dice, face)


def calculate_damage_dice_modern(
    level: int, race_factor: int = 100, class_factor: int = 100, is_boss: bool = False
) -> Tuple[int, int, int]:
    """
    Calculate damage dice using modern formula from COMBAT_REVERSE_ENGINEERING.md.

    Modern approach with variable split ratio and bounded coefficient of variation.

    Args:
        level: Mob level (1-100)
        race_factor: Race damage_dice_factor (default 100)
        class_factor: Class damage_dice_factor (default 100)
        is_boss: If True, use higher CoV cap (0.80 vs 0.60)

    Returns:
        Tuple of (num_dice, dice_size, bonus)
    """
    # Get base damroll from legacy formula
    base_damroll = get_set_hd(level, race_factor, class_factor)

    # Variable split ratio (% of damroll as fixed bonus)
    split_ratio = 0.15 if level < 50 else 0.05
    fixed_bonus = int(base_damroll * split_ratio)
    dice_portion = base_damroll - fixed_bonus

    # Dice size by tier
    if level < 50:
        dice_size = 4
    elif level < 60:
        dice_size = 8
    else:
        dice_size = 10

    # Calculate number of dice from remaining portion
    avg_per_die = (dice_size + 1) / 2.0
    num_dice = max(1, int(dice_portion / avg_per_die))

    # Apply CoV cap (0.60 normal, 0.80 bosses)
    cov_cap = 0.80 if is_boss else 0.60
    max_num_dice = int((dice_size + 1) / (2 * cov_cap))
    num_dice = min(num_dice, max_num_dice)

    # Recalculate bonus to match target damage
    actual_dice_avg = num_dice * avg_per_die
    final_bonus = base_damroll - int(actual_dice_avg)

    return (num_dice, dice_size, final_bonus)


def calculate_realistic_hp_dice(
    target_hp: int, level: int, is_boss: bool = False
) -> Tuple[int, int, int]:
    """
    Convert a target HP value into realistic dice notation (XdY+Z).

    For normal mobs: Create dice that average to target_hp with reasonable variance
    For bosses: Use moderate dice with larger flat bonus for consistency

    Args:
        target_hp: The desired average HP
        level: Mob level (affects dice size selection)
        is_boss: If True, use boss-appropriate dice distribution

    Returns:
        Tuple of (num_dice, dice_size, bonus)
    """
    if target_hp <= 0:
        return (0, 0, 0)

    # Choose dice size based on level (matches legacy patterns)
    if level < 10:
        dice_size = 8
    elif level < 30:
        dice_size = 10
    elif level < 50:
        dice_size = 12
    else:  # level >= 50
        dice_size = 20

    if is_boss:
        # BOSS: Use smaller dice count with larger flat bonus for consistency
        # Example: 20,000 HP → 10d20+19,895 (avg 19,895-20,000, low variance)
        # This gives bosses predictable HP with slight variance

        # Use 10-20% of HP as dice variance
        dice_portion = int(target_hp * 0.15)  # 15% from dice
        flat_bonus = target_hp - dice_portion

        # Calculate num_dice to get dice_portion average
        avg_per_die = (dice_size + 1) / 2.0
        num_dice = max(1, int(dice_portion / avg_per_die))

        # Recalculate actual average and adjust bonus
        actual_dice_avg = int(num_dice * avg_per_die)
        final_bonus = target_hp - actual_dice_avg

        return (num_dice, dice_size, final_bonus)
    else:
        # NORMAL MOB: Use realistic dice with moderate variance
        # Example: 1,200 HP → 40d12+500 (avg 1,160-1,200, good variance)
        # This gives normal mobs HP variation per spawn

        # Use 40-60% of HP as dice variance (more variance than bosses)
        dice_portion = int(target_hp * 0.50)  # 50% from dice
        flat_bonus = target_hp - dice_portion

        # Calculate num_dice
        avg_per_die = (dice_size + 1) / 2.0
        num_dice = max(1, int(dice_portion / avg_per_die))

        # Cap num_dice to reasonable values (don't want 500d20)
        max_dice = min(50, level * 2)  # Max 50 dice or 2x level
        num_dice = min(num_dice, max_dice)

        # Recalculate actual average and adjust bonus
        actual_dice_avg = int(num_dice * avg_per_die)
        final_bonus = target_hp - actual_dice_avg

        return (num_dice, dice_size, final_bonus)


def normalize_boss_hp_dice(
    file_hp_num: int, file_hp_size: int, file_hp_bonus: int, calculated_hp: int, level: int
) -> Tuple[int, int, int]:
    """
    Normalize boss mob HP dice to use realistic values.

    Legacy bosses often have 0d0+20000 which is misleading. Convert to
    realistic dice notation while preserving the total HP.

    Args:
        file_hp_num: Original HP dice number from file
        file_hp_size: Original HP dice size from file
        file_hp_bonus: Original HP bonus from file
        calculated_hp: Runtime-calculated HP (with formulas)
        level: Mob level

    Returns:
        Tuple of (num_dice, dice_size, bonus) normalized for bosses
    """
    # If file already has reasonable dice (num > 0 and size > 0), keep it
    if file_hp_num > 0 and file_hp_size > 0:
        # File has explicit dice, preserve it
        return (file_hp_num, file_hp_size, file_hp_bonus)

    # Otherwise, file has 0d0+X, convert to realistic boss dice
    return calculate_realistic_hp_dice(calculated_hp, level, is_boss=True)


def calculate_mob_role(
    level: int,
    estimated_hp: int,
    zone_avg_level: float,
    zone_stddev_level: float,
    zone_avg_hp: float,
    zone_stddev_hp: float,
) -> str:
    """
    Classify mob role using multi-factor analysis (HP primary, level secondary).

    In legacy MUD data, HP is the most reliable indicator of mob difficulty.
    Level can be misleading (e.g., zone 489 all level 99, but Lokari has 20k HP vs 5k for others).

    Args:
        level: Mob level
        estimated_hp: Mob's estimated HP (calculated from dice)
        zone_avg_level: Average level in zone
        zone_stddev_level: Standard deviation of levels
        zone_avg_hp: Average HP in zone
        zone_stddev_hp: Standard deviation of HP

    Returns:
        Role string: "TRASH", "NORMAL", "ELITE", "MINIBOSS", "BOSS"
    """
    # Use HP as primary classification factor (more reliable than level)
    hp_deviation = 0.0
    if zone_stddev_hp and zone_stddev_hp > 0 and estimated_hp > 0:
        hp_deviation = (estimated_hp - zone_avg_hp) / zone_stddev_hp

    # Use level as secondary factor
    level_deviation = 0.0
    if zone_stddev_level and zone_stddev_level > 0:
        level_deviation = (level - zone_avg_level) / zone_stddev_level

    # Combined score: HP weighted 70%, level weighted 30%
    # (HP is more indicative of actual difficulty in legacy data)
    # Special case: If zone has very low level variance (stddev < 2), use HP only
    if zone_stddev_level < 2.0:
        combined_deviation = hp_deviation  # Use HP deviation 100%
    else:
        combined_deviation = (hp_deviation * 0.7) + (level_deviation * 0.3)

    # Classification thresholds
    if combined_deviation >= 2.0:
        return "BOSS"  # Significantly stronger (e.g., Lokari with 4x HP)
    elif combined_deviation >= 1.5:
        return "MINIBOSS"
    elif combined_deviation >= 1.0:
        return "ELITE"
    elif combined_deviation >= -1.0:
        return "NORMAL"
    else:
        return "TRASH"  # Significantly weaker than zone average


# Per-class accuracy-per-level rate, derived from legacy class.cpp THAC0
# (legacy hit chance falls from THAC0 25 at L1 to ``classes[c].thac0`` at
# L100 via ``calc_thac0(level, 25, class_thac0) = 25 + level*(class_thac0 - 25)/100``).
# Each THAC0 point ≈ 5% hit chance ≈ 10 modern accuracy points (since
# modern accuracy 2 ≈ 1% hit chance), so per-level accuracy rate is
# ``(25 - class_thac0) / 10``. Stored here keyed by the same uppercase
# class name the importer normalizes to.
#
# Mobs continue to use the class-agnostic ``rate=2.0`` default; that
# matches their authored ``hit_roll`` baseline. Players using these
# class-specific rates close the structural mob hit-rate edge that
# gear-curves §6a documented.
# Per-class attack_power-per-level rate, added in Step 4 / Path C
# (gear-curves §7 rec #5) after the re-survey showed player damage was
# the load-bearing bottleneck for L20+ solo combat. Mirrors the legacy
# ``classes[c].hd_factor`` archetype split (warrior 120, mid 100, mage 80
# in legacy mob-side scale).
#
# Derivation: warrior +5/lvl gives +100 attack_power at L20 → +100%
# damage on the weapon dice. That doubles per-swing damage from typical
# T2 weapons (~5 dmg) to ~10, which the math model in gear-curves §7.5
# shows is enough to flip L20+ from LOSS to WIN. Mid classes get +3/lvl
# (60% damage at L20), casters get +1/lvl (20% — they make up the gap
# with spell_power, not weapon swings).
CLASS_ATTACK_POWER_PER_LEVEL: dict[str, float] = {
    # Warrior tier — full weapon swings
    "WARRIOR": 5.0,
    "PALADIN": 5.0,
    "ANTI_PALADIN": 5.0,
    "RANGER": 5.0,
    "MONK": 5.0,
    "BERSERKER": 5.0,
    "HUNTER": 5.0,
    # Hybrid / mid — moderate swings + utility
    "THIEF": 3.0,
    "ASSASSIN": 3.0,
    "MERCENARY": 3.0,
    "ROGUE": 3.0,
    "BARD": 3.0,
    "CLERIC": 3.0,
    "DRUID": 3.0,
    "SHAMAN": 3.0,
    "PRIEST": 3.0,
    "DIABOLIST": 3.0,
    # Caster tier — spells carry the damage; weapons are flavor
    "SORCERER": 1.0,
    "NECROMANCER": 1.0,
    "CONJURER": 1.0,
    "MYSTIC": 1.0,
    "PYROMANCER": 1.0,
    "CRYOMANCER": 1.0,
    "ILLUSIONIST": 1.0,
}


CLASS_ACCURACY_PER_LEVEL: dict[str, float] = {
    "SORCERER": 1.9,
    "CLERIC": 2.1,
    "THIEF": 2.4,
    "WARRIOR": 2.7,
    "PALADIN": 2.7,
    "ANTI_PALADIN": 2.7,
    "RANGER": 2.7,
    "DRUID": 2.0,
    "SHAMAN": 1.9,
    "ASSASSIN": 2.3,
    "MERCENARY": 2.3,
    "NECROMANCER": 1.8,
    "CONJURER": 1.8,
    "MONK": 2.7,
    "BERSERKER": 2.7,
    "PRIEST": 2.0,
    "DIABOLIST": 2.0,
    "MYSTIC": 1.8,
    "ROGUE": 2.3,
    "BARD": 2.3,
    "PYROMANCER": 1.8,
    "CRYOMANCER": 1.8,
    "ILLUSIONIST": 1.8,
    "HUNTER": 2.7,
}


def derive_hit_roll_baseline(
    level: int,
    dex_score: int = 13,
    hit_roll: int = 0,
    class_name: str | None = None,
) -> dict:
    """Canonical accuracy/evasion at the modern combat-rebalance.md
    baseline. Used by both the mob importer (with legacy_hitroll from
    the .mob file) and the player seeder (hit_roll=0 since fresh
    characters have no authored bonus). Lifting this into one place
    keeps player + mob curves provably symmetric for default-stat
    actors at the same level — `derive_hit_roll_baseline(N) ==
    derive_hit_roll_baseline(N)` always holds when ``class_name`` is
    None on both sides.

    When ``class_name`` is provided, the per-level accuracy bump is
    scaled by ``CLASS_ACCURACY_PER_LEVEL[class_name]`` (default 2.0).
    This restores the legacy class progression where warriors hit
    structurally better than mages — closes the §6a gap where mob
    authored hit_roll structurally outpaced players.

    Reference: fierymud-rs `docs/design/combat-rebalance.md` Step 3
    §8 lock 2026-05-14 and `docs/design/gear-curves.md` §6a.
    """
    dex_bonus = (dex_score - 10) // 2
    if class_name is not None:
        normalized = class_name.upper().replace("-", "_")
        rate = CLASS_ACCURACY_PER_LEVEL.get(normalized, 2.0)
    else:
        rate = 2.0
    return {
        "accuracy": int(50 + hit_roll * 2 + round(rate * level)),
        "evasion": 50 + dex_bonus * 5 + level * 2,
    }


def derive_attack_power_baseline(level: int, class_name: str | None = None) -> int:
    """Per-class+level attack_power baseline (Step 4 / Path C). Returns
    a flat int that combines additively with gear ``ObjectEffects``
    bonuses. ``None`` class falls back to the mob-symmetric ``2.0/lvl``
    rate so player and mob curves stay symmetric for default actors.

    Reference: fierymud-rs ``docs/design/gear-curves.md`` §7.5 Path C.
    """
    if class_name is None:
        rate = 2.0
    else:
        normalized = class_name.upper().replace("-", "_")
        rate = CLASS_ATTACK_POWER_PER_LEVEL.get(normalized, 2.0)
    return int(round(rate * level))


def normalize_mob_hit_roll(legacy_hit_roll: int, level: int) -> int:
    """Surgical normalization of the bimodal legacy mob hit_roll
    distribution. ~48% of legacy mobs were authored with the
    "max default" of 20 — see gear-curves.md §7.6 audit. That value
    is too high under the modern accuracy/evasion model: it pushes
    same-level mob hit rate to 67% vs warrior, even higher vs caster.

    Surgical fix: ONLY replace hit_roll==20 with a tier-appropriate
    value. Leave all other authored values (0, 1-7, 10, 15-19)
    intact — those represent intentional content authoring.

    Tier replacement (from gear-curves §7.6 normalization decision):
        L1-30:  20 → 3   (trash baseline)
        L31-70: 20 → 6   (escalating)
        L71+:   20 → 10  (elite tier)
    """
    if legacy_hit_roll != 20:
        return legacy_hit_roll
    if level <= 30:
        return 3
    if level <= 70:
        return 6
    return 10


def convert_legacy_to_modern_stats(mob_data: dict, race_data: dict) -> dict:
    """
    Convert legacy combat stats to modern accuracy/evasion/armorRating/damageReductionPercent system.

    Args:
        mob_data: Legacy mob dict with hitRoll, armorClass, level
        race_data: Race data with bonus_hitroll, bonus_damroll, factors

    Returns:
        Dict with new combat stat fields
    """
    level = mob_data.get("level", 1)
    raw_hitroll = mob_data.get("hitRoll", 0)
    legacy_hitroll = normalize_mob_hit_roll(raw_hitroll, level)
    legacy_ac = mob_data.get("armorClass", 0)
    dexterity = mob_data.get("dexterity", 13)

    # Legacy AC is *not* part of evasion — it contributes only to
    # armor mitigation below (armor_rating / damageReductionPercent).
    # The pre-fix formula `(100 - level*2 - legacy_ac) // 2` inverted
    # difficulty: low-level mobs ended up with high evasion (49 for
    # L1) and high-level bosses with negative evasion (-40 for L90).
    # Re-import is required after this change.
    baseline = derive_hit_roll_baseline(level, dex_score=dexterity, hit_roll=legacy_hitroll)
    accuracy = baseline["accuracy"]
    evasion = baseline["evasion"]

    # armorRating from AC using reverse K formula
    # damageReductionPercent = armorRating / (armorRating + K), solve for armorRating given target damageReductionPercent
    # For now, simple conversion: armorRating = abs(AC) for AC < 0
    armor_rating = max(0, -legacy_ac)

    # Calculate damageReductionPercent from armorRating using K constants
    if level <= 30:
        k_constant = 50
    elif level <= 60:
        k_constant = 100
    else:
        k_constant = 200

    damage_reduction_percent = (
        int((armor_rating * 100) / (armor_rating + k_constant)) if armor_rating > 0 else 0
    )

    return {
        "accuracy": accuracy,
        "evasion": evasion,
        "armorRating": armor_rating,
        "damageReductionPercent": damage_reduction_percent,
        "attackPower": 0,  # Initialize to 0, content authors set
        "spellPower": 0,
        "penetrationFlat": 0,
        "penetrationPercent": 0,
        "soak": 0,
        "hardness": 0,
        "wardPercent": 0,
        # Resistances stored as JSON object with ElementType keys
        # Values: -100 (2x damage) to 100 (immune), only non-zero values stored
        "resistances": {},
    }


def calculate_placeholder_stats(
    level: int,
    role: str,
    mob_class: str,
    race: str,
    lifeforce: str,
    composition: str,
    mob_flags: list = None,
    effect_flags: list = None,
) -> dict:
    """
    Calculate intelligent initial values for placeholder combat stats.

    These are heuristic-based estimates that provide better starting values
    than 0, but still require content author review and tuning.

    All formulas are documented in fierymud/docs/MOB_DATA_MAPPING.md under
    "Modern Combat System Migration - Placeholder Stats Implementation".

    Args:
        level: Mob level (1-100)
        role: Mob role (TRASH, NORMAL, ELITE, MINIBOSS, BOSS)
        mob_class: Class name (WARRIOR, SORCERER, CLERIC, etc.)
        race: Race name (HUMAN, DRAGON, UNDEAD, etc.)
        lifeforce: Lifeforce type (LIVING, UNDEAD, CONSTRUCT)
        composition: Material type (FLESH, STONE, METAL, etc.)
        mob_flags: List of mob behavior flags (optional)
        effect_flags: List of active effect flags (optional)

    Returns:
        Dict with placeholder stat initial values:
        - attackPower, spellPower, soak, hardness, wardPercent
        - penetrationFlat, penetrationPercent
        - resistances: JSON object with ElementType keys (FIRE, COLD, SHOCK, ACID, POISON)
    """
    mob_flags = mob_flags or []
    effect_flags = effect_flags or []

    # Role multiplier (used across multiple stats)
    role_mult = {
        "TRASH": 0.5,
        "NORMAL": 1.0,
        "ELITE": 1.5,
        "MINIBOSS": 2.5,
        "BOSS": 4.0,
        "RAID_BOSS": 5.0,
    }.get(role, 1.0)

    # ========== ATTACK POWER ==========
    # Physical damage multiplier
    base_attack = max(0, (level - 50) // 2)  # L50=0, L100=25

    class_attack_bonus = {
        "WARRIOR": 20,
        "RANGER": 15,
        "THIEF": 10,
        "DRUID": 8,
        "CLERIC": 5,
        "SORCERER": 0,
        "LAYMAN": 5,
    }.get(mob_class, 5)

    attack_power = int(base_attack * role_mult + class_attack_bonus)

    # ========== SPELL POWER ==========
    # Magic damage multiplier (only for casters)
    caster_base = {
        "SORCERER": 40,
        "DRUID": 35,
        "CLERIC": 30,
        "SHAMAN": 30,
        "RANGER": 5,
        "WARRIOR": 0,
        "THIEF": 0,
        "LAYMAN": 0,
    }.get(mob_class, 0)

    # Check for magical effect flags
    magic_effects = ["FIRE_SHIELD", "ICE_ARMOR", "PROTECT", "BLESS", "INVISIBLE", "FLY"]
    has_magic = any(effect in " ".join(effect_flags).upper() for effect in magic_effects)
    magic_bonus = 15 if has_magic else 0

    spell_power = int((caster_base + magic_bonus) * role_mult)

    # ========== SOAK ==========
    # Flat damage reduction
    role_soak = {
        "TRASH": 0,
        "NORMAL": max(0, (level - 50) // 10),  # L60=1, L100=5
        "ELITE": max(0, (level - 40) // 5),    # L50=2, L100=12
        "MINIBOSS": max(0, (level - 30) // 3), # L50=6, L100=23
        "BOSS": max(0, (level - 20) // 2),     # L50=15, L100=40
        "RAID_BOSS": max(0, (level - 10)),     # L50=40, L100=90
    }.get(role, 0)

    comp_mult = {
        "FLESH": 1.0,
        "BONE": 0.8,
        "STONE": 1.5,
        "METAL": 2.0,
        "CRYSTAL": 1.2,
        "GAS": 0.0,
        "LIQUID": 0.5,
    }.get(composition, 1.0)

    soak = int(role_soak * comp_mult)

    # ========== HARDNESS ==========
    # Critical hit reduction
    if role in ["BOSS", "RAID_BOSS", "MINIBOSS"]:
        base_hardness = 50 + (level // 2)  # L50=75, L100=100
    elif role == "ELITE":
        base_hardness = 25 + (level // 4)  # L50=37, L100=50
    else:
        base_hardness = 0

    comp_hardness_bonus = {
        "FLESH": 0,
        "BONE": 5,
        "STONE": 15,
        "METAL": 25,
        "CRYSTAL": 10,
        "GAS": -10,
        "LIQUID": -5,
    }.get(composition, 0)

    hardness = max(0, base_hardness + comp_hardness_bonus)

    # ========== WARD PERCENT ==========
    # Magic damage reduction
    class_ward = {
        "SORCERER": 30,
        "CLERIC": 25,
        "DRUID": 20,
        "SHAMAN": 25,
        "RANGER": 10,
        "WARRIOR": 5,
        "THIEF": 5,
        "LAYMAN": 0,
    }.get(mob_class, 5)

    # Magical races get bonus ward
    magical_races = ["DRAGON", "DEMON", "DEVIL", "ELEMENTAL", "FAE", "CELESTIAL"]
    race_ward_bonus = 20 if any(mag_race in race.upper() for mag_race in magical_races) else 0

    # Lifeforce modifier
    lifeforce_mult = {
        "LIVING": 1.0,
        "UNDEAD": 1.2,  # Undead resist magic slightly
        "CONSTRUCT": 0.8,  # Constructs vulnerable to magic
    }.get(lifeforce, 1.0)

    ward_percent = min(90, int((class_ward + race_ward_bonus) * lifeforce_mult * role_mult))

    # ========== PENETRATION ==========
    # Armor bypass
    pen_base = {
        "THIEF": 25,   # Backstabs pierce
        "RANGER": 20,  # Archers pierce armor
        "WARRIOR": 15,
        "DRUID": 5,
        "SORCERER": 0,
        "CLERIC": 0,
        "LAYMAN": 0,
    }.get(mob_class, 0)

    penetration_flat = int(pen_base * role_mult)

    # Percent penetration for high-level elites+
    if role in ["BOSS", "RAID_BOSS", "MINIBOSS", "ELITE"] and level >= 70:
        penetration_percent = 10 + ((level - 70) // 5)  # L70=10%, L100=16%
    else:
        penetration_percent = 0

    # ========== ELEMENTAL RESISTANCES ==========
    # Initialize all resistances to 0
    resistances = {
        "fire": 0,
        "cold": 0,
        "lightning": 0,
        "acid": 0,
        "poison": 0,
    }

    # Race-based elemental affinities
    race_upper = race.upper()

    # Dragons (check for dragon type in race name)
    if "FIRE" in race_upper and "DRAGON" in race_upper:
        resistances["fire"] = 75
        resistances["cold"] = -25  # Vulnerable to opposite
    elif "ICE" in race_upper and "DRAGON" in race_upper:
        resistances["cold"] = 75
        resistances["fire"] = -25
    elif "LIGHTNING" in race_upper and "DRAGON" in race_upper:
        resistances["lightning"] = 75
    elif "ACID" in race_upper and "DRAGON" in race_upper:
        resistances["acid"] = 75
    elif "POISON" in race_upper and "DRAGON" in race_upper:
        resistances["poison"] = 75
    elif "DRAGON" in race_upper:
        # Generic dragon - moderate all resistances
        for element in resistances:
            resistances[element] = 25

    # Demons and Devils
    if "DEMON" in race_upper or "DEVIL" in race_upper:
        resistances["fire"] = 50
        resistances["cold"] = 25

    # Elementals
    if "FIRE" in race_upper and "ELEMENTAL" in race_upper:
        resistances["fire"] = 90
        resistances["cold"] = -50
    elif "ICE" in race_upper and "ELEMENTAL" in race_upper:
        resistances["cold"] = 90
        resistances["fire"] = -50
    elif "LIGHTNING" in race_upper and "ELEMENTAL" in race_upper:
        resistances["lightning"] = 90
    elif "EARTH" in race_upper and "ELEMENTAL" in race_upper:
        resistances["acid"] = 75
        resistances["poison"] = 50

    # Lifeforce-based universal resistances
    if lifeforce == "UNDEAD":
        resistances["poison"] = max(resistances["poison"], 90)  # Undead immune to poison
        resistances["cold"] = max(resistances["cold"], 50)     # Resist cold
    elif lifeforce == "CONSTRUCT":
        resistances["poison"] = max(resistances["poison"], 100)  # Constructs fully immune

    # Composition-based resistances
    if composition == "STONE":
        resistances["acid"] = max(resistances["acid"], 40)
        resistances["fire"] = max(resistances["fire"], 30)
    elif composition == "METAL":
        resistances["lightning"] = min(resistances["lightning"], -25)  # Conducts electricity
        resistances["acid"] = max(resistances["acid"], 50)
    elif composition == "CRYSTAL":
        resistances["lightning"] = max(resistances["lightning"], 40)

    # Apply role multiplier to positive resistances only (not vulnerabilities)
    for element in resistances:
        if resistances[element] > 0:
            resistances[element] = min(90, int(resistances[element] * (0.5 + role_mult * 0.3)))

    # Cap all resistances at -50 (vulnerable) to 90 (highly resistant)
    for element in resistances:
        resistances[element] = max(-50, min(90, resistances[element]))

    # Convert to JSON object with ElementType keys (only non-zero values)
    # Note: "lightning" in internal dict maps to "SHOCK" in schema
    resistances_json = {}
    if resistances["fire"] != 0:
        resistances_json["FIRE"] = resistances["fire"]
    if resistances["cold"] != 0:
        resistances_json["COLD"] = resistances["cold"]
    if resistances["lightning"] != 0:
        resistances_json["SHOCK"] = resistances["lightning"]  # SHOCK not LIGHTNING
    if resistances["acid"] != 0:
        resistances_json["ACID"] = resistances["acid"]
    if resistances["poison"] != 0:
        resistances_json["POISON"] = resistances["poison"]

    return {
        "attackPower": attack_power,
        "spellPower": spell_power,
        "soak": soak,
        "hardness": hardness,
        "wardPercent": ward_percent,
        "penetrationFlat": penetration_flat,
        "penetrationPercent": penetration_percent,
        "resistances": resistances_json,
    }
