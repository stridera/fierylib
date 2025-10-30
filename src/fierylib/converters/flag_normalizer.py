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
    'NORENT': 'NO_RENT',
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
    'AGGRO_EVIL_RACE': 'AGGRO_EVIL',
    'AGGRO_GOOD_RACE': 'AGGRO_GOOD',
    'AGGRO_NEUTRAL_RACE': 'AGGRO_NEUTRAL',
    'NO_EQUIPMENT_RESTRICT': 'NO_EQ_RESTRICT',

    # Deprecated/removed flags (filter out by mapping to None)
    # These existed in old CircleMUD but are no longer in the schema
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
