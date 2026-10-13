"""Behaviour of rewritten triggers under a Lua mock of the runtime (needs a lua5.4 binary, no DB).

The mock mirrors what mud-script exposes: actors, objects and rooms carry `.zone_id` and `.id`
(the local id); `.local_id` exists on rooms only. Each scenario feeds a composite entity to a
trigger that used to compare `.id` against a legacy 4-5 digit vnum, or used a branch-scoped
`local` after the chain, and checks which branch ran from what the script sent or commanded.
"""

import shutil
import subprocess
from dataclasses import dataclass, field
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
TRIGGERS = ROOT / "data" / "triggers"
LUA = shutil.which("lua5.4") or shutil.which("lua")

PRELUDE = r"""
local log = {}
local function fmt(...)
  local t = {}
  for i = 1, select("#", ...) do t[#t + 1] = tostring((select(i, ...))) end
  return table.concat(t, "|")
end
local function rec(label, ...) log[#log + 1] = label .. ":" .. fmt(...) end
-- Any method call is recorded and returns returns[method] (or calls it).
function entity(label, fields, returns)
  fields, returns = fields or {}, returns or {}
  return setmetatable(fields, { __index = function(_, k)
    return function(_, ...)
      rec(label .. "." .. k, ...)
      local r = returns[k]
      if type(r) == "function" then return r(...) end
      return r
    end
  end })
end
env = setmetatable({
  wait = function() end,
  random = function(a) return a or 1 end,
  get_room = function() return { name = "a room" } end,
  mobiles = { template = function(z, i) return { name = "mob " .. z .. ":" .. i } end },
  objects = { template = function(z, i) return { name = "obj " .. z .. ":" .. i } end },
  globals = {},
}, { __index = _G })
env.world = entity("world")
env.skills = entity("skills")
local room = entity("room")
function run(src)
  local fn, err = load(src, "trigger", "t", env)
  if not fn then error(err) end
  local ok, rv = pcall(fn)
  for _, l in ipairs(log) do print(l) end
  print("RESULT|" .. tostring(ok) .. "|" .. tostring(rv))
end
"""


@dataclass
class Scenario:
    id: str
    trigger: str
    setup: str
    must: list[str] = field(default_factory=list)
    must_not: list[str] = field(default_factory=list)


def run_trigger(src: str, setup: str) -> str:
    assert "]==]" not in src
    prog = PRELUDE + setup + "\nrun([==[\n" + src + "\n]==])\n"
    out = subprocess.run([LUA, "-"], input=prog, capture_output=True, text=True, timeout=30)
    assert out.returncode == 0, out.stderr
    return out.stdout


def trigger_src(rel: str) -> str:
    return (TRIGGERS / rel).read_text(encoding="utf-8")


QUEST_ACTOR = """
env.self = entity("self", {name = "Isilynor", zone_id = 30, id = 83, room = room}, {})
env.actor = entity("actor", {name = "Tester", level = 60, class = "warrior", is_player = true},
  {get_quest_stage = function() return "stage" end, get_quest_var = function() return "dead" end})
"""

SCENARIOS = [
    # P1 + P2: object 3080 is now (30, 80); stage/go are assigned in the branch and read after it.
    Scenario(
        "030_83 reward for 30:80",
        "030/030_83_dragon_slayer_isilynor_receive.lua",
        QUEST_ACTOR + 'env.object = entity("object", {zone_id = 30, id = 80, shortdesc = "a hedge"})',
        must=["self.command:give 10 platinum", "Congratulations"],
        must_not=["What is this for"],
    ),
    Scenario(
        "030_83 refuses 31:80 (same local id, other zone)",
        "030/030_83_dragon_slayer_isilynor_receive.lua",
        QUEST_ACTOR + 'env.object = entity("object", {zone_id = 31, id = 80, shortdesc = "a hedge"})',
        must=["What is this for"],
        must_not=["give 10 platinum"],
    ),
    Scenario(
        "053_13 reward for 53:0",
        "053/053_13_beast_master_ranger_trophy_receive.lua",
        QUEST_ACTOR + 'env.object = entity("object", {zone_id = 53, id = 0, shortdesc = "a slime"})',
        must=["self.command:give 10 platinum"],
        must_not=["What is this for"],
    ),
    Scenario(
        "053_13 trophy 16:7 picks the trophy branch",
        "053/053_13_beast_master_ranger_trophy_receive.lua",
        QUEST_ACTOR + 'env.object = entity("object", {zone_id = 16, id = 7, shortdesc = "a trophy"})',
        must_not=["What is this for"],
    ),
    # P2: victim 18500 is 185:0, the air crafter for wand step 3; the actor is only at step 1.
    Scenario(
        "002_104 refuses a premature give to 185:0",
        "002/002_104_phase_wands_give_owner_check.lua",
        """
        env.self = entity("self", {zone_id = 2, id = 300, shortdesc = "a wand", room = room})
        env.victim = entity("victim", {zone_id = 185, id = 0, name = "Crafter"})
        env.actor = entity("actor", {is_player = true}, {get_quest_stage = function() return 1 end})
        """,
        must=["actor.send:Crafter tells you, 'This isn't yours!"],
    ),
    Scenario(
        "002_104 wrong element crafter 41:26 (fire) for an air wand",
        "002/002_104_phase_wands_give_owner_check.lua",
        """
        env.self = entity("self", {zone_id = 2, id = 300, shortdesc = "a wand", room = room})
        env.victim = entity("victim", {zone_id = 41, id = 26, name = "Crafter"})
        env.actor = entity("actor", {is_player = true}, {get_quest_stage = function() return 9 end})
        """,
        must=["precious"],
    ),
    Scenario(
        "002_104 ignores 186:0",
        "002/002_104_phase_wands_give_owner_check.lua",
        """
        env.self = entity("self", {zone_id = 2, id = 300, shortdesc = "a wand", room = room})
        env.victim = entity("victim", {zone_id = 186, id = 0, name = "Crafter"})
        env.actor = entity("actor", {is_player = true}, {get_quest_stage = function() return 1 end})
        """,
        must_not=["precious", "This isn't yours"],
    ),
    # P2: 53:31 accepts a list of items, 55585 is 555:85 and 58801 is 588:1.
    Scenario(
        "053_31 accepts 588:1",
        "053/053_31_honus_receive_refuse.lua",
        """
        env.self = entity("self", {name = "Honus", room = room})
        env.actor = entity("actor", {}, {get_quest_stage = function() return 1 end})
        env.object = entity("object", {zone_id = 588, id = 1, shortdesc = "an item"})
        """,
        must_not=["refuses"],
    ),
    Scenario(
        "053_31 refuses 588:2",
        "053/053_31_honus_receive_refuse.lua",
        """
        env.self = entity("self", {name = "Honus", room = room})
        env.actor = entity("actor", {}, {get_quest_stage = function() return 1 end})
        env.object = entity("object", {zone_id = 588, id = 2, shortdesc = "an item"})
        """,
        must=["refuses an item"],
    ),
    # P1 only: `task`, `item1` and friends were declared inside the stage branches.
    Scenario(
        "004_31 journal shows the stage task",
        "004/004_31_the_great_rite_progress_journal.lua",
        """
        env.arg = "megalith"
        env.self = entity("self", {})
        env.actor = entity("actor", {level = 60},
          {get_quest_stage = function() return 1 end, get_has_completed = function() return false end,
           get_has_failed = function() return false end, get_quest_var = function() return nil end})
        """,
        must=["Replace the sacred prophetic implements.", "salt"],
        must_not=["actor.send:nil"],
    ),
    # P1 only: `hint` and `place` were branch locals in the monk vision section.
    Scenario(
        "053_43 hakujo hint for vision stage 1",
        "053/053_43_elemental_chaos_hakujo_progress_checker.lua",
        """
        env.speech = "progress"
        env.self = entity("self", {name = "Hakujo"})
        env.actor = entity("actor", {class = "monk", level = 60},
          {get_has_completed = function() return false end,
           get_quest_stage = function(q) if q == "monk_vision" then return 1 end return 5 end,
           get_quest_var = function(k) if k == "monk_vision:attack_counter" then return 0 end end})
        """,
        must=["in a place to perform."],
        must_not=["is nil"],
    ),
]


@pytest.mark.skipif(LUA is None, reason="no lua interpreter")
@pytest.mark.parametrize("sc", SCENARIOS, ids=lambda s: s.id)
def test_rewritten_trigger_takes_the_right_branch(sc):
    out = run_trigger(trigger_src(sc.trigger), sc.setup)
    # Some of these scripts fail later on unrelated converter leftovers (e.g. an unset `person`),
    # which is out of scope here; only the branch taken is asserted.
    assert "RESULT|" in out, out
    for needle in sc.must:
        assert needle in out, f"{needle!r} missing from:\n{out}"
    for needle in sc.must_not:
        assert needle not in out, f"{needle!r} unexpectedly present in:\n{out}"
