"""Playtest round 9 trigger fixes (data/triggers): quest-stage truthiness, trainers, 557, 30:40, 123:12, 324."""

import re
import shutil
import subprocess
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
TRIG = ROOT / "data" / "triggers"
LUA = shutil.which("lua5.4") or shutil.which("lua")


def body(zone, ident):
    (path,) = sorted((TRIG / f"{zone:03d}").glob(f"{zone:03d}_{ident:02d}_*.lua"))
    return path.read_text(encoding="utf-8")


def code_lines(text):
    return [l for l in text.splitlines() if not l.lstrip().startswith("--")]


def test_no_bare_truthiness_tests_on_get_quest_stage_remain():
    bad = []
    for path in TRIG.rglob("*.lua"):
        for n, line in enumerate(code_lines(path.read_text(encoding="utf-8")), 1):
            if re.search(r"\bnot\s+\w+:get_quest_stage\([^()]*\)\s*(?:then|and|or|\))", line) or re.search(
                r"\b(?:if|elseif)\s+\w+:get_quest_stage\([^()]*\)\s*(?:then|and\b)", line
            ):
                bad.append(f"{path.relative_to(TRIG)}:{n}")
    assert not bad, bad[:10]


def test_isilynor_not_started_branch_compares_to_zero():
    src = body(30, 81)
    assert 'actor:get_quest_stage("dragon_slayer") == 0 and actor.level >= 5' in src


def test_trainers_use_the_proficiency_number_not_the_boolean():
    for ident in (160, 165, 170):
        src = body(30, ident)
        assert "has_skill" not in src
        assert "get_skill(" in src
        assert "10 * skill" not in src
        assert 'set_quest_var("trainer_31' in src and '"max_skill", maxskill' in src
        # whole-copper price, integer coin split
        assert "math.floor(change * opinion" in src and "price // 1000" in src
    for ident in (161, 166, 171):
        assert ":max_skill\") or 1000)" in body(30, ident)


def test_erasmus_charm_person_mastery_is_a_proficiency_comparison():
    src = body(30, 9)
    assert "has_skill" not in src and src.count('get_skill("charm person") >= 1000') == 2


def test_557_inits_persist_and_readers_load_the_mob_variables():
    init_dir = sorted((TRIG / "557").glob("557_[123]?_*.lua"))
    inits = [p for p in init_dir if int(p.name[4:6]) >= 10]
    assert len(inits) == 30
    for p in inits:
        text = p.read_text(encoding="utf-8")
        assert "globals." not in text
        assert 'self:setvar("classes", classes)' in text and 'self:setvar("phase", phase)' in text
        assert text.count("self:setvar(") == 30
    for ident in range(0, 6):
        src = body(557, ident)
        assert 'local classes = self:getvar("classes")' in src and 'local phase = self:getvar("phase")' in src
        assert "classes == nil or phase == nil" in src
    # speech gates: legacy word lists / phrase, so the scripts no longer run on every utterance
    assert '{"where"}' in body(557, 5)
    assert '"armor progress"' in body(557, 4)
    assert '"yes", "quests", "quest", "hello", "hi"' in body(557, 1)


def test_557_where_gate_and_globals_run_in_lua():
    if LUA is None:
        pytest.skip("no lua")
    src = body(557, 5)
    harness = f"""
local sent = {{}}
local vars = {{classes = "Sorcerer, Cryomancer", phase = 1}}
local self = {{name = "the Archmage", getvar = function(_, k) return vars[k] end, say = function() end, command = function() end}}
local actor = {{can_be_seen = true, class = "sorcerer", level = 10, send = function(_, m) sent[#sent+1] = m end,
  get_quest_stage = function() return 0 end}}
wait = function() end
local function run(speech)
  sent = {{}}
  local f = assert(load(SRC, "t", "t", setmetatable({{speech = speech, self = self, actor = actor, wait = wait}}, {{__index = _G}})))
  f()
  return #sent
end
assert(run("hello there") == 0, "no 'where': silent")
assert(run("where do I find it") == 3, "where: three lines")
vars.classes = nil
assert(run("where") == 0, "init not run: silent, no error")
print("ok")
"""
    prog = harness.replace("SRC", "[=====[" + src + "]=====]", 1)
    out = subprocess.run([LUA, "-e", prog], capture_output=True, text=True)
    assert out.returncode == 0 and out.stdout.strip() == "ok", out.stderr


def test_blob_to_pawnbroker_looks_everything_up_before_moving_and_always_comes_home():
    src = body(30, 40)
    head, tail = src.split("local broker = world.find_mobile(60, 16)", 1)
    assert "teleport" not in "\n".join(code_lines(head))
    assert "if not broker or not back_room or not shop or not dest then" in tail
    assert tail.index("return true") < tail.index("pcall(")
    assert tail.index("broker:teleport(shop)") > tail.index("end)")
    assert "find_actor" not in src


def test_megalith_progress_reads_retrieved_items_as_one_not_as_present():
    src = body(123, 12)
    assert "local function have(n)" in src and '== 1' in src
    assert "~= 1 or actor:get_quest_var" not in src  # the old inverted 'already retrieved' header
    assert "self_name" in src and "self.name:sub(1, 1):upper()" in src
    for ident in (0, 6, 15):
        text = body(123, ident)
        assert re.search(r'get_quest_var\("megalith_quest:item[1-4]"\)\)? and', text) is None
    assert 'get_quest_var("megalith_quest:" .. item_key) == 1' in body(123, 6)


def test_megalith_progress_runs_for_a_fresh_quester():
    if LUA is None:
        pytest.skip("no lua")
    src = body(123, 12)
    harness = """
local out = {}
local vars = {}
local self = {name = "the witch priestess", say = function() end}
self.room = {send = function(_, m) out[#out+1] = m end}
local actor = {
  send = function(_, m) out[#out+1] = m end,
  get_quest_stage = function() return 1 end,
  get_has_completed = function() return false end, get_has_failed = function() return false end,
  get_quest_var = function(_, k) return vars[k] end,
}
mobiles = {template = function() return {name = "x"} end}
objects = {template = function() return {name = "y"} end}
wait = function() end
local env = setmetatable({speech = "progress", self = self, actor = actor}, {__index = _G})
assert(load(SRC, "t", "t", env))()
local text = table.concat(out, "\\n")
assert(not text:find("already retrieved"), text)
assert(text:find("We still need"), text)
for _, w in ipairs({"salt", "goblet", "censer", "candles"}) do assert(text:find(w), w) end
assert(text:find("The witch priestess says, 'Please bring"), text)
-- once the salt is handed over it moves from "still need" to "retrieved"
out = {}
vars["megalith_quest:item1"] = 1
assert(load(SRC, "t", "t", env))()
text = table.concat(out, "\\n")
local retrieved, need = text:match("already retrieved:(.-)We still need:(.*)")
assert(retrieved and retrieved:find("salt") and not retrieved:find("censer"), text)
assert(not need:find("salt") and need:find("censer"), text)
print("ok")
"""
    prog = harness.replace("SRC", "[=====[" + src + "]=====]")
    out = subprocess.run([LUA, "-e", prog], capture_output=True, text=True)
    assert out.returncode == 0 and out.stdout.strip() == "ok", out.stderr


def test_horse_ride_hands_over_the_item_and_skips_rooms_the_world_lacks():
    assert "self:spawn_object(324, 21)" in body(324, 14) and "room:spawn_object(324, 21)" not in body(324, 14)
    assert "self:spawn_object(324, 25)" in body(324, 13) and "room:spawn_object(324, 25)" not in body(324, 13)
    for ident in (8, 19):
        src = body(324, ident)
        assert "local function ride_to(zone, id)" in src
        assert "actor:teleport(get_room(" not in src and "self:teleport(get_room(" not in src
        assert src.rstrip().endswith("world.destroy(self)")
    # the Mugnork bribe refuses (and refunds) while its destination room is missing
    assert "if not get_room(324, 165) then" in body(324, 13)


@pytest.mark.parametrize("ident,word,skill_name", [(160, "backstab", "backstab"), (165, "bash", "bash"), (170, "chant", "chant")])
def test_paid_trainer_quotes_a_whole_coin_price_from_the_proficiency(ident, word, skill_name):
    if LUA is None:
        pytest.skip("no lua")
    src = body(30, ident)
    harness = f"""
local said, vars, asked = {{}}, {{}}, {{}}
local self = {{name = "the trainer"}}
self.say = function(_, m) said[#said+1] = m end
self.command = function() end
self.room = {{send = function(_, m) said[#said+1] = m end}}
local actor = {{name = "Bob", level = 50, class = "thief", race = "human", real_cha = 60, real_int = 60}}
actor.get_quest_stage = function() return 0 end
actor.start_quest = function() end
actor.erase_quest = function() end
actor.set_quest_var = function(_, q, k, v) vars[k] = v end
actor.get_skill = function(_, n) asked[#asked+1] = n return 400 end
wait = function() end
local env = setmetatable({{speech = "{word}", self = self, actor = actor, wait = wait}}, {{__index = _G}})
assert(load(SRC, "t", "t", env))()
local text = table.concat(said, "\\n")
assert(asked[1] == "{skill_name}", tostring(asked[1]))
assert(text:find("teach you {word} for %d+ platinum, %d+ gold, %d+ silver, %d+ copper"), text)
assert(math.type(vars.price) == "integer" and vars.price > 0, tostring(vars.price))
assert(vars.skill_level == 400 and vars.max_skill == 560, tostring(vars.skill_level) .. " " .. tostring(vars.max_skill))
print("ok")
"""
    out = subprocess.run([LUA, "-e", harness.replace("SRC", "[=====[" + src + "]=====]")], capture_output=True, text=True)
    assert out.returncode == 0 and out.stdout.strip() == "ok", out.stderr + out.stdout
