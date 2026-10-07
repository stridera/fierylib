from fierylib.converters import normalize_flags
from fierylib.importers.player_importer import VALID_PLAYER_FLAGS
from mud.flags import PREFERENCE_FLAGS


def test_legacy_expand_bits_use_modern_names():
    # PRF_EXPAND_OBJS = 33, PRF_EXPAND_MOBS = 34 in legacy defines.hpp
    assert PREFERENCE_FLAGS[33] == "EXPAND_OBJS"
    assert PREFERENCE_FLAGS[34] == "EXPAND_MOBS"


def test_expand_flags_survive_player_import_filter():
    legacy = ["BRIEF", "EXPAND_OBJS", "EXPAND_MOBS", "SACRIFICIAL"]
    kept = [f for f in normalize_flags(legacy) if f in VALID_PLAYER_FLAGS]
    assert kept == ["BRIEF", "EXPAND_OBJS", "EXPAND_MOBS"]
