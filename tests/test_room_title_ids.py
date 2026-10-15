"""Playtest r12 F14: zone 80 room titles leaked the builder's room number."""

from fierylib.importers.room_importer import strip_builder_id_suffix


def test_strips_trailing_own_id():
    assert strip_builder_id_suffix("Carrot Top Heaven (102)", 102) == "Carrot Top Heaven"
    assert strip_builder_id_suffix("The Clover Field (108)  ", 108) == "The Clover Field"


def test_keeps_numbers_that_are_not_the_room_id():
    assert strip_builder_id_suffix("The Great Hall (1998)", 12) == "The Great Hall (1998)"
    assert strip_builder_id_suffix("Storeroom (W)", 226) == "Storeroom (W)"
    assert strip_builder_id_suffix("Room 26", 26) == "Room 26"
