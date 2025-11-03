"""
Skill Name Normalizer - Maps C++ skill names to better database names

C++ uses abbreviated names (2H_, VAMP_TOUCH, HITALL) for brevity in code.
We normalize these to more readable names for the database and UI.
"""

# Mapping from C++ name → Database name
SKILL_NAME_MAPPING = {
    # Two-handed weapon skills (2H_ → TWO_HAND_)
    "2H_BLUDGEONING": "TWO_HAND_BLUDGEONING",
    "2H_PIERCING": "TWO_HAND_PIERCING",
    "2H_SLASHING": "TWO_HAND_SLASHING",

    # Abbreviated skill names
    "HITALL": "HIT_ALL",
    "VAMP_TOUCH": "VAMPIRIC_TOUCH",
}

# Reverse mapping for lookups (Database name → C++ name)
REVERSE_SKILL_NAME_MAPPING = {v: k for k, v in SKILL_NAME_MAPPING.items()}


def normalize_skill_name(cpp_name: str) -> str:
    """
    Convert C++ skill name to normalized database name

    Args:
        cpp_name: Skill name from C++ source (e.g., "2H_BLUDGEONING", "HITALL")

    Returns:
        Normalized database name (e.g., "TWO_HAND_BLUDGEONING", "HIT_ALL")

    Examples:
        >>> normalize_skill_name("2H_BLUDGEONING")
        'TWO_HAND_BLUDGEONING'
        >>> normalize_skill_name("HITALL")
        'HIT_ALL'
        >>> normalize_skill_name("BACKSTAB")
        'BACKSTAB'
    """
    return SKILL_NAME_MAPPING.get(cpp_name, cpp_name)


def denormalize_skill_name(db_name: str) -> str:
    """
    Convert database skill name back to C++ name

    Args:
        db_name: Skill name from database (e.g., "TWO_HAND_BLUDGEONING", "HIT_ALL")

    Returns:
        C++ source name (e.g., "2H_BLUDGEONING", "HITALL")

    Examples:
        >>> denormalize_skill_name("TWO_HAND_BLUDGEONING")
        '2H_BLUDGEONING'
        >>> denormalize_skill_name("HIT_ALL")
        'HITALL'
        >>> denormalize_skill_name("BACKSTAB")
        'BACKSTAB'
    """
    return REVERSE_SKILL_NAME_MAPPING.get(db_name, db_name)
