"""Soak-test trigger fixes: 510:6 non_clerics_out and 30:180 load random gems (no DB)."""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TRIG = ROOT / "data" / "triggers"
NON_CLERICS = TRIG / "510" / "510_06_non_clerics_out.lua"
GEMS = TRIG / "030" / "030_180_load_random_gems.lua"


def test_non_clerics_out_reads_occupants_from_the_room():
    # `self` in a room trigger is a plain actor handle: `actors` / `actor_count`
    # / `send_except` exist only on its LuaRoom (`self.room`). Reading them off
    # `self` gave nil and `random(1, nil)` raised every 13 s.
    lua = NON_CLERICS.read_text(encoding="utf-8")
    assert not re.search(r"\bself[.:](actor_count|actors|people|send_except)", lua)
    assert "room.actor_count" in lua and "room.actors[" in lua
    assert "room:send_except(rnd" in lua
    # Guard comes before the random pick.
    assert lua.index("room.actor_count == 0") < lua.index("random(1, room.actor_count)")


def test_load_random_gems_uses_composite_has_equipped():
    # has_equipped takes (zone, id); the DG vnum string left the id nil.
    lua = GEMS.read_text(encoding="utf-8")
    assert "self:has_equipped(187, 1)" in lua
    assert 'has_equipped("18701")' not in lua


def test_patch_sql_is_md5_guarded_and_covers_both_rows():
    sql = (ROOT / "data" / "sql" / "2026-10-12-soak-trigger-fixes.sql").read_text(encoding="utf-8")
    assert "md5(t.commands) = v.old_md5" in sql
    assert "(510, 6," in sql and "(30, 180," in sql
    assert "room.actor_count" in sql and "has_equipped(187, 1)" in sql
