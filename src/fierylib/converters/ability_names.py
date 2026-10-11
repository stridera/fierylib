"""Display-name normalisation for abilities (spells, skills, chants, songs).

The legacy data capitalised names two ways ("Armor Of Gaia" next to "Cloak of
Gaia"), dropped apostrophes ("Bigbys Clenched Fist" next to "Hell's Gate") and
spelled one rung of the cure/cause/vigorize ladder "Critic" next to "Critical".
`Ability.name` is display text only; the runtime matches abilities by
`plain_name` or case-insensitively, so changing it is safe. `plain_name` is the
key and is never touched.
"""

from __future__ import annotations

from typing import Optional

# Lowercase everywhere except as the first word. "from" is included because the
# seeded names already write "Protection from Earth".
MINOR_WORDS = frozenset({"of", "the", "and", "a", "an", "in", "on", "to", "from"})

# Hand fixes that title-casing cannot derive, keyed by plain_name.
NAME_OVERRIDES = {
    "BIGBYS_CLENCHED_FIST": "Bigby's Clenched Fist",
    "DRAGONS_HEALTH": "Dragon's Health",
    "HEAVENS_GATE": "Heaven's Gate",
    "NATURES_EMBRACE": "Nature's Embrace",
    "NATURES_GUIDANCE": "Nature's Guidance",
    "SHADOWS_SORROW_SONG": "Shadow's Sorrow Song",
    # "Cause Critical" was already spelled out; the cure and vigorize rungs were not.
    "CURE_CRITIC": "Cure Critical",
    "VIGORIZE_CRITIC": "Vigorize Critical",
}


def title_case(name: str) -> str:
    """Title case with lowercase minor words (never the first word)."""
    words = []
    for index, word in enumerate(name.split(" ")):
        if index > 0 and word.lower() in MINOR_WORDS:
            words.append(word.lower())
            continue
        words.append("-".join(part[:1].upper() + part[1:].lower() for part in word.split("-")))
    return " ".join(words)


def normalize_ability_name(name: str, plain_name: Optional[str] = None) -> str:
    """The canonical display name for an ability."""
    if plain_name and plain_name in NAME_OVERRIDES:
        return NAME_OVERRIDES[plain_name]
    return title_case(name)
