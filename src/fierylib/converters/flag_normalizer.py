"""
Flag Normalizer - Convert legacy flag names to schema format

The Python flags.py contains both modern and legacy flag names for parsing.
This normalizer converts legacy names to their canonical forms before
inserting into the Prisma database, keeping the schema clean.
"""


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
    'NO_FALL': 'FLOAT',  # NO_FALL merged into FLOAT
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
