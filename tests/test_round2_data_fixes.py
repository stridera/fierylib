"""Playtest 2026-10-11 round 2 data fixes (no DB): container keys, patches, rescue text, trigger."""

import json
import re
from pathlib import Path

from fierylib.converters.dg_to_lua import build_zone_ranges
from fierylib.importers.object_importer import composite_container_key

ROOT = Path(__file__).resolve().parents[1]
SQL = ROOT / "data" / "sql"
RANGES = [(3000, 3499, 30), (2300, 2799, 23), (0, 99, 0)]


def _sql(name: str) -> str:
    return (SQL / name).read_text(encoding="utf-8")


def test_container_key_resolves_through_zone_ranges():
    assert composite_container_key(2302, RANGES) == {"zone": 23, "id": 2}
    # zone 30 spans 3000-3499: 3123 is 30:123, not 31:23
    assert composite_container_key(3123, RANGES) == {"zone": 30, "id": 123}
    assert composite_container_key(51, RANGES) == {"zone": 0, "id": 51}


def test_container_key_unset_values_stay_unset():
    for raw in (0, -1, None, "", "x"):
        assert composite_container_key(raw, RANGES) is None


def test_container_key_outside_ranges_falls_back_to_division():
    assert composite_container_key(7911, RANGES) == {"zone": 79, "id": 11}
    assert composite_container_key(7911, []) == {"zone": 79, "id": 11}


def test_container_key_patch_matches_importer_and_is_guarded():
    zon = next((p / "lib" / "world" / "zon" for p in ROOT.parents if (p / "lib" / "world" / "zon").is_dir()), ROOT)
    sql = _sql("2026-10-11-container-key-composite.sql")
    pairs = re.findall(r"^\s+\((\d+), (\d+), (\d+)\)[,;]$", sql, re.M)
    assert len(pairs) == 34
    if zon != ROOT:  # the shared lib/ is not inside every checkout
        ranges = build_zone_ranges(zon)
        for legacy, zone, local in pairs:
            assert composite_container_key(int(legacy), ranges) == {"zone": int(zone), "id": int(local)}
    assert sql.count("jsonb_typeof") >= 2  # only rows whose Key is still a number are touched
    assert '"CharacterItems"' in sql


def test_exit_description_patch_only_touches_empty_strings():
    sql = _sql("2026-10-11-exit-description-null.sql")
    assert "SET description = NULL WHERE description = ''" in sql


def test_board_text_patch_names_real_commands_and_is_guarded():
    sql = _sql("2026-10-11-board-text.sql")
    assert "write board" in sql.split("WHERE", 1)[1]  # the guard holds the old text
    new = sql.split("SET", 1)[1].split("WHERE", 1)[0]
    assert "write board" not in new and "remove <" not in new
    for verb in ('"look board"', '"read 3"', '"post"', '"delpost mortal 3"'):
        assert verb in new


def test_rescue_messages_match_between_json_and_patch():
    abilities = json.loads((ROOT / "data" / "abilities.json").read_text(encoding="utf-8"))
    items = abilities if isinstance(abilities, list) else abilities["abilities"]
    msgs = next(a for a in items if a["name"] == "Rescue")["messages"]
    assert msgs["successToCaster"] == "Banzai! To the rescue..."
    assert msgs["failToCaster"] == "You fail the rescue!"
    assert "uses rescue" not in json.dumps(msgs)
    sql = _sql("2026-10-11-rescue-messages.sql")
    for text in (msgs["successToCaster"], msgs["successToVictim"], msgs["successToRoom"], msgs["failToCaster"]):
        assert text in sql
    assert "m.success_to_caster = 'You use rescue on {target.name}!'" in sql  # guard


def test_beast_master_trigger_uses_composite_ids_and_no_vnums():
    lua = (ROOT / "data" / "triggers" / "053" / "053_14_beast_master_creature_death.lua").read_text(encoding="utf-8")
    assert "self.zone_id" in lua and "self.local_id" in lua
    assert "self.id" not in lua
    assert "Status: CLEAN" in lua
    assert len(re.findall(r"zone = \d+, +id = \d+", lua)) == 10
    sql = _sql("2026-10-11-beast-master-death-trigger.sql")
    assert "(53, 14," in sql and "md5" in sql
