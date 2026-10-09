"""Waist and belt are distinct wear positions (issue #92).

Legacy ITEM_WEAR_WAIST (bit 11) and ITEM_WEAR_OBELT (bit 20) import as the WearFlags WAIST and BELT, and
legacy WEAR_WAIST (13) / WEAR_OBELT (26) as the equipment slots WAIST and BELT.
"""

import re
from pathlib import Path

from fierylib.converters.flag_normalizer import normalize_flags
from fierylib.importers.player_importer import PlayerImporter
from mud.bitflags import BitFlags
from mud.flags import WEAR_FLAGS

SQL_PATH = Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-09-obelt-wear-slot.sql"
SQL = SQL_PATH.read_text(encoding="utf-8")
ROWS = re.findall(r"^\s+\((\d+), (\d+), (true|false), (true|false)\)", SQL, re.M)


def test_legacy_bits_are_distinct_wear_flags():
    assert BitFlags.build_flags(1 << 11, WEAR_FLAGS) == ["WAIST"]
    assert BitFlags.build_flags(1 << 20, WEAR_FLAGS) == ["BELT"]


def test_object_importer_keeps_waist_and_belt_apart():
    assert normalize_flags(["TAKE", "WAIST"]) == ["TAKE", "WAIST"]
    assert normalize_flags(["TAKE", "BELT"]) == ["TAKE", "BELT"]


def test_player_equipment_slots_are_distinct():
    importer = PlayerImporter.__new__(PlayerImporter)
    assert importer._location_to_slot(13) == "WAIST"
    assert importer._location_to_slot(26) == "BELT"


def test_patch_lists_every_waist_and_belt_object_once():
    keys = [(int(z), int(i)) for z, i, _, _ in ROWS]
    assert len(keys) == len(set(keys)) == 106
    assert sum(w == "true" for _, _, w, _ in ROWS) == 38
    assert sum(b == "true" for _, _, _, b in ROWS) == 68
    assert not any(w == "true" and b == "true" for _, _, w, b in ROWS)


def test_patch_is_keyed_by_composite_id_and_idempotent():
    assert 'WHERE o.zone_id = l.zone_id' in SQL
    assert "o.id = l.id" in SQL
    # only touches rows whose WAIST / BELT membership differs from legacy
    assert "<> l.has_waist" in SQL and "<> l.has_belt" in SQL
