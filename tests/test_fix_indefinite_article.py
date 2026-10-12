"""Legacy short descriptions with the wrong a/an (playtest round 5, N17)."""

import pytest

from fierylib.converters import fix_indefinite_article


@pytest.mark.parametrize(
    "before, after",
    [
        ("a aqua scroll of world teleport", "an aqua scroll of world teleport"),
        ("a onyx-headed cane", "an onyx-headed cane"),
        ("a apatite key", "an apatite key"),
        ("an neon blue potion", "a neon blue potion"),
        ("an radiant sapphire", "a radiant sapphire"),
        ("A aqua scroll", "An aqua scroll"),
        # Colour tags between the article and the word are kept.
        ("a <green>emerald </>brooch", "an <green>emerald </>brooch"),
        ("an <yellow>ancient</> <red>grimoire</>", "an <yellow>ancient</> <red>grimoire</>"),
    ],
)
def test_wrong_article_is_corrected(before, after):
    assert fix_indefinite_article(before) == after


@pytest.mark.parametrize(
    "name",
    [
        "a steel sword",
        "an iron helm",
        "an herbal salve",  # silent h: left as authored
        "a hat",
        "an hour glass",
        "a unicorn horn",  # u is ambiguous: left as authored
        "an umbrella",
        "a one-handed axe",
        "a european coat",
        "the aqua scroll",
        "some aqua beads",
        'an "I Died for Pergus" t-shirt',
        "",
    ],
)
def test_correct_or_ambiguous_names_are_left_alone(name):
    assert fix_indefinite_article(name) == name
