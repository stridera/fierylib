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
-- require("name") loads data/script_libraries/<name>.lua once, with this environment's API
local libs = {}
env.require = function(name)
  if libs[name] == nil then libs[name] = assert(loadfile("@LIBDIR@/" .. name .. ".lua", "t", env))() end
  return libs[name]
end
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
""".replace("@LIBDIR@", str(ROOT / "data" / "script_libraries"))


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

# Druid 120:18 receiving a cup (val1 contents, val2 liquid) in room @ZONE@:@ROOM@.
DRUID_SETUP = """
local here = entity("room", {zone_id = @ZONE@, id = @ROOM@, local_id = @ROOM@})
env.self = entity("self", {name = "the druid", room = here})
env.actor = entity("actor", {name = "Tester", level = 20, class = "warrior", is_player = true},
  {get_quest_stage = function() return 1 end,
   get_quest_var = function(k) if k == "twisted_sorrow:num_trees" then return 0 end end})
env.object = entity("object", {shortdesc = "a cup", type = "DRINKCONTAINER", val1 = 3, val2 = @LIQUID@})
"""

# A WORLD trigger: `self` is the room the player searches in; the stored room is a legacy number.
SEARCH_SETUP = """
local here = entity("room", {zone_id = @ZONE@, id = @ROOM@, local_id = @ROOM@})
env.cmd = "search"
env.self = entity("self", {name = "a room", room = here})
env.actor = entity("actor", {name = "Tester", room = here},
  {get_quest_stage = function() return 6 end,
   get_quest_var = function(k) if k == "major_globe_spell:room" then return @STORED@ end end})
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
        env.self = entity("self", {zone_id = 2, id = 100, shortdesc = "a wand", room = room})
        env.victim = entity("victim", {zone_id = 185, id = 0, name = "Crafter"})
        env.actor = entity("actor", {is_player = true}, {get_quest_stage = function() return 1 end})
        """,
        must=["actor.send:Crafter tells you, 'This isn't yours!"],
    ),
    Scenario(
        "002_104 wrong element crafter 41:26 (fire) for an air wand",
        "002/002_104_phase_wands_give_owner_check.lua",
        """
        env.self = entity("self", {zone_id = 2, id = 100, shortdesc = "a wand", room = room})
        env.victim = entity("victim", {zone_id = 41, id = 26, name = "Crafter"})
        env.actor = entity("actor", {is_player = true}, {get_quest_stage = function() return 9 end})
        """,
        must=["precious"],
    ),
    Scenario(
        "002_104 ignores 186:0",
        "002/002_104_phase_wands_give_owner_check.lua",
        """
        env.self = entity("self", {zone_id = 2, id = 100, shortdesc = "a wand", room = room})
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
    # Handle vs number: DG compared %self.room% with a room vnum; `self.room` is a room handle.
    Scenario(
        "120_03 druid refuses in his home grove 120:15",
        "120/120_03_druid_receive.lua",
        DRUID_SETUP.replace("@ZONE@", "120").replace("@ROOM@", "15").replace("@LIQUID@", "0"),
        must=["Let us move to one of the mighty Rhells first, friend."],
        must_not=["peers into", "pours out"],
    ),
    Scenario(
        "120_03 druid accepts water at the Tree of Self-Reliance 120:18",
        "120/120_03_druid_receive.lua",
        DRUID_SETUP.replace("@ZONE@", "120").replace("@ROOM@", "18").replace("@LIQUID@", "0"),
        must=["A deep throbbing hum is emanating from the ground.",
              "actor.set_quest_var:twisted_sorrow|satisfied_tree:12018|1",
              "actor.set_quest_var:twisted_sorrow|num_trees|1"],
        must_not=["The tree is not responding", "Let us move"],
    ),
    Scenario(
        "120_03 druid rejects milk at the Tree of Self-Reliance",
        "120/120_03_druid_receive.lua",
        DRUID_SETUP.replace("@ZONE@", "120").replace("@ROOM@", "18").replace("@LIQUID@", "10"),
        must=["The tree is not responding."],
        must_not=["A deep throbbing hum"],
    ),
    Scenario(
        "120_03 druid accepts milk at the Tree of Kindness 120:46",
        "120/120_03_druid_receive.lua",
        DRUID_SETUP.replace("@ZONE@", "120").replace("@ROOM@", "46").replace("@LIQUID@", "10"),
        must=["A deep throbbing hum is emanating from the ground.",
              "satisfied_tree:12046|1"],
        must_not=["The tree is not responding"],
    ),
    Scenario(
        "120_03 a room 12018 in another zone is not the tree",
        "120/120_03_druid_receive.lua",
        DRUID_SETUP.replace("@ZONE@", "121").replace("@ROOM@", "18").replace("@LIQUID@", "0"),
        must=["The tree is not responding."],
    ),
    # Quest variables hold the legacy room number; the room handle is turned into it to compare.
    Scenario(
        "534_55 search finds the globe component in the stored room 169:3",
        "534/534_55_major_globe_command_search.lua",
        SEARCH_SETUP.replace("@ZONE@", "169").replace("@ROOM@", "3").replace("@STORED@", "16903"),
        must=["finds"],
    ),
    Scenario(
        "534_55 search finds nothing in another room",
        "534/534_55_major_globe_command_search.lua",
        SEARCH_SETUP.replace("@ZONE@", "169").replace("@ROOM@", "4").replace("@STORED@", "16903"),
        must_not=["finds"],
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
