"""Playtest r14: Academy sign layout (B4) and the Master of the Revel as banker (B2)."""

from fierylib.importers.mob_importer import detect_special_mob_flags
from mud.mudfile import MudData
from mud.types.world import World

ROOM = """#51902
Combat Registrar's Office~
   A huge desk dominates the room.~
519 34079240 0
E
large-directory-sign~
North - Academy Arena
East - The Chapel
Down - Stealth Studies Classroom~
S
$
"""


def test_room_extra_description_keeps_its_line_breaks():
    (room,) = World.parse(MudData(ROOM.split("\n")))
    (extra,) = room["extras"]
    assert extra.keywords == ["large-directory-sign"]
    assert extra.text == "North - Academy Arena\nEast - The Chapel\nDown - Stealth Studies Classroom"
    assert room["description"] == "A huge desk dominates the room."  # other strings still fold


def test_revel_is_a_banker_but_other_mobs_keep_their_flags():
    assert "BANKER" in detect_special_mob_flags("the Master of the Revel", "master-revel", [], vnum=51908)
    assert "BANKER" not in detect_special_mob_flags("the Master of the Revel", "master-revel", [])
    assert "BANKER" not in detect_special_mob_flags("the Warmaster", "warmaster", [], vnum=51904)
    assert "BANKER" in detect_special_mob_flags("a dwarven banker", "banker", [], vnum=6230)
