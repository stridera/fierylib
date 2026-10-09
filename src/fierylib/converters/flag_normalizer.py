"""
Flag Normalizer - Convert legacy flag names to modern schema format

The Python flags.py contains legacy flag names from CircleMUD.
This normalizer converts those flags to the modern schema structure:
- MobFlag enum removed → traits, behaviors, professions, resistances
- EffectFlag enum removed → MobDefaultEffects/ObjectEffects junction tables
- ObjectFlag ANTI_* removed → restrictedAlignments, restrictedClassIds, restrictedRaces, minSize/maxSize
"""

from dataclasses import dataclass


# =============================================================================
# MOB FLAG REORGANIZATION
# =============================================================================

# Mob flags that map to MobTrait enum (what the mob IS)
MOB_FLAG_TO_TRAIT = {
    'ILLUSION': 'ILLUSION',
    'ILLUSORY': 'ILLUSION',
    'ANIMATED': 'ANIMATED',
    'PLAYER_PHANTASM': 'PLAYER_PHANTASM',
    'AQUATIC': 'AQUATIC',
    'MOUNTABLE': 'MOUNT',
    'SUMMONED_MOUNT': 'SUMMONED',  # Also adds MOUNT
    'PET': 'PET',
}

# Mob flags that map to MobBehavior enum (how the mob ACTS)
MOB_FLAG_TO_BEHAVIOR = {
    'SENTINEL': 'SENTINEL',
    'STAY_ZONE': 'STAY_ZONE',
    'SCAVENGER': 'SCAVENGER',
    'FAST_TRACK': 'FAST_TRACK',
    'SLOW_TRACK': 'SLOW_TRACK',
    'WIMPY': 'WIMPY',
    'AWARE': 'AWARE',
    'HELPER': 'HELPER',
    'PROTECTOR': 'PROTECTOR',
    'PEACEKEEPER': 'PEACEKEEPER',
    'NO_BASH': 'NO_BASH',
    'NO_SUMMON': 'NO_SUMMON',
    'NO_VICIOUS': 'NO_VICIOUS',
    'MEMORY': 'MEMORY',
    'TEACHER': 'TEACHER',
    'NO_SCRIPT': 'NO_SCRIPT',
    'NO_CLASS_AI': 'NO_CLASS_AI',
    'PEACEFUL': 'PEACEFUL',
}

# Mob flags that map to MobProfession enum (services mob provides)
# Note: These are usually auto-detected from mob name/keywords
MOB_FLAG_TO_PROFESSION = {
    'BANKER': 'BANKER',
    'POSTMASTER': 'POSTMASTER',
    'RECEPTIONIST': 'RECEPTIONIST',
    'SHOPKEEPER': 'SHOPKEEPER',
    'GUILDMASTER': 'GUILDMASTER',
    'TRAINER': 'TRAINER',
}

# Mob flags that become resistance entries (value 0 = immune)
# Format: flag_name -> effect_name for resistances JSON
MOB_FLAG_TO_RESISTANCE = {
    'NO_CHARM': 'charm',
    'NO_SLEEP': 'sleep',
    'NO_BLIND': 'blind',
    'NO_SILENCE': 'silence',
    'NO_POISON': 'poison',
}

# Mob flags to ignore (deprecated or runtime-only)
MOB_FLAGS_DEPRECATED = {
    'SPEC',        # Legacy spec_procs
    'IS_NPC',      # Auto-set, not stored
    'CASTING',     # Runtime state
    'NO_EQ_RESTRICT',  # Deprecated
}


# =============================================================================
# EFFECT FLAG REORGANIZATION
# Effect flags now create entries in MobDefaultEffects/ObjectEffects junction tables
# =============================================================================

# Effect flag names that should create Effect table lookups
# Maps legacy effect flag name to canonical effect name in database
EFFECT_FLAG_TO_EFFECT_NAME = {
    'BLIND': 'BLIND',
    'INVISIBLE': 'INVISIBLE',
    'DETECT_ALIGN': 'DETECT_ALIGN',
    'DETECT_INVIS': 'DETECT_INVIS',
    'DETECT_MAGIC': 'DETECT_MAGIC',
    'SENSE_LIFE': 'SENSE_LIFE',
    'WATERWALK': 'WATERWALK',
    'SANCTUARY': 'SANCTUARY',
    'CONFUSION': 'CONFUSION',
    'CURSE': 'CURSE',
    'INFRAVISION': 'INFRAVISION',
    'POISON': 'POISON',
    'PROTECT_EVIL': 'PROTECT_EVIL',
    'PROTECT_GOOD': 'PROTECT_GOOD',
    'SLEEP': 'SLEEP',
    'NO_TRACK': 'NO_TRACK',
    'TAMED': 'TAMED',
    'BERSERK': 'BERSERK',
    'SNEAK': 'SNEAK',
    'STEALTH': 'STEALTH',
    'FLY': 'FLY',
    'CHARM': 'CHARM',
    'STONE_SKIN': 'STONE_SKIN',
    'FARSEE': 'FARSEE',
    'HASTE': 'HASTE',
    'BLUR': 'BLUR',
    'VITALITY': 'VITALITY',
    'GLORY': 'GLORY',
    'MAJOR_PARALYSIS': 'MAJOR_PARALYSIS',
    'FAMILIARITY': 'FAMILIARITY',
    'MESMERIZED': 'MESMERIZED',
    'IMMOBILIZED': 'IMMOBILIZED',
    'LIGHT': 'LIGHT',
    'MINOR_PARALYSIS': 'MINOR_PARALYSIS',
    'HURT_THROAT': 'HURT_THROAT',
    'FEATHER_FALL': 'FEATHER_FALL',
    'WATERBREATH': 'WATERBREATH',
    'SOULSHIELD': 'SOULSHIELD',
    'SILENCE': 'SILENCE',
    'PROTECT_FIRE': 'PROTECT_FIRE',
    'PROTECT_COLD': 'PROTECT_COLD',
    'PROTECT_AIR': 'PROTECT_AIR',
    'PROTECT_EARTH': 'PROTECT_EARTH',
    'FIRESHIELD': 'FIRESHIELD',
    'COLDSHIELD': 'COLDSHIELD',
    'MINOR_GLOBE': 'MINOR_GLOBE',
    'MAJOR_GLOBE': 'MAJOR_GLOBE',
    'HARNESS': 'HARNESS',
    'ON_FIRE': 'ON_FIRE',
    'FEAR': 'FEAR',
    'TONGUES': 'TONGUES',
    'DISEASE': 'DISEASE',
    'INSANITY': 'INSANITY',
    'ULTRAVISION': 'ULTRAVISION',
    'NEGATE_HEAT': 'NEGATE_HEAT',
    'NEGATE_COLD': 'NEGATE_COLD',
    'NEGATE_AIR': 'NEGATE_AIR',
    'NEGATE_EARTH': 'NEGATE_EARTH',
    'REMOTE_AGGRO': 'REMOTE_AGGRO',
    'AWARE': 'AWARE',
    'REDUCE': 'REDUCE',
    'ENLARGE': 'ENLARGE',
    'VAMPIRIC_TOUCH': 'VAMPIRIC_TOUCH',
    'RAY_OF_ENFEEBLEMENT': 'RAY_OF_ENFEEBLEMENT',
    'ANIMATED': 'ANIMATED',
    'EXPOSED': 'EXPOSED',
    'SHADOWING': 'SHADOWING',
    'CAMOUFLAGED': 'CAMOUFLAGED',
    'SPIRIT_WOLF': 'SPIRIT_WOLF',
    'SPIRIT_BEAR': 'SPIRIT_BEAR',
    'WRATH': 'WRATH',
    'MISDIRECTION': 'MISDIRECTION',
    'MISDIRECTING': 'MISDIRECTING',
    'BLESS': 'BLESS',
    'HEX': 'HEX',
    'DETECT_POISON': 'DETECT_POISON',
    'SONG_OF_REST': 'SONG_OF_REST',
    'DISPLACEMENT': 'DISPLACEMENT',
    'GREATER_DISPLACEMENT': 'GREATER_DISPLACEMENT',
    'FIRE_WEAPON': 'FIRE_WEAPON',
    'ICE_WEAPON': 'ICE_WEAPON',
    'POISON_WEAPON': 'POISON_WEAPON',
    'ACID_WEAPON': 'ACID_WEAPON',
    'SHOCK_WEAPON': 'SHOCK_WEAPON',
    'RADIANT_WEAPON': 'RADIANT_WEAPON',
}


# =============================================================================
# OBJECT FLAG REORGANIZATION
# =============================================================================

# Object flags that remain in the ObjectFlag enum
OBJECT_FLAGS_KEEP = {
    'GLOW', 'HUM', 'INVISIBLE', 'MAGIC', 'PERMANENT', 'TEMPORARY',
    'DECOMPOSING', 'FLOAT', 'BUOYANT', 'VEHICLE', 'SOULBOUND', 'NO_FALL',
}

# Object flags that map to ObjectRestriction enum
OBJECT_FLAG_TO_RESTRICTION = {
    'NO_DROP': 'NO_DROP',
    'NO_SELL': 'NO_SELL',
    'NO_BURN': 'NO_BURN',
    'NO_LOCATE': 'NO_LOCATE',
    'NO_INVISIBLE': 'NO_INVISIBLE',
    'NODROP': 'NO_DROP',
    'NOSELL': 'NO_SELL',
    'NOBURN': 'NO_BURN',
    'NOLOCATE': 'NO_LOCATE',
    'NOINVISIBLE': 'NO_INVISIBLE',
}

# Object ANTI_* flags that map to Alignment restrictions
OBJECT_ANTI_TO_ALIGNMENT = {
    'ANTI_GOOD': 'GOOD',
    'ANTI_EVIL': 'EVIL',
    'ANTI_NEUTRAL': 'NEUTRAL',
}

# Object ANTI_* flags that map to class ID restrictions
# Maps flag name to class ID (1-indexed in database)
OBJECT_ANTI_TO_CLASS_ID = {
    'ANTI_SORCERER': 1,
    'ANTI_CLERIC': 2,
    'ANTI_ROGUE': 3,
    'ANTI_WARRIOR': 4,
    'ANTI_PALADIN': 5,
    'ANTI_ANTI_PALADIN': 6,
    'ANTI_RANGER': 7,
    'ANTI_DRUID': 8,
    'ANTI_SHAMAN': 9,
    'ANTI_ASSASSIN': 10,
    'ANTI_MERCENARY': 11,
    'ANTI_NECROMANCER': 12,
    'ANTI_CONJURER': 13,
    'ANTI_MONK': 14,
    'ANTI_BERSERKER': 15,
    'ANTI_BARD': 16,
    'ANTI_THIEF': 17,
    'ANTI_PYROMANCER': 18,
    'ANTI_CRYOMANCER': 19,
    'ANTI_ILLUSIONIST': 20,
    'ANTI_PRIEST': 21,
    'ANTI_DIABOLIST': 22,
}

# Size ordering for proper comparison (smallest to largest)
SIZE_ORDER = ['TINY', 'SMALL', 'MEDIUM', 'LARGE', 'HUGE', 'GIANT', 'GARGANTUAN', 'COLOSSAL', 'TITANIC', 'MOUNTAINOUS']

# Object ANTI_* flags that map to Size restrictions
# These set either minSize (for ANTI_TINY/SMALL) or maxSize (for large sizes)
OBJECT_ANTI_TO_SIZE = {
    'ANTI_TINY': ('min', 'SMALL'),       # Can't use if TINY - min size is SMALL
    'ANTI_SMALL': ('min', 'MEDIUM'),     # Can't use if SMALL - min size is MEDIUM
    'ANTI_MEDIUM': None,                  # Complex - skip for now
    'ANTI_LARGE': ('max', 'MEDIUM'),     # Can't use if LARGE - max size is MEDIUM
    'ANTI_HUGE': ('max', 'LARGE'),       # Can't use if HUGE - max size is LARGE
    'ANTI_GIANT': ('max', 'HUGE'),
    'ANTI_GARGANTUAN': ('max', 'GIANT'),
    'ANTI_COLOSSAL': ('max', 'GARGANTUAN'),
    'ANTI_TITANIC': ('max', 'COLOSSAL'),
    'ANTI_MOUNTAINOUS': ('max', 'TITANIC'),
}

# Object ANTI_* flags that map to Race restrictions (CANNOT use)
OBJECT_ANTI_TO_RACE = {
    'ANTI_ARBOREAN': 'ARBOREAN',
}

# Object flags that map to allowed races (ONLY these races CAN use)
# These are the opposite of ANTI_* - they're inclusive restrictions
OBJECT_RACE_ALLOWED = {
    'ELVEN': 'ELF',       # Only elves can use
    'DWARVEN': 'DWARF',   # Only dwarves can use
}

# Object flags to ignore (deprecated or handled elsewhere)
OBJECT_FLAGS_DEPRECATED = {
    'WAS_DISARMED',  # Runtime-only
    'NO_TAKE',       # Handled by wearFlags
}


# =============================================================================
# LEGACY FLAG MAPPINGS (for normalization before categorization)
# =============================================================================

# Mapping of legacy flag names to canonical schema names
# The Python flags.py allows parsing both, but we normalize to canonical before DB insert
FLAG_MAPPINGS = {
    # Legacy underscore-free variants -> canonical names
    'NOMOB': 'NO_MOB',
    'NOTRACK': 'NO_TRACK',
    'NOMAGIC': 'NO_MAGIC',
    'NOWELL': 'NO_WELL',
    'NOSUMMON': 'NO_SUMMON',
    'NOSCAN': 'NO_SCAN',
    'NOSHIFT': 'NO_SHIFT',
    'NORECALL': 'NO_RECALL',
    'ISNPC': 'IS_NPC',
    'NOSILENCE': 'NO_SILENCE',
    'NOPOISON': 'NO_POISON',
    'NOVICIOUS': 'NO_VICIOUS',
    'NOEQUIPMENTRESTRICT': 'NO_EQ_RESTRICT',
    'NORENT': 'TEMPORARY',
    'NO_RENT': 'TEMPORARY',
    'NOINVISIBLE': 'NO_INVISIBLE',
    'NODROP': 'NO_DROP',
    'NOSELL': 'NO_SELL',
    'NOBURN': 'NO_BURN',
    'NOLOCATE': 'NO_LOCATE',

    # Legacy abbreviated names -> full names
    'PROT_AIR': 'PROTECT_AIR',
    'PROT_FIRE': 'PROTECT_FIRE',
    'PROT_COLD': 'PROTECT_COLD',
    'PROT_EARTH': 'PROTECT_EARTH',
    'REMOTE_AGGR': 'REMOTE_AGGRO',

    # Legacy synonyms where the name changed
    'NO_EQUIPMENT_RESTRICT': 'NO_EQ_RESTRICT',

    # Legacy mob flags with different spelling (normalize first, then filter)
    'AGGR_EVIL_RACE': 'AGGRO_EVIL_RACE',
    'AGGR_GOOD_RACE': 'AGGRO_GOOD_RACE',
    'AGGR_EVIL': 'AGGRO_EVIL',
    'AGGR_GOOD': 'AGGRO_GOOD',
    'AGGR_NEUTRAL': 'AGGRO_NEUTRAL',
    'NOSCRIPT': 'NO_SCRIPT',
    'ILLUSORY': 'ILLUSION',
    'NOCHARM': 'NO_CHARM',
    'NOSLEEP': 'NO_SLEEP',
    'NOBASH': 'NO_BASH',
    'NOBLIND': 'NO_BLIND',
    'NOCLASS_AI': 'NO_CLASS_AI',

    # Deprecated/removed flags (filter out by mapping to None)
    # These existed in old CircleMUD but are no longer in the schema

    # FLAG REORGANIZATION (2024) - Legacy flag migrations
    # Exit flags - CLOSED/LOCKED moved to defaultState field, handled by exit importer
    'CLOSED': None,  # Use defaultState: CLOSED instead
    'LOCKED': None,  # Use defaultState: LOCKED instead

    # Object flags - deprecated ones
    'NOFALL': 'NO_FALL',
    'WAS_DISARMED': None,  # Runtime-only flag, not stored

    # WearFlag migrations - legacy hand slots
    'SHIELD': 'OFFHAND',
    'WIELD': 'MAINHAND',
    'HOLD': 'OFFHAND',
    'TWO_HAND_WIELD': 'TWOHAND',  # Normalized to match MAINHAND/OFFHAND pattern
}

# Aggro flags that should be converted to aggroCondition Lua expressions
# These are filtered OUT of mobFlags and converted separately
AGGRO_FLAGS = {
    'AGGRESSIVE',
    'AGGRO_EVIL',
    'AGGRO_GOOD',
    'AGGRO_NEUTRAL',
    'AGGRO_EVIL_RACE',
    'AGGRO_GOOD_RACE',
}

# Alignment threshold constants (defined in game Lua runtime)
# ALIGN.GOOD = 350, ALIGN.EVIL = -350
# These make aggro conditions more readable for builders

# Mapping of aggro flags to Lua condition expressions
AGGRO_TO_CONDITION = {
    'AGGRESSIVE': 'true',  # Attacks everyone
    'AGGRO_EVIL': 'target.alignment <= ALIGN.EVIL',
    'AGGRO_GOOD': 'target.alignment >= ALIGN.GOOD',
    'AGGRO_NEUTRAL': 'target.alignment > ALIGN.EVIL and target.alignment < ALIGN.GOOD',
    'AGGRO_EVIL_RACE': "target.race.alignment == 'EVIL'",
    'AGGRO_GOOD_RACE': "target.race.alignment == 'GOOD'",
}





def normalize_flag(flag: str) -> str:
    """
    Normalize legacy flag name to match Prisma schema format

    Checks if the flag needs conversion from legacy format (no underscore)
    to schema format (with underscore).

    Args:
        flag: Flag string (e.g., "ALWAYSLIT", "NO_MOB", "STAY_ZONE")

    Returns:
        Normalized flag string (e.g., "ALWAYS_LIT", "NO_MOB", "STAY_ZONE")

    Examples:
        >>> normalize_flag('ALWAYSLIT')
        'ALWAYS_LIT'
        >>> normalize_flag('NO_MOB')
        'NO_MOB'
        >>> normalize_flag('ISNPC')
        'IS_NPC'
        >>> normalize_flag('STAY_ZONE')
        'STAY_ZONE'
    """
    return FLAG_MAPPINGS.get(flag, flag)


def normalize_flags(flags: list) -> list:
    """
    Normalize a list of flags and filter out deprecated ones

    Args:
        flags: List of flag strings

    Returns:
        List of normalized flag strings (deprecated flags removed)

    Examples:
        >>> normalize_flags(['NO_MOB', 'STAY_ZONE', 'SENTINEL'])
        ['NO_MOB', 'STAY_ZONE', 'SENTINEL']
        >>> normalize_flags(['FLY', 'NO_MOB'])  # FLY is deprecated
        ['NO_MOB']
    """
    normalized = [normalize_flag(flag) for flag in flags]
    # Filter out None values (deprecated flags)
    return [f for f in normalized if f is not None]


def normalize_mob_flags(flags: list) -> tuple[list, str | None]:
    """
    Normalize mob flags, extracting aggro flags into an aggroCondition expression.

    Aggro flags (AGGRESSIVE, AGGRO_EVIL, etc.) are converted to a Lua expression
    that defines who the mob attacks on sight.

    Args:
        flags: List of mob flag strings

    Returns:
        Tuple of (filtered_mob_flags, aggro_condition)
        - filtered_mob_flags: List of flags with aggro flags removed
        - aggro_condition: Lua expression string or None if no aggro flags

    Examples:
        >>> normalize_mob_flags(['SENTINEL', 'AGGRESSIVE', 'MEMORY'])
        (['SENTINEL', 'MEMORY'], 'true')
        >>> normalize_mob_flags(['AGGRO_EVIL', 'AGGRO_EVIL_RACE'])
        ([], "target.alignment <= -350 or target.race.alignment == 'EVIL'")
        >>> normalize_mob_flags(['SENTINEL', 'HELPER'])
        (['SENTINEL', 'HELPER'], None)
    """
    # First normalize all flags
    normalized = [normalize_flag(flag) for flag in flags]
    # Filter out None values (deprecated flags)
    normalized = [f for f in normalized if f is not None]

    # Separate aggro flags from other flags
    aggro_found = []
    other_flags = []

    for flag in normalized:
        if flag in AGGRO_FLAGS:
            aggro_found.append(flag)
        else:
            other_flags.append(flag)

    # Convert aggro flags to condition expression
    aggro_condition = None
    if aggro_found:
        # If AGGRESSIVE is present, it overrides everything (attacks all)
        if 'AGGRESSIVE' in aggro_found:
            aggro_condition = 'true'
        else:
            # Combine multiple conditions with OR
            conditions = [AGGRO_TO_CONDITION[flag] for flag in aggro_found]
            if len(conditions) == 1:
                aggro_condition = conditions[0]
            else:
                # Wrap each condition in parens and join with 'or'
                aggro_condition = ' or '.join(f'({c})' for c in conditions)

    return other_flags, aggro_condition


# Legacy mob EFF_* flag -> `status` effect flag (data/effects.json "status"
# params.flag, as used by data/abilities.json). The Effect catalog is a small
# registry of generic effect *types* ("status", "damage", ...), so a mob's
# innate effects are stored as ONE MobDefaultEffects row pointing at the
# `status` Effect whose modifier_data is {"flags": [<status flag>, ...]}
# (MobDefaultEffects is unique on (mob, effect), so several status flags per
# mob have to share the row). Each target flag below is granted by a status
# ability in data/abilities.json (checked by tests/test_mob_default_effects.py).
#
# Deliberately NOT mapped (logged as skipped by mob_default_status_flags):
#   CHARM, TAMED, FAMILIARITY       - need a master / are relationship state
#   PROTECT_*, STONE_SKIN, NEGATE_*, SOULSHIELD, MAJOR/MINOR_GLOBE
#                                   - resistances/globes, not status flags
#   NO_TRACK, REMOTE_AGGRO, VITALITY, GLORY, INSANITY, CAMOUFLAGED, MESMERIZED,
#   DISPLACEMENT, ... (anything else) - no status ability / flag in the catalog
MOB_EFFECT_FLAG_TO_STATUS_FLAG = {
    'BLIND': 'blinded',
    'INVISIBLE': 'invisible',
    'DETECT_ALIGN': 'detect_align',
    'DETECT_INVIS': 'detect_invisible',
    'DETECT_MAGIC': 'detect_magic',
    'SENSE_LIFE': 'detect_life',
    'WATERWALK': 'waterwalk',
    'SANCTUARY': 'sanctuary',
    'CONFUSION': 'confused',
    'CURSE': 'cursed',
    'INFRAVISION': 'infravision',
    'POISON': 'poisoned',
    'SLEEP': 'sleeping',
    'BERSERK': 'berserk',
    'SNEAK': 'sneak',
    'STEALTH': 'hidden',
    'FLY': 'fly',
    'FARSEE': 'detect_hidden',
    'HASTE': 'haste',
    'BLUR': 'blur',
    'MAJOR_PARALYSIS': 'paralyzed',
    'MINOR_PARALYSIS': 'paralyzed',
    'LIGHT': 'glowing',
    'FEATHER_FALL': 'featherfall',
    'WATERBREATH': 'waterbreath',
    'SILENCE': 'silenced',
    'FIRESHIELD': 'fireshield',
    'COLDSHIELD': 'coldshield',
    'HARNESS': 'empowered',
    'FEAR': 'feared',
    'DISEASE': 'diseased',
    'ULTRAVISION': 'ultravision',
    'AWARE': 'aware',
    'BLESS': 'bless',
    'DETECT_POISON': 'detect_poison',
}


# Object-only additions on top of MOB_EFFECT_FLAG_TO_STATUS_FLAG (the mob / race table is
# deliberately unchanged). Only bits the runtime or the spell vocabulary already has a
# counterpart for; the rest stay skipped (see ProcessedObjectFlags.skipped_effect_flags):
#   PROTECT_EVIL / PROTECT_GOOD -> fierymud-rs ProtectFromEvil / ProtectFromGood markers
#   TONGUES      -> language_fluency (same flag the SPEAK_IN_TONGUES ability applies)
#   FAMILIARITY  -> familiarity (flag already used by ability status effects)
# MINOR_GLOBE / MAJOR_GLOBE are not status flags: fierymud-rs models a worn globe as an
# ObjectEffects row of the `globe` Effect with strength = max absorbed circle
# (OBJECT_GLOBE_MAX_CIRCLE). STONE_SKIN is a PHYSICAL ObjectResistance
# (importer EFFECT_TO_RESISTANCE), like the STONE_SKIN ability's `resistance` status.
# Deliberately NOT mapped on worn gear: CHARM / TAMED (pet-master state with no master),
# ON_FIRE (burning DoT, cleared by water), HURT_THROAT (permanent spell-failure debuff),
# VITALITY / GLORY / NO_TRACK (no runtime marker or flag).
OBJECT_EFFECT_FLAG_TO_STATUS_FLAG = {
    'PROTECT_EVIL': 'protect_evil',
    'PROTECT_GOOD': 'protect_good',
    'TONGUES': 'language_fluency',
    'FAMILIARITY': 'familiarity',
}

OBJECT_STATUS_FLAG_TABLE = {**MOB_EFFECT_FLAG_TO_STATUS_FLAG, **OBJECT_EFFECT_FLAG_TO_STATUS_FLAG}

# Worn globe: legacy EFF_MINOR_GLOBE blocks circles 1-3, EFF_MAJOR_GLOBE 1-6.
OBJECT_GLOBE_MAX_CIRCLE = {'MINOR_GLOBE': 3, 'MAJOR_GLOBE': 6}


def object_globe_circle(effect_flags: list) -> int:
    """Highest max-absorbed circle among an object's globe bits (0 = none)."""
    names = {normalize_flag(f) for f in effect_flags or [] if f}
    return max((c for k, c in OBJECT_GLOBE_MAX_CIRCLE.items() if k in names), default=0)


def mob_default_status_flags(
    effect_flags: list, table: dict[str, str] | None = None
) -> tuple[list[str], list[str]]:
    """
    Map a mob's legacy EFF_* flag names to `status` effect flags.
    (`table` overrides MOB_EFFECT_FLAG_TO_STATUS_FLAG; objects pass OBJECT_STATUS_FLAG_TABLE.)

    Returns (status_flags, skipped): status_flags is de-duplicated and sorted
    (stable output for DB rows / generated SQL); skipped lists the legacy flag
    names with no catalog mapping (UNUSED placeholders are ignored).
    """
    flags: list[str] = []
    skipped: list[str] = []
    for raw in effect_flags or []:
        name = normalize_flag(raw) if raw else None
        if not name or name == 'UNUSED':
            continue
        status = (table if table is not None else MOB_EFFECT_FLAG_TO_STATUS_FLAG).get(name)
        if status is None:
            if name not in skipped:
                skipped.append(name)
        elif status not in flags:
            flags.append(status)
    return sorted(flags), skipped



@dataclass
class ProcessedMobFlags:
    """Result of processing legacy mob flags into modern schema format"""
    traits: list[str]           # MobTrait enum values
    behaviors: list[str]        # MobBehavior enum values
    professions: list[str]      # MobProfession enum values
    resistances: dict[str, int] # Effect name -> resistance value (0 = immune)
    effect_names: list[str]     # Legacy effect-flag names (kept for Mobs.effect_flags)
    default_status_flags: list[str]  # `status` flags for the MobDefaultEffects row
    skipped_effect_flags: list[str]  # Legacy EFF_* flags with no catalog mapping
    aggro_formula: str | None   # Lua expression for aggression


def process_mob_flags(mob_flags: list, effect_flags: list) -> ProcessedMobFlags:
    """
    Process legacy mob flags and effect flags into modern schema format.

    Converts:
    - mob_flags → traits, behaviors, professions, resistances
    - effect_flags → default_status_flags (MobDefaultEffects `status` row)
    - aggro flags → aggro_formula (Lua expression)

    Args:
        mob_flags: List of legacy mob flag strings
        effect_flags: List of legacy effect flag strings

    Returns:
        ProcessedMobFlags dataclass with categorized flags

    Example:
        >>> result = process_mob_flags(
        ...     ['SENTINEL', 'NO_CHARM', 'AGGRESSIVE', 'MOUNTABLE'],
        ...     ['HASTE', 'INVISIBLE']
        ... )
        >>> result.traits
        ['MOUNT']
        >>> result.behaviors
        ['SENTINEL']
        >>> result.resistances
        {'charm': 0}
        >>> result.effect_names
        ['HASTE', 'INVISIBLE']
        >>> result.aggro_formula
        'true'
    """
    # Normalize all flags first
    normalized_mob = [normalize_flag(f) for f in mob_flags if f]
    normalized_mob = [f for f in normalized_mob if f is not None]

    normalized_effects = [normalize_flag(f) for f in effect_flags if f]
    normalized_effects = [f for f in normalized_effects if f is not None]

    traits = []
    behaviors = []
    professions = []
    resistances = {}
    aggro_found = []

    for flag in normalized_mob:
        # Skip deprecated flags
        if flag in MOB_FLAGS_DEPRECATED:
            continue

        # Check aggro flags
        if flag in AGGRO_FLAGS:
            aggro_found.append(flag)
            continue

        # Check trait mappings
        if flag in MOB_FLAG_TO_TRAIT:
            trait = MOB_FLAG_TO_TRAIT[flag]
            if trait not in traits:
                traits.append(trait)
            # Special case: SUMMONED_MOUNT adds both SUMMONED and MOUNT
            if flag == 'SUMMONED_MOUNT' and 'MOUNT' not in traits:
                traits.append('MOUNT')
            continue

        # Check behavior mappings
        if flag in MOB_FLAG_TO_BEHAVIOR:
            behavior = MOB_FLAG_TO_BEHAVIOR[flag]
            if behavior not in behaviors:
                behaviors.append(behavior)
            continue

        # Check profession mappings
        if flag in MOB_FLAG_TO_PROFESSION:
            profession = MOB_FLAG_TO_PROFESSION[flag]
            if profession not in professions:
                professions.append(profession)
            continue

        # Check resistance mappings (NO_CHARM, NO_SLEEP, etc.)
        if flag in MOB_FLAG_TO_RESISTANCE:
            effect_name = MOB_FLAG_TO_RESISTANCE[flag]
            resistances[effect_name] = 0  # 0 = immune
            continue

    # Convert aggro flags to Lua formula
    aggro_formula = None
    if aggro_found:
        if 'AGGRESSIVE' in aggro_found:
            aggro_formula = 'true'
        else:
            conditions = [AGGRO_TO_CONDITION[f] for f in aggro_found if f in AGGRO_TO_CONDITION]
            if len(conditions) == 1:
                aggro_formula = conditions[0]
            elif len(conditions) > 1:
                aggro_formula = ' or '.join(f'({c})' for c in conditions)

    # Process effect flags - these become MobDefaultEffects entries
    effect_names = []
    for flag in normalized_effects:
        if flag in EFFECT_FLAG_TO_EFFECT_NAME:
            effect_name = EFFECT_FLAG_TO_EFFECT_NAME[flag]
            if effect_name not in effect_names:
                effect_names.append(effect_name)

    default_status_flags, skipped_effect_flags = mob_default_status_flags(normalized_effects)

    return ProcessedMobFlags(
        traits=traits,
        behaviors=behaviors,
        professions=professions,
        resistances=resistances,
        effect_names=effect_names,
        default_status_flags=default_status_flags,
        skipped_effect_flags=skipped_effect_flags,
        aggro_formula=aggro_formula,
    )


@dataclass
class ProcessedObjectFlags:
    """Result of processing legacy object flags into modern schema format"""
    flags: list[str]                 # ObjectFlag enum values (GLOW, HUM, etc.)
    restrictions: list[str]          # ObjectRestriction enum values (NO_DROP, NO_SELL, etc.)
    restricted_alignments: list[str] # Alignment enum values that CANNOT use
    restricted_class_ids: list[int]  # Class IDs that CANNOT use
    restricted_races: list[str]      # Race enum values that CANNOT use
    allowed_races: list[str]         # Race enum values that CAN use (ELVEN, DWARVEN items)
    min_size: str | None             # Minimum size to use item
    max_size: str | None             # Maximum size to use item
    effect_names: list[str]          # Legacy effect-flag names (resistance mapping uses these)
    status_flags: list[str]          # `status` flags for the ObjectEffects status row
    skipped_effect_flags: list[str]  # Legacy EFF_* flags with no status mapping
    globe_circle: int                # Max absorbed circle for a worn `globe` row (0 = none)


def process_object_flags(obj_flags: list, effect_flags: list) -> ProcessedObjectFlags:
    """
    Process legacy object flags and effect flags into modern schema format.

    Converts:
    - obj_flags → flags, restrictions, restrictedAlignments, restrictedClassIds,
                  restrictedRaces, minSize, maxSize
    - effect_flags → status_flags (one ObjectEffects `status` row, same
                     MOB_EFFECT_FLAG_TO_STATUS_FLAG table mobs use)

    Args:
        obj_flags: List of legacy object flag strings
        effect_flags: List of legacy effect flag strings

    Returns:
        ProcessedObjectFlags dataclass with categorized flags

    Example:
        >>> result = process_object_flags(
        ...     ['GLOW', 'MAGIC', 'ANTI_EVIL', 'ANTI_WARRIOR', 'NO_DROP'],
        ...     ['INVISIBLE']
        ... )
        >>> result.flags
        ['GLOW', 'MAGIC']
        >>> result.restrictions
        ['NO_DROP']
        >>> result.restricted_alignments
        ['EVIL']
        >>> result.restricted_class_ids
        [4]
        >>> result.effect_names
        ['INVISIBLE']
    """
    # Normalize all flags first
    normalized_obj = [normalize_flag(f) for f in obj_flags if f]
    normalized_obj = [f for f in normalized_obj if f is not None]

    normalized_effects = [normalize_flag(f) for f in effect_flags if f]
    normalized_effects = [f for f in normalized_effects if f is not None]

    flags = []
    restrictions = []
    restricted_alignments = []
    restricted_class_ids = []
    restricted_races = []
    allowed_races = []
    min_size = None
    max_size = None

    for flag in normalized_obj:
        # Skip deprecated flags
        if flag in OBJECT_FLAGS_DEPRECATED:
            continue

        # Check if it's a flag we keep
        if flag in OBJECT_FLAGS_KEEP:
            if flag not in flags:
                flags.append(flag)
            continue

        # Check restriction mappings
        if flag in OBJECT_FLAG_TO_RESTRICTION:
            restriction = OBJECT_FLAG_TO_RESTRICTION[flag]
            if restriction not in restrictions:
                restrictions.append(restriction)
            continue

        # Check alignment restrictions
        if flag in OBJECT_ANTI_TO_ALIGNMENT:
            alignment = OBJECT_ANTI_TO_ALIGNMENT[flag]
            if alignment not in restricted_alignments:
                restricted_alignments.append(alignment)
            continue

        # Check class restrictions
        if flag in OBJECT_ANTI_TO_CLASS_ID:
            class_id = OBJECT_ANTI_TO_CLASS_ID[flag]
            if class_id not in restricted_class_ids:
                restricted_class_ids.append(class_id)
            continue

        # Check size restrictions
        if flag in OBJECT_ANTI_TO_SIZE:
            size_info = OBJECT_ANTI_TO_SIZE[flag]
            if size_info:
                size_type, size_value = size_info
                if size_type == 'min':
                    # Take the largest min_size
                    if min_size is None or SIZE_ORDER.index(size_value) > SIZE_ORDER.index(min_size):
                        min_size = size_value
                elif size_type == 'max':
                    # Take the smallest max_size
                    if max_size is None or SIZE_ORDER.index(size_value) < SIZE_ORDER.index(max_size):
                        max_size = size_value
            continue

        # Check race restrictions (CANNOT use)
        if flag in OBJECT_ANTI_TO_RACE:
            race = OBJECT_ANTI_TO_RACE[flag]
            if race and race not in restricted_races:
                restricted_races.append(race)
            continue

        # Check allowed races (ONLY these CAN use - e.g., ELVEN, DWARVEN)
        if flag in OBJECT_RACE_ALLOWED:
            race = OBJECT_RACE_ALLOWED[flag]
            if race and race not in allowed_races:
                allowed_races.append(race)
            continue

    # Process effect flags - these become ObjectEffects entries
    effect_names = []
    for flag in normalized_effects:
        if flag in EFFECT_FLAG_TO_EFFECT_NAME:
            effect_name = EFFECT_FLAG_TO_EFFECT_NAME[flag]
            if effect_name not in effect_names:
                effect_names.append(effect_name)

    status_flags, skipped_effect_flags = mob_default_status_flags(normalized_effects, OBJECT_STATUS_FLAG_TABLE)

    return ProcessedObjectFlags(
        flags=flags,
        restrictions=restrictions,
        restricted_alignments=restricted_alignments,
        restricted_class_ids=restricted_class_ids,
        restricted_races=restricted_races,
        allowed_races=allowed_races,
        min_size=min_size,
        max_size=max_size,
        effect_names=effect_names,
        status_flags=status_flags,
        skipped_effect_flags=skipped_effect_flags,
        globe_circle=object_globe_circle(normalized_effects),
    )
