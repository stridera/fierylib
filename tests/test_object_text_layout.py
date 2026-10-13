"""Object extra descriptions keep their line breaks and indentation (playtest r10 #33)."""

from mud.mudfile import MudData
from mud.types.object import Object

MAP = """#3090
map small-map~
a small map~
An old roll of paper lies here.~
~
12 0 1 1
0 0 0 0 0 0 0
0.20 50 0 0 0 0 0 0
E
map mielikki~
        Mielikki, by Kara-Sithri
\t
   &3#&0   |  1: Temple
~
$
"""


def _parse():
    (obj,) = Object.parse(MudData(MAP.split("\n")))
    return obj


def test_extra_description_keeps_lines_blank_lines_and_indentation():
    (extra,) = _parse().extras
    assert extra.keywords == ["map", "mielikki"]
    assert extra.text == "        Mielikki, by Kara-Sithri\n\n   &3#&0   |  1: Temple"


def test_other_strings_are_still_folded_onto_one_line():
    obj = _parse()
    assert obj.short == "a small map"
    assert obj.ground == "An old roll of paper lies here."


def test_read_text_stops_at_a_tilde_ending_the_last_line():
    data = MudData(["first", "second~", "after"])
    assert data.read_text() == "first\nsecond"
    assert data.get_next_line() == "after"
