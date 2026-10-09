"""Legacy ITEM_NOFALL imports as its own ObjectFlag, NO_FALL (it used to fold into FLOAT).

The runtime shows it as "(hovering)". Object hiddenness needs no import change: the legacy `H`
section already lands in Objects.concealment.
"""

import re
from pathlib import Path

from fierylib.converters.flag_normalizer import normalize_flags, process_object_flags

SQL_PATH = Path(__file__).resolve().parents[1] / "data" / "sql" / "2026-10-09-object-hiddenness-nofall.sql"
SQL = SQL_PATH.read_text(encoding="utf-8")
ROWS = re.findall(r"^\s+\((\d+), (\d+)\),?$", SQL, re.M)


def test_no_fall_survives_normalization_and_is_a_flag():
    assert normalize_flags(["FLOAT", "NO_FALL"]) == ["FLOAT", "NO_FALL"]
    processed = process_object_flags(normalize_flags(["GLOW", "FLOAT", "NO_FALL"]), [])
    assert processed.flags == ["GLOW", "FLOAT", "NO_FALL"]


def test_no_fall_is_not_folded_into_float():
    processed = process_object_flags(normalize_flags(["NO_FALL"]), [])
    assert processed.flags == ["NO_FALL"]


def test_patch_adds_the_enum_value_and_lists_each_object_once():
    assert "ADD VALUE IF NOT EXISTS 'NO_FALL'" in SQL
    keys = [(int(z), int(i)) for z, i in ROWS]
    assert len(keys) == len(set(keys)) == 79
    assert (4, 22) in keys and (1000, 33) in keys


def test_patch_is_idempotent_by_construction():
    assert "NOT ('NO_FALL'::\"ObjectFlag\" = ANY" in SQL
