"""Race display names keep their legacy colours (fierymud-rs #159): races.json <-> SQL patch."""

import json
import re
from pathlib import Path

from fierylib.converters.color_converter import convert_legacy_colors, strip_markup

ROOT = Path(__file__).resolve().parents[1]
RACES = json.loads((ROOT / "data" / "races.json").read_text(encoding="utf-8"))["races"]
SQL = (ROOT / "data" / "sql" / "2026-10-14-race-colour-names.sql").read_text(encoding="utf-8")


def _enum(name: str) -> str:
    return {"halfelf": "HALF_ELF"}.get(name, name.upper())


def _sql_rows():
    return {
        m.group(1): (m.group(2).replace("''", "'"), m.group(3).replace("''", "'"))
        for m in re.finditer(r"\('([A-Z_]+)', '((?:[^']|'')*)', '((?:[^']|'')*)'\)", SQL)
    }


def test_sql_rows_match_races_json():
    rows = _sql_rows()
    assert set(rows) == {_enum(r["name"]) for r in RACES}
    for r in RACES:
        plain, coloured = rows[_enum(r["name"])]
        assert coloured == r["displayName"], r["name"]
        assert plain == strip_markup(r["displayName"]), r["name"]


def test_dragonborn_are_one_word_told_apart_by_colour():
    dragonborn = [r for r in RACES if r["name"].startswith("dragonborn_")]
    assert len(dragonborn) == 5
    assert {strip_markup(r["displayName"]) for r in dragonborn} == {"Dragonborn"}
    assert len({r["displayName"] for r in dragonborn}) == 5, "each subrace has its own colours"


def test_legacy_codes_become_markup():
    # races.cpp, Fire Dragonborn: &1Dr&ba&3g&1on&0&1b&1&bo&3r&1&bn&0
    got = convert_legacy_colors("&1Dr&ba&3g&1on&0&1b&1&bo&3r&1&bn&0")
    assert strip_markup(got) == "Dragonborn"
    assert "<b:yellow>g</>" in got


def test_sql_patch_only_touches_names_that_are_still_plain():
    assert "AND r.name = v.plain" in SQL
