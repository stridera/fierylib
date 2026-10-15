"""Race start rooms (fierymud-rs #156): races.json <-> SQL patch, and no race starts in a known-bad room."""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RACES_JSON = ROOT / "data" / "races.json"
SQL = (ROOT / "data" / "sql" / "2026-10-14-race-start-rooms.sql").read_text(encoding="utf-8")

DEFAULT_START = (30, 1)  # legacy mortal_start_room 3001
# Race -> the start room it used to have: airborne (Doom) or dark around the clock.
BAD_ROOMS = {
    "dragonborn_lightning": (488, 60),
    "dragonborn_fire": (52, 72),
    "dragonborn_frost": (533, 88),
    "dragonborn_gas": (54, 72),
    "sverfneblin": (54, 2),
    "duergar": (133, 1),
    "drow": (237, 22),
}


def _races():
    return {r["name"]: r for r in json.loads(RACES_JSON.read_text(encoding="utf-8"))["races"]}


def _sql_rows():
    return {
        m.group(1).lower(): (int(m.group(2)), int(m.group(3)))
        for m in re.finditer(r"\('([A-Z_]+)', (\d+), (\d+)\)", SQL)
    }


def test_sql_patch_lists_exactly_the_old_bad_rooms():
    assert _sql_rows() == BAD_ROOMS


def test_races_json_moves_those_races_to_the_default_start():
    races = _races()
    for name in BAD_ROOMS:
        got = (races[name]["startRoomZoneId"], races[name]["startRoomId"])
        assert got == DEFAULT_START, name


def test_no_playable_race_still_starts_in_a_bad_room():
    bad = set(BAD_ROOMS.values())
    for name, race in _races().items():
        if race.get("playable"):
            key = (race.get("startRoomZoneId"), race.get("startRoomId"))
            assert key not in bad, name
            assert None not in key, f"{name} has no start room"


def test_sql_patch_is_guarded_and_never_widens():
    assert "r.start_room_zone_id = v.zone_id" in SQL
    assert "r.start_room_id = v.room_id" in SQL
    assert "EXISTS" in SQL
