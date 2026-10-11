"""53:46 Elemental Chaos target death: composite ids, no legacy vnums, no branch-scoped locals (no DB)."""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LUA = ROOT / "data" / "triggers" / "053" / "053_46_elemental_chaos_target_death.lua"

# Legacy vnums switched on by DG #5346 (lib/world/trg/53.trg), in stage order.
LEGACY_VNUMS = [58808, 4399, 17306, 17811, 46206, 46207, 46208, 12523, 8509, 43017, 53417, 4009]


def _targets(lua: str):
    return [
        tuple(int(x) for x in m)
        for m in re.findall(r"zone = (\d+), +id = (\d+), +stage = (\d+), +slot = (\d+)", lua)
    ]


def test_targets_are_the_legacy_mobs_as_composite_ids():
    lua = LUA.read_text(encoding="utf-8")
    targets = _targets(lua)
    # All twelve ids sit inside their zone's 100-vnum block, so vnum == zone * 100 + id.
    assert [z * 100 + i for z, i, _, _ in targets] == LEGACY_VNUMS
    assert [s for _, _, s, _ in targets] == [1, 2, 3, 4, 5, 5, 5, 6, 7, 8, 9, 10]
    # Only the three Fangs (stage 5) use slots 2 and 3.
    assert [(s, sl) for _, _, s, sl in targets if s == 5] == [(5, 1), (5, 2), (5, 3)]


def test_no_vnums_and_no_branch_scoped_locals():
    lua = LUA.read_text(encoding="utf-8")
    assert "self.zone_id" in lua and "self.local_id" in lua
    assert "self.id" not in lua and ".vnum" not in lua
    assert "Status: CLEAN" in lua and "TODO(parity)" not in lua
    # Locals appear only at top level or in the loop; quest stage is compared as a number.
    assert 'get_quest_stage("elemental_chaos") == entry.stage' in lua
    assert '== "stage"' not in lua


def test_patch_is_guarded_and_idempotent_shape():
    sql = (ROOT / "data" / "sql" / "2026-10-11-elemental-chaos-death-trigger.sql").read_text(encoding="utf-8")
    assert "(53, 46," in sql
    assert "md5(t.commands) = v.old_md5" in sql
    assert "t.commands IS DISTINCT FROM v.commands" in sql
