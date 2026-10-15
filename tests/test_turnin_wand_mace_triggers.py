"""Behaviour of the hand-rebuilt quest triggers, run against a small mock of the trigger API.

Covers the Black Legion / Eldorian Guard turn-ins (041_03, 041_07, 055_03, 055_07), the Major Globe
journal (004_19) and the phase wand / mace questmasters (002_108, 002_114, 002_126). The mock keeps
quest variables the way the engine does (case-sensitive "quest:key" strings, numbers stay numbers),
records everything the script sends, spawns, destroys and commands, and dumps the final quest state.
"""

import re
import shutil
import subprocess
from pathlib import Path

import pytest

LUA = shutil.which("lua5.4") or shutil.which("lua")
needs_lua = pytest.mark.skipif(LUA is None, reason="lua not installed")

TRIGGERS = Path(__file__).resolve().parent.parent / "data" / "triggers"
LIBRARIES = Path(__file__).resolve().parent.parent / "data" / "script_libraries"

PREAMBLE = r"""
local log = {}
local function L(s) log[#log + 1] = s end
local qv, qstage, qdone = {}, {}, {}
local function key(a, b) if b == nil then return a end return a .. ":" .. b end

local actor = {name = "Hero", alignment = 0, level = 50, class = "cleric", is_player = true}
function actor:get_quest_var(k) return qv[k] end
function actor:set_quest_var(a, b, c)
    if c == nil then qv[a] = b else qv[key(a, b)] = c end
end
function actor:get_quest_stage(q) return qstage[q] or 0 end
function actor:start_quest(q) qstage[q] = 1 end
function actor:advance_quest(q) qstage[q] = (qstage[q] or 0) + 1 end
function actor:get_has_completed(q) return qdone[q] == true end
function actor:send(m) L("A|" .. m) end
function actor:award_exp(n) L("exp|" .. n) end
function actor:save() L("save") end
function actor:has_item() return false end
function actor:has_equipped() return false end
actor.race = "human"

local self = {name = "Mob", zone_id = 1, id = 1, room = {}}
function self.room:send(m) L("R|" .. m) end
function self:say(m) L("say|" .. m) end
function self:emote(m) L("emote|" .. m) end
function self:command(m) L("cmd|" .. m) end
function self:spawn_object(z, i)
    L("spawn|" .. z .. "|" .. i)
    return {zone_id = z, id = i, name = "OBJ[" .. z .. "," .. i .. "]", alias = "item" .. z .. "_" .. i}
end
function self:destroy_item(n) L("junk|" .. n) end
function self:set_flag(n, v) L("flag|" .. n .. "|" .. tostring(v)) end

local object = {zone_id = 1, id = 1, name = "a thing", shortdesc = "a thing", alias = "thing"}
local globals = {}
local speech, arg = "", ""

local env, libs = nil, {}
local api = {
    wait = function() end,
    random = function(_, b) return b end,
    spells = {cast = function(_, name) L("cast|" .. tostring(name)) end},
    world = {destroy = function(o) L("destroy|" .. tostring(o and o.name)) end},
    objects = {template = function(z, i) return {name = "OBJ[" .. z .. "," .. i .. "]"} end},
    mobiles = {template = function(z, i) return {name = "MOB[" .. z .. "," .. i .. "]"} end},
    get_room = function(z, i) return {name = "ROOM[" .. z .. "," .. i .. "]"} end,
    get_obj_noadesc = function(z, i) return "noa[" .. z .. "," .. i .. "]" end,
}
-- require("name") loads data/script_libraries/<name>.lua once, with the API but none of the firing
-- context (no actor / self / object), the way the engine's library loader does.
local libenv = setmetatable({}, {__index = setmetatable(api, {__index = _G})})
api.require = function(name)
    if libs[name] == nil then
        libs[name] = assert(loadfile("%(libdir)s/" .. name .. ".lua", "t", libenv))()
    end
    return libs[name]
end
env = setmetatable({actor = actor, self = self, object = object, globals = globals},
    {__index = api})

%(setup)s

env.speech, env.arg = speech, arg
local chunk = assert(loadfile("%(path)s", "t", env))
local ok, err = pcall(chunk)
if not ok then print("ERROR|" .. tostring(err)) end
for _, line in ipairs(log) do print(line) end
local keys = {}
for k in pairs(qv) do keys[#keys + 1] = k end
table.sort(keys)
for _, k in ipairs(keys) do print("Q|" .. k .. "=" .. tostring(qv[k])) end
for q, s in pairs(qstage) do print("S|" .. q .. "=" .. s) end
"""


def run(rel: str, setup: str) -> tuple[list[str], dict[str, str], dict[str, str]]:
    path = next(TRIGGERS.glob(rel))
    chunk = PREAMBLE % {"setup": setup, "path": str(path), "libdir": str(LIBRARIES)}
    r = subprocess.run([LUA, "-"], input=chunk, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    log, state, stages = [], {}, {}
    for line in r.stdout.splitlines():
        if line.startswith("ERROR|"):
            pytest.fail(line)
        elif line.startswith("Q|"):
            k, v = line[2:].split("=", 1)
            state[k] = v
        elif line.startswith("S|"):
            k, v = line[2:].split("=", 1)
            stages[k] = v
        else:
            log.append(line)
    return log, state, stages


def has(log: list[str], text: str) -> bool:
    return any(text in line for line in log)


# ---- Black Legion / Eldorian Guard turn-ins -------------------------------------------------------

TURNINS = [
    # file, side, alignment that qualifies, faction var, other faction var, trophy handed in,
    # trophy vnum key, gem reward id (cap gem), faction cap for trophies
    ("041/041_03_*", "bl", -500, "bl_faction", "eg_faction", (55, 4), "5504", 17, 100),
    ("055/055_03_*", "bl", -500, "bl_faction", "eg_faction", (55, 4), "5504", 17, 200),
    ("041/041_07_*", "eg", 500, "eg_faction", "bl_faction", (55, 3), "5503", 18, 200),
    ("055/055_07_*", "eg", 500, "eg_faction", "bl_faction", (55, 3), "5503", 18, 200),
]
IDS = ["041_03", "055_03", "041_07", "055_07"]


def turnin_setup(side, align, obj, qvars=None):
    ally = "eg_ally" if side == "bl" else "bl_ally"
    lines = [
        f"actor.alignment = {align}",
        'qstage["black_legion"] = 1',
        f"object.zone_id, object.id = {obj[0]}, {obj[1]}",
        'object.name = "a skull"; object.shortdesc = "a skull"',
    ]
    for k, v in (qvars or {}).items():
        lines.append(f'qv["{k}"] = {v}')
    assert ally
    return "\n".join(lines)


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_trophy_turn_in_raises_faction_and_pays_exp(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    log, state, stages = run(rel, turnin_setup(side, align, trophy))
    assert state[f"black_legion:{tkey}_trophies"] == "1"
    assert state[f"black_legion:{fvar}"] == "1"
    assert state[f"black_legion:{ovar}"] == "-1"
    assert state["black_legion:" + ("bl_ally" if side == "bl" else "eg_ally")] == "1"
    assert log.count("exp|2640") == 2  # exp_multiplier 2 for a plain trophy
    assert has(log, "destroy|a skull")
    assert not has(log, "cmd|give")


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_second_trophy_counts_up_the_per_trophy_key(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    setup = turnin_setup(side, align, trophy, {f"black_legion:{tkey}_trophies": 3, f"black_legion:{fvar}": 10})
    _, state, _ = run(rel, setup)
    assert state[f"black_legion:{tkey}_trophies"] == "4"
    assert state[f"black_legion:{fvar}"] == "11"


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_gem_turn_in_hands_out_the_reward(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    log, state, _ = run(rel, turnin_setup(side, align, (555, 70), {f"black_legion:{fvar}": 20}))
    assert f"spawn|55|{reward}" in log
    assert f"cmd|give item55_{reward} Hero" in log  # the give command has no "give all"
    assert state[f"black_legion:55{reward}_reward"] == "1"
    assert state[f"black_legion:{fvar}"] == "21"
    assert state[f"black_legion:{ovar}"] == "-1"
    assert log.count("exp|2640") == 10  # first reward pays exp_multiplier 10
    assert has(log, "destroy|a skull")
    assert not has(log, "give a skull")


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_repeat_gem_reward_pays_no_second_exp(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    setup = turnin_setup(side, align, (555, 70), {f"black_legion:{fvar}": 30, f"black_legion:55{reward}_reward": 1})
    log, state, _ = run(rel, setup)
    assert f"spawn|55|{reward}" in log
    assert state[f"black_legion:55{reward}_reward"] == "2"
    assert "exp|2640" not in log


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_gem_without_enough_faction_is_handed_back(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    log, state, _ = run(rel, turnin_setup(side, align, (555, 70), {f"black_legion:{fvar}": 19}))
    assert not any(line.startswith("spawn|") for line in log)
    assert "cmd|give thing Hero" in log
    assert has(log, "to earn that reward")
    assert state[f"black_legion:{fvar}"] == "19"


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_unknown_item_is_not_interesting_and_handed_back(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    log, _, _ = run(rel, turnin_setup(side, align, (7, 7)))
    assert has(log, "I am not interested in this from you")
    assert "cmd|give thing Hero" in log
    assert not any(line.startswith(("spawn|", "exp|")) for line in log)


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_wrong_alignment_is_handed_back(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    log, state, _ = run(rel, turnin_setup(side, -align, trophy))
    assert "cmd|give thing Hero" in log
    assert has(log, "to earn our rewards")
    assert not state


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_maxed_faction_with_all_trophies_is_handed_back(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    setup = turnin_setup(side, align, trophy, {f"black_legion:{fvar}": cap, f"black_legion:{tkey}_trophies": 10})
    log, state, _ = run(rel, setup)
    assert "cmd|give thing Hero" in log
    assert has(log, "You have garnered as")
    assert state[f"black_legion:{fvar}"] == str(cap)


@needs_lua
def test_high_tier_gem_needs_its_faction_and_pays_more():
    # 055 only: gem_3bl_mask (55579) wants faction 160, pays exp x28 and 3 faction
    rel = "055/055_03_*"
    low = turnin_setup("bl", -500, (555, 79), {"black_legion:bl_faction": 159})
    log, _, _ = run(rel, low)
    assert not any(line.startswith("spawn|") for line in log)
    ok = turnin_setup("bl", -500, (555, 79), {"black_legion:bl_faction": 160})
    log, state, _ = run(rel, ok)
    assert "spawn|55|35" in log
    assert log.count("exp|2640") == 28
    assert state["black_legion:bl_faction"] == "163"
    assert state["black_legion:eg_faction"] == "-3"


@needs_lua
def test_other_side_already_chosen_is_refused():
    log, state, _ = run("055/055_03_*", turnin_setup("bl", -500, (55, 4), {"black_legion:eg_ally": 1}))
    assert has(log, "already chosen your side")
    assert not any(line.startswith(("exp|", "spawn|")) for line in log)


# ---- 004_19 Major Globe journal -------------------------------------------------------------------

JOURNAL_SETUP = """
actor.level, actor.class = 60, "sorcerer"
arg = "major globe"
qstage["major_globe_spell"] = %d
%s
"""


def journal(stage, extra=""):
    log, _, _ = run("004/004_19_*", JOURNAL_SETUP % (stage, extra))
    return [line[2:] for line in log if line.startswith("A|")]


@needs_lua
@pytest.mark.parametrize(
    "stage, task",
    [
        (1, 'Find Earle and tell him "Lirne sends me."'),
        (2, "Find shale on Fiery Island."),
        (3, "Find sake in Odaishyozen."),
        (4, "Find a marigold poultice on a healer in South Caelia."),
        (5, "Bring MOB[534,50] the salve Earle prepared."),
        (6, "<b:cyan>Search</> in each <b:green>library</> or <b:green>stack</> to find the lost spellbook."),
        (7, "Bring OBJ[534,52] to MOB[534,50]."),
    ],
)
def test_journal_prints_the_task_for_each_early_stage(stage, task):
    out = journal(stage)
    assert "Quest Master: " + ("MOB[490,8]" if stage in (2, 3, 4) else "MOB[534,50]") in out
    assert task in out


@needs_lua
def test_journal_stage_8_lists_the_wards_found():
    out = journal(8, 'qv["major_globe_spell:ward_count"] = 2; qv["major_globe_spell:ward_53"] = 2; qv["major_globe_spell:ward_55"] = 2')
    assert any("3 more elemental wards" in line for line in out)
    assert "You have found:" in out
    assert "OBJ[534,53]" in out and "OBJ[534,55]" in out and "OBJ[534,54]" not in out


@needs_lua
def test_journal_stage_9_names_the_item_and_where_to_find_it():
    out = journal(9, 'qv["major_globe_spell:final_item"] = 59')
    assert "Find OBJ[534,59] on an emerald isle." in out


@needs_lua
def test_journal_stage_10_is_the_delivery_task():
    out = journal(10, 'qv["major_globe_spell:final_item"] = 59')
    assert "Deliver OBJ[534,59] to MOB[534,50]." in out


@needs_lua
def test_journal_is_silent_when_not_started_or_completed():
    assert journal(0)[-1].startswith("<cyan>Status: Not Started")
    out = journal(5, 'qdone["major_globe_spell"] = true')
    assert not any("Quest Master" in line for line in out)


# ---- 002_108 phase wand receive -------------------------------------------------------------------

WAND3 = (
    'globals.type, globals.weapon, globals.wandstep, globals.wandattack = "air", "wand", 3, 100\n'
    "globals.wandgem, globals.wandtask3, globals.wand_id = 55591, 23750, 301\n"
    "self.zone_id, self.id = 185, 0\n"
    'actor.class = "sorcerer"; actor.level = 30\n'
    'object.name = "a thing"; object.shortdesc = "a thing"\n'
)


def wand_setup(base, obj, stage, qvars=None):
    lines = [base, f"object.zone_id, object.id = {obj[0]}, {obj[1]}", f'qstage["air_wand"] = {stage}']
    for k, v in (qvars or {}).items():
        lines.append(f'qv["air_wand:{k}"] = {v}')
    return "\n".join(lines)


@needs_lua
def test_wand_gem_is_taken_and_ticked_off():
    log, state, _ = run("002/002_108_*", wand_setup(WAND3, (555, 91), 3, {"greet": 1}))
    assert state["air_wand:wandtask2"] == "1"
    assert has(log, "destroy|a thing")
    assert "say|This is just what I need." in log


@needs_lua
def test_wand_gem_twice_is_refused_and_handed_back():
    setup = wand_setup(WAND3, (555, 91), 3, {"greet": 1, "wandtask2": 1})
    log, state, _ = run("002/002_108_*", setup)
    assert "say|You already gave me this." in log
    assert "cmd|give thing Hero" in log
    assert not has(log, "destroy")


@needs_lua
def test_wand_stage_item_ticks_task3():
    log, state, _ = run("002/002_108_*", wand_setup(WAND3, (237, 50), 3, {"greet": 1}))
    assert state["air_wand:wandtask3"] == "1"


@needs_lua
def test_wand_upgrade_when_everything_is_done():
    done = {"greet": 1, "wandtask1": 1, "wandtask2": 1, "wandtask3": 1}
    log, state, stages = run("002/002_108_*", wand_setup(WAND3, (2, 101), 3, done))
    assert stages["air_wand"] == "4"  # advanced
    assert "spawn|2|102" in log  # wand 301 -> 302 (zone 2 holds vnums 200-399)
    assert "cmd|give item2_102 Hero" in log
    assert has(log, "OBJ[2,101] is transformed into OBJ[2,102]!")
    assert has(log, "inlays OBJ[555,91] in OBJ[2,101]")
    # expcap 20: 1440 + 4 * 175 = 2140, sorcerer +20%, x10, five awards
    assert log.count("exp|25680") == 5
    for k in ("greet", "attack_counter", "wandtask1", "wandtask2", "wandtask3", "wandtask4", "wandtask5"):
        assert state["air_wand:" + k] == "0"


@needs_lua
def test_wand_without_the_rest_is_handed_back_with_the_attack_count():
    log, _, stages = run("002/002_108_*", wand_setup(WAND3, (2, 101), 3, {"greet": 1, "attack_counter": 40}))
    assert "cmd|give thing Hero" in log
    assert has(log, "attack <b:yellow>60</> more times")
    assert "say|I need the other items as well." in log
    assert stages["air_wand"] == "3"


@needs_lua
def test_wand_response_for_a_player_not_on_the_quest_or_too_low():
    log, _, _ = run("002/002_108_*", wand_setup(WAND3, (2, 101), 0))
    assert "say|You haven't even begun this process yet!" in log
    log, _, _ = run("002/002_108_*", wand_setup(WAND3 + "actor.level = 5\n", (2, 101), 3))
    assert "say|You'll need to be at least level 20 before I can improve your bond with your weapon." in log


@needs_lua
def test_wand_unrelated_item_is_ignored():
    log, state, _ = run("002/002_108_*", wand_setup(WAND3, (9, 9), 3, {"greet": 1}))
    assert log == [] and state == {"air_wand:greet": "1"}


WAND6 = (
    'globals.type, globals.weapon, globals.wandstep, globals.wandattack = "air", "wand", 6, 250\n'
    "globals.wandgem, globals.wandtask3, globals.wandtask4, globals.wand_id = 55665, 23800, 59040, 304\n"
    "self.zone_id, self.id = 123, 2\n"
    'actor.class = "sorcerer"; actor.level = 60\n'
    'object.name = "a wand"; object.shortdesc = "a wand"\n'
)


@needs_lua
def test_wand_stage_6_primes_the_wand_instead_of_upgrading():
    done = {"greet": 1, "wandtask1": 1, "wandtask2": 1, "wandtask3": 1, "wandtask4": 1}
    log, state, stages = run("002/002_108_*", wand_setup(WAND6, (2, 104), 6, done))
    assert state["air_wand:wandtask5"] == "1"
    assert "spawn|590|40" in log  # the item to play
    assert "cmd|give thing Hero" in log  # the primed wand goes back ...
    assert "cmd|give item590_40 Hero" in log  # ... with the instrument
    assert stages["air_wand"] == "6"
    assert not has(log, "destroy")


WAND10 = (
    'globals.type, globals.weapon, globals.wandstep, globals.wandattack = "air", "staff", 10, 450\n'
    "globals.wandgem, globals.wandtask3, globals.wandtask4, globals.wand_id = 11811, 52001, 48862, 308\n"
    "self.zone_id, self.id = 185, 81\n"
    'actor.class = "sorcerer"; actor.level = 100\n'
    'object.name = "a staff"; object.shortdesc = "a staff"\n'
)


@needs_lua
def test_wand_stage_10_sends_the_player_to_the_plane_room():
    done = {"greet": 1, "wandtask1": 1, "wandtask2": 1, "wandtask3": 1}
    log, state, _ = run("002/002_108_*", wand_setup(WAND10, (2, 108), 10, done))
    assert state["air_wand:wandtask4"] == "1"
    assert has(log, "ROOM[488,62]")
    assert "cmd|give thing Hero" in log


@needs_lua
def test_wand_gem_in_zone_117_is_recognised():
    log, state, _ = run("002/002_108_*", wand_setup(WAND10, (117, 111), 10, {"greet": 1}))
    assert state["air_wand:wandtask2"] == "1"


# ---- 002_114 wand status --------------------------------------------------------------------------


@needs_lua
def test_wand_status_lists_done_and_outstanding_tasks():
    setup = wand_setup(WAND3, (1, 1), 3, {"greet": 1, "wandtask2": 1, "attack_counter": 30}) + '\nspeech = "wand progress"'
    log, _, _ = run("002/002_114_*", setup)
    rooms = [line[2:] for line in log if line.startswith("R|")]
    assert "- found OBJ[555,91]" in rooms
    assert "- <b:yellow>attack 70 more times with your wand</>" in rooms
    assert "- <b:yellow>find OBJ[237,50]</>" in rooms
    assert not any("find OBJ[555,91]" in r and "<b:yellow>" in r for r in rooms)


@needs_lua
def test_wand_status_points_a_player_past_this_step_to_the_next_crafter():
    setup = wand_setup(WAND3, (1, 1), 5) + '\nspeech = "wand progress"'
    log, _, _ = run("002/002_114_*", setup)
    assert "say|A master of air near the megalith in South Caelia will be able to help next." in log


@needs_lua
def test_wand_status_ignores_other_speech_and_other_classes():
    log, _, _ = run("002/002_114_*", wand_setup(WAND3, (1, 1), 3) + '\nspeech = "hello"')
    assert log == []
    log, _, _ = run("002/002_114_*", wand_setup(WAND3, (1, 1), 3) + '\nspeech = "wand progress"; actor.class = "warrior"')
    assert log == ["say|This weapon is only for students of the arcane arts."]


# ---- 002_126 phase mace receive -------------------------------------------------------------------

MACE1 = (
    "globals.macestep, globals.maceattack, globals.mace_id, globals.reward_mace = 1, 50, 340, 341\n"
    "globals.maceitem2, globals.maceitem3, globals.maceitem4, globals.maceitem5 = 55577, 55211, 13614, 58809\n"
    "self.zone_id, self.id = 30, 25\n"
    'actor.class = "cleric"; actor.level = 20\n'
    'object.name = "a mace"; object.shortdesc = "a mace"\n'
)


def mace_setup(base, obj, stage, qvars=None):
    lines = [base, f"object.zone_id, object.id = {obj[0]}, {obj[1]}", f'qstage["phase_mace"] = {stage}']
    for k, v in (qvars or {}).items():
        lines.append(f'qv["phase_mace:{k}"] = {v}')
    return "\n".join(lines)


@needs_lua
def test_mace_material_is_taken_and_ticked_off():
    log, state, _ = run("002/002_126_*", mace_setup(MACE1, (555, 77), 1, {"greet": 1}))
    assert state["phase_mace:macetask2"] == "1"
    assert has(log, "destroy|a mace")
    assert has(log, "Do you have the other materials?")


@needs_lua
def test_mace_last_material_asks_for_the_mace_when_the_attacks_are_done():
    done = {"greet": 1, "macetask1": 1, "macetask2": 1, "macetask3": 1, "macetask4": 1}
    log, state, _ = run("002/002_126_*", mace_setup(MACE1, (588, 9), 1, done))
    assert state["phase_mace:macetask5"] == "1"
    assert has(log, "Give me the noa[2,140].")


@needs_lua
def test_mace_material_twice_is_refused():
    log, _, _ = run("002/002_126_*", mace_setup(MACE1, (555, 77), 1, {"greet": 1, "macetask2": 1}))
    assert has(log, "You already gave me a mace.")
    assert "cmd|give thing Hero" in log


@needs_lua
def test_mace_upgrade_when_everything_is_done():
    done = {"greet": 1, "macetask1": 1, "macetask2": 1, "macetask3": 1, "macetask4": 1, "macetask5": 1}
    log, state, stages = run("002/002_126_*", mace_setup(MACE1, (2, 140), 1, done))
    assert stages["phase_mace"] == "2"
    assert "spawn|2|141" in log
    assert "cmd|give item2_141 Hero" in log
    # expcap 10: 1440 + (10 - 16) * 175 = 390, x10, ten awards
    assert log.count("exp|3900") == 10
    assert state["phase_mace:greet"] == "0" and state["phase_mace:macetask3"] == "0"


@needs_lua
def test_mace_before_the_other_materials_is_handed_back():
    log, _, _ = run("002/002_126_*", mace_setup(MACE1, (2, 140), 1, {"greet": 1, "macetask2": 1}))
    assert has(log, "Bring me the other materials first.")
    assert "cmd|give thing Hero" in log


@needs_lua
def test_mace_refusals_for_class_level_and_greeting():
    log, _, _ = run("002/002_126_*", mace_setup(MACE1 + 'actor.class = "warrior"\n', (2, 140), 1))
    assert has(log, "only needed for the priestly classes")
    log, _, _ = run("002/002_126_*", mace_setup(MACE1, (2, 140), 1))
    assert has(log, "Tell me why you're here first.")
    log, _, _ = run("002/002_126_*", mace_setup(MACE1, (2, 140), 0, {"greet": 1}))
    assert has(log, "isn't advanced enough")


@needs_lua
def test_mace_step_2_dirt_must_be_dug_by_the_player():
    base = (
        "globals.macestep, globals.maceattack, globals.mace_id, globals.reward_mace = 2, 100, 341, 342\n"
        "globals.maceitem2, globals.maceitem3, globals.maceitem4 = 55593, 18522, 18523\n"
        "globals.maceitem5, globals.maceitem6 = 18524, 18525\n"
        "self.zone_id, self.id = 185, 2\n"
        'actor.class = "cleric"; actor.level = 30\n'
        'object.name = "some dirt"; object.shortdesc = "some dirt"\n'
    )
    log, state, _ = run("002/002_126_*", mace_setup(base, (185, 22), 2, {"greet": 1}))
    assert has(log, "pilgrimage to these places yourself")
    assert "phase_mace:macetask3" not in state
    assert "flag|sentinel|true" in log and log[-1] == "flag|sentinel|false"
    log, state, _ = run("002/002_126_*", mace_setup(base, (185, 22), 2, {"greet": 1, "dirt3": 1}))
    assert state["phase_mace:macetask3"] == "1"


# ---- dg library ------------------------------------------------------------------------------------


def lib_call(expr: str) -> str:
    """Evaluate a Lua expression against data/script_libraries/dg.lua with the sandbox API mocked."""
    chunk = f"""
    local api = setmetatable({{
        objects = {{template = function(z, i) return {{name = "OBJ[" .. z .. "," .. i .. "]"}} end}},
        mobiles = {{template = function(z, i) return {{name = "MOB[" .. z .. "," .. i .. "]"}} end}},
        get_room = function(z, i) return {{name = "ROOM[" .. z .. "," .. i .. "]"}} end,
    }}, {{__index = _G}})
    local dg = assert(loadfile("{LIBRARIES}/dg.lua", "t", api))()
    print({expr})
    """
    r = subprocess.run([LUA, "-"], input=chunk, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return r.stdout.strip()


# legacy vnum -> (zone, id) of the zone FILE the entity was imported from (lib/world/{obj,mob,wld}),
# checked against every vnum of the legacy world when the table was written
@needs_lua
@pytest.mark.parametrize(
    "kind, vnum, key",
    [
        ("obj", 300, "2,100"), ("obj", 301, "2,101"), ("obj", 339, "2,139"), ("obj", 340, "2,140"),
        ("obj", 349, "2,149"), ("obj", 399, "2,199"), ("obj", 555, "4,155"), ("obj", 599, "4,199"),
        ("obj", 11811, "117,111"), ("obj", 3218, "30,218"), ("obj", 55591, "555,91"),
        ("obj", 23750, "237,50"), ("obj", 59040, "590,40"), ("obj", 32412, "324,12"),
        ("obj", 48100, "481,0"), ("obj", 53454, "534,54"), ("obj", 18526, "185,26"),
        ("obj", 5, "1000,5"), ("obj", 2330, "23,30"),
        ("mob", 48250, "481,150"), ("mob", 3013, "30,13"), ("mob", 23803, "238,3"),
        ("mob", 3499, "30,499"), ("mob", 52001, "520,1"), ("mob", 11813, "117,113"),
        ("room", 48862, "488,62"), ("room", 47800, "478,0"), ("room", 5272, "52,72"),
        ("room", 39189, "390,189"), ("room", 7457, "73,157"), ("room", 47404, "472,204"),
        ("room", 47128, "470,128"), ("room", 55105, "551,5"),
    ],
)
def test_dg_vnum_split_follows_the_zone_file(kind, vnum, key):
    assert lib_call(f'(function(z, i) return z .. "," .. i end)(dg.{kind}({vnum}))') == key


@needs_lua
def test_dg_vnum_round_trips_and_names():
    assert lib_call("dg.to_vnum(2, 101), dg.to_vnum(1000, 5), dg.to_vnum(117, 111)") == "301\t5\t11811"
    assert lib_call("dg.oname(301)") == "OBJ[2,101]"
    assert lib_call("dg.mname(48250)") == "MOB[481,150]"
    assert lib_call("dg.rname(48862)") == "ROOM[488,62]"


@needs_lua
def test_dg_flag_treats_zero_and_empty_as_unset():
    assert lib_call("dg.flag(nil), dg.flag(0), dg.flag(''), dg.flag(1), dg.flag('done')") == "false\tfalse\tfalse\ttrue\ttrue"


@needs_lua
def test_dg_quest_item_matches_the_exported_globals():
    expr = (
        'dg.quest_item({zone_id = 2, id = 101}, {wand_id = 301}), '
        'dg.quest_item({zone_id = 3, id = 1}, {wand_id = 301}), '
        'dg.quest_item({zone_id = 30, id = 218}, {maceitem5 = 3218}), '
        'dg.quest_item({zone_id = 117, id = 111}, {wandgem = 11811}), '
        'dg.quest_item({zone_id = 1, id = 1}, {wandtask4 = "text"}), dg.quest_item(nil, {})'
    )
    assert lib_call(expr) == "true\tfalse\ttrue\ttrue\tfalse\tfalse"


# ---- full chain simulation -------------------------------------------------------------------------
# One Lua process per scenario: a small world of players, mobs, items and rooms, the real trigger
# scripts, the engine's quest storage (case-sensitive "quest:name:var:key" text; numbers come back
# as numbers, so a variable reset to 0 is still truthy), single-word `give <keyword> <name>`
# (no "give all"), prefix-and-hyphen keyword matching, and RECEIVE triggers fired in attachment
# order after the item has changed hands (a destroyed item reads as nothing afterwards).

ITEM_KEYWORDS = """2:100|wand,lesser-wand-lightning-wand,simple-aspen-wand,air
2:101|wand,wand-sparks-wand,small-glittering-aspen-wand,air
2:102|wand,wand-shocks-wand,wand-aspen-decorated-diamond,wand-aspen-diamond-wand,air
2:103|wand,greater-wand-lightning-wand,wand-aspen-topaz,air
2:104|wand,wand-sky-wand,long-wand-aspen-lapis-lazuli,air,lightning
2:105|wand,wand-storms,storm-wand,long-wand-aspen-diamonds,air
2:106|staff,staff-air-staff,tall-aspen-staff,topaz,crystal,lightning
2:107|staff,staff-gales-staff,misty-aspen-staff,lapis-lazuli,air,lightning
2:108|staff,staff-tempests-staff,tempestuous-aspen-staff,large-diamond,air,lightning
2:109|staff,staff-maelstrom-staff,glorious-aspen-staff,electrical-might,air,lightning
2:110|wand,lesser-wand-fire-wand,simple-rowan-wand
2:111|wand,wand-smoldering-wand,small-glittering-rowan-wand,fire
2:112|wand,want-flames-wand,wand-rowan-rubies,fire
2:113|wand,greater-wand-fire-wand,wand-aspen-garnet
2:114|wand,wand-blazes-wand,long-wand-rowan-carnelian,fire
2:115|wand,wand-divine-fire-wand,long-wand-rowan-rubies
2:116|staff,staff-volcano-staff,tall-rowan-staff,garnet,ruby,fire
2:117|staff,staff-infernos-staff,smoking-rowan-staff,blazing-carnelians,carnelian,fire
2:118|staff,staff-sun-staff,radiant-rowan-staff,large-ruby,fire
2:119|staff,staff-glorious-flame-staff,glorious-rowan-staff-fiery-might,fire
2:120|wand,lesser-wand-ice-wand,simple-willow-wand
2:121|wand,wand-frost-wand,small-glittering-willow-wand,ice
2:122|wand,wand-chilling-wand,wand-willow-sapphire,ice
2:123|wand,greater-wand-ice-wand,wand-greater-ice-wand,wand-willow-pearls,pearl
2:124|wand,wand-snow-wand,long-wand-willow-moonstone,moonstones,ice
2:125|wand,wand-winter-want,long-wand-willow-sapphire,ice
2:126|staff,staff-water-staff,tall-willow-staff,pearls,pearl,frozen-crystal,ice
2:127|staff,staff-blizzards-staff,freezing-willow-staff,frosty-moonstones,moonstone,ice
2:128|staff,staff-ocean-staff,solid-willow-staff,large-sapphire,ice
2:129|staff,staff-frozen-deep-staff,glorious-willow-staff,icy,might,ice
2:130|wand,lesser-wand-acid-wand,simple-yew-wand,earth
2:131|wand,wand-scarring-wand,small-streaked-yew-want,earth,acid
2:132|wand,wand-corrosion-wand,wand-yew,emerald,earth,acid
2:133|wand,greater-wand-acid-wand,wand-greater-acid-wand,wand-yew-beryl,earth
2:134|wand,wand-tomb-wand,long-wand-yew-malachite,acid,earth
2:135|wand,wand-decay-wand,long-wand-yew-emerald,earth,acid
2:136|staff,staff-earth-staff,tall-yew-staff,beryl,large-malachite,acid
2:137|staff,staff-tremors-staff,trembling-yew-staff,malachite,earth,acid
2:138|staff,staff-dissolution-staff,solid-yew-staff,large-emerald,earth,acid
2:139|staff,staff-disintegration-staff,glorious-yew-staff-radiating-devastating-might,earth,acid
2:140|mace,runed-mace,mace-engraved-holy-runes
2:141|mace,holy-runed-mace,mace-emblazoned-holy-runes
2:142|mace,mace-grave-mace,mace-funerary-markings
2:143|mace,radiant-mace,mace-radiating-divine-magnificence
2:144|mace,ghostly-mace,slightly-translucent-mace
2:145|mace,mace-dark-mace,mace-purge-shadow
2:146|mace,celestial-mace,heavely-mace-gold-mythril
2:147|mace,spirit-mace,ethereal-mace
2:148|mace,sun-mace,mace-blazing-glory-sun
2:149|mace,mace-disruption-mace,mace-unspeakable-power
185:22|dirt,handful-grave-dirt-graveyard,grave-yard
185:23|dirt,handful-grave-dirt-cathedral,handful-grave-dirt-cathedral-betrayal,questobject
185:24|dirt,handful-grave-dirt-pyramid,handful-grave-dirt-gothra-pyramid,questobject
185:25|dirt,handful-grave-dirt-barrows,questobject
185:26|spade,grave-spade,sturdy-hand-shovel,questobject
534:53|ward,elemental-ward-plants,small-sphere-elemental-energy,majorglobe-ward
534:54|ward,elemental-ward-mist,small-sphere-elemental-energy,majorglobe-ward
534:55|ward,elemental-ward-water,small-sphere-elemental-energy,majorglobe-ward
534:56|ward,elemental-ward-flames,small-sphere-elemental-energy,majorglobe-ward
534:57|ward,elemental-ward-ice,small-sphere-elemental-energy,majorglobe-ward"""

SIM = r"""
local TRIG = @@TRIG@@
local LIBDIR = "@@LIBDIR@@"
local ITEM_KEYWORDS = [=[@@KW@@]=]

local W = {log = {}, queue = {}, rooms = {}, by_name = {}, gives_failed = 0, exp = 0}
local function L(s) W.log[#W.log + 1] = s end
local function check(cond, msg) if not cond then error("CHECK FAILED: " .. tostring(msg), 2) end end

-- ---- keyword matching: legacy isname, with the hyphen rules of mud_world::targeting
local function names_match(needle, kws)
    local pool = {}
    for _, k in ipairs(kws) do for w in k:lower():gmatch("[^%s%-]+") do pool[#pool + 1] = w end end
    local function direct(w)
        for _, c in ipairs(pool) do if c:sub(1, #w) == w then return true end end
        return false
    end
    local any = false
    for word in needle:lower():gmatch("%S+") do
        any = true
        if not direct(word) then
            if not word:find("-", 1, true) then return false end
            for part in word:gmatch("[^%-]+") do if not direct(part) then return false end end
        end
    end
    return any
end

local KW = {}
for key, list in ITEM_KEYWORDS:gmatch("(%d+:%d+)|([^\n]+)") do
    local t = {}
    for w in list:gmatch("[^,]+") do t[#t + 1] = w end
    KW[key] = t
end

-- ---- entities
local Ent = {}
-- an item's room is the room of whoever carries it (the engine walks the Located chain)
Ent.__index = function(t, k)
    local m = Ent[k]
    if m ~= nil then return m end
    if k == "room" and rawget(t, "kind") == "item" and rawget(t, "holder") then return t.holder.room end
end
local function ent(t) return setmetatable(t, Ent) end

local function item_level(z, i)
    if z == 2 and i >= 140 and i <= 149 then return i == 140 and 5 or (i - 140) * 10 end
    if z == 2 and i >= 100 and i <= 139 then return i % 10 == 0 and 1 or (i % 10) * 10 end
    return 1
end
local function new_item(z, i)
    local kws = KW[z .. ":" .. i] or {"obj" .. z .. "_" .. i}
    local name = "OBJ[" .. z .. "," .. i .. "]"
    return ent{kind = "item", zone_id = z, id = i, local_id = i, name = name, shortdesc = name,
               alias = kws[1], keywords = kws, level = item_level(z, i), inv = {}}
end

function Ent:send(m) L("send|" .. tostring(self.name) .. "|" .. m) end
function Ent:say(m) L("say|" .. tostring(self.name) .. "|" .. m) end
function Ent:emote(m) L("emote|" .. m) end
function Ent:command(line) W.queue[#W.queue + 1] = {self, line} end
function Ent:set_flag(n, v) L("flag|" .. n .. "|" .. tostring(v)) end
function Ent:has_effect() return false end
function Ent:take(it)
    if it.holder then
        for i, x in ipairs(it.holder.inv) do if x == it then table.remove(it.holder.inv, i) break end end
    end
    it.holder = self
    table.insert(self.inv, it)
end
function Ent:spawn_object(z, i)
    local it = new_item(z, i)
    self:take(it)
    return it
end
function Ent:has_item(z, i)
    for _, it in ipairs(self.inv) do if it.zone_id == z and it.id == i then return true end end
    return false
end
function Ent:has_equipped(z, i)
    for _, it in ipairs(self.inv) do if it.zone_id == z and it.id == i and it.worn then return true end end
    return false
end
function Ent:get_worn() return nil end
function Ent:destroy_item(needle)
    for i = #self.inv, 1, -1 do
        local it = self.inv[i]
        if names_match(needle, it.keywords) then
            table.remove(self.inv, i)
            it._name, it.name = it.name, nil
            L("junk|" .. tostring(it._name))
            return
        end
    end
    L("junk-miss|" .. needle)
end
function Ent:award_exp(n) W.exp = W.exp + n; self.exp = (self.exp or 0) + n; L("exp|" .. n) end
function Ent:save() end
function Ent:teleport(room) self.room = room end
function Ent:damage(n) return n end
-- quests
function Ent:get_quest_stage(q) return self.qs[q] or 0 end
function Ent:start_quest(q) self.qs[q] = 1 end
function Ent:advance_quest(q) self.qs[q] = (self.qs[q] or 0) + 1 end
function Ent:complete_quest(q) self.qdone[q] = true end
function Ent:get_has_completed(q) return self.qdone[q] == true end
function Ent:get_has_failed() return false end
function Ent:get_quest_var(k)
    local q, v = k:match("^([^:]+):(.+)$")
    local raw = self.qv[q .. ":" .. v]
    if raw == nil or raw == "" then return nil end
    return math.tointeger(tonumber(raw)) or raw
end
function Ent:set_quest_var(a, b, c)
    if c == nil then
        local q, v = a:match("^([^:]+):(.+)$")
        self.qv[q .. ":" .. v] = tostring(b)
    else
        self.qv[a .. ":" .. b] = tostring(c)
    end
end

local Room = {}
Room.__index = Room
function Room:send(m) L("room|" .. self.name .. "|" .. m) end
function Room:send_except(_, m) L("room|" .. self.name .. "|" .. m) end
function Room:spawn_object(z, i) local it = new_item(z, i); self.floor[#self.floor + 1] = it; return it end
function Room:find_actor() return nil end
function Room:at(fn) fn() end
local function get_room(z, i)
    local key = z .. ":" .. i
    if not W.rooms[key] then
        W.rooms[key] = setmetatable({zone_id = z, id = i, local_id = i, name = "ROOM[" .. z .. "," .. i .. "]", floor = {}}, Room)
    end
    return W.rooms[key]
end

local function player(class, level)
    local p = ent{kind = "player", name = "Hero", class = class, level = level, alignment = 0, race = "human",
                  is_player = true, inv = {}, qs = {}, qv = {}, qdone = {}, room = get_room(1, 1), group_size = 1}
    p.group_member = {p}
    W.by_name[p.name] = p
    return p
end

-- ---- commands the scripts queue; they run after the script slice (a wait ends a slice)
local function exec(e, line)
    local kw, target = line:match("^give (%S+) (%S+)$")
    if kw then
        local to = W.by_name[target]
        check(to, "give target " .. target)
        for i = #e.inv, 1, -1 do
            local it = e.inv[i]
            if not it.worn and names_match(kw, it.keywords) then
                to:take(it)
                L("give|" .. e.name .. "|" .. it.name .. "|" .. to.name)
                return
            end
        end
        W.gives_failed = W.gives_failed + 1
        L("give-failed|" .. e.name .. "|" .. kw)
        return
    end
    L("cmd|" .. tostring(e.name) .. "|" .. line)
end
local function flush()
    while #W.queue > 0 do
        local q = table.remove(W.queue, 1)
        exec(q[1], q[2])
    end
end

-- ---- script environment
local libs = {}
local api = {}
api.wait = flush
api.world = {destroy = function(o)
    if type(o) ~= "table" or o.name == nil then return end
    if o.holder then
        for i, x in ipairs(o.holder.inv) do if x == o then table.remove(o.holder.inv, i) break end end
    end
    o._name, o.name = o.name, nil
    L("destroy|" .. tostring(o._name))
end}
api.objects = {template = function(z, i) return {name = "OBJ[" .. z .. "," .. i .. "]"} end}
api.mobiles = {template = function(z, i) return {name = "MOB[" .. z .. "," .. i .. "]"} end}
api.get_room = get_room
api.get_obj_noadesc = function(z, i) return "noa[" .. z .. "," .. i .. "]" end
api.random = function(_, b) return b end
api.percent_chance = function() return false end
api.timestamp = function() return 1000 end
api.spells = {cast = function(_, name) L("cast|" .. tostring(name)) end}
api.run_room_trigger = function() end
api.Effect = setmetatable({}, {__index = function(_, k) return k end})
api.require = function(name)
    if libs[name] == nil then
        libs[name] = assert(loadfile(LIBDIR .. "/" .. name .. ".lua", "t", setmetatable({}, {__index = setmetatable(api, {__index = _G})})))()
    end
    return libs[name]
end
setmetatable(api, {__index = _G})

local function run(tid, ctx)
    local path = assert(TRIG[tid], "no script " .. tid)
    local env = setmetatable({
        actor = ctx.actor, self = ctx.self, object = ctx.object, victim = ctx.victim, damage = ctx.damage or 0,
        speech = ctx.speech or "", arg = ctx.arg or "", cmd = ctx.cmd, location = ctx.location,
        globals = ctx.self and ctx.self.globals, event = "TEST",
    }, {__index = api})
    local chunk = assert(loadfile(path, "t", env))
    local ok, ret = pcall(chunk)
    flush()
    if not ok then error("trigger " .. tid .. " failed: " .. tostring(ret), 2) end
    return ret
end

local WAND_CRAFTERS, MACE_CRAFTERS = {}, {}
local RECEIVE = {
    ["30:13"] = {"2:102"},
    ["30:25"] = {"2:126"}, ["185:2"] = {"2:126", "185:29"}, ["100:0"] = {"2:126"}, ["62:18"] = {"2:126"},
    ["85:1"] = {"2:126", "85:26"}, ["185:81"] = {"2:108", "2:126", "185:31"}, ["60:7"] = {"2:126"},
    ["484:12"] = {"2:108", "2:126", "484:27"}, ["30:21"] = {"2:126"},
    ["103:0"] = {"2:108", "103:25"}, ["123:4"] = {"2:108", "123:42"}, ["123:5"] = {"2:108", "123:42"},
    ["163:15"] = {"2:108", "163:10"}, ["238:2"] = {"2:108", "238:8"}, ["481:150"] = {"2:108", "481:149"},
    ["490:3"] = {"2:108", "490:22"}, ["533:16"] = {"2:108", "533:14"}, ["550:13"] = {"2:108", "550:8"},
    ["52:30"] = {"2:108", "52:8", "52:16"},
}

local mobs = {}
local function mob(z, i)
    local key = z .. ":" .. i
    if mobs[key] then return mobs[key] end
    local m = ent{kind = "mob", zone_id = z, id = i, local_id = i, name = "MOB[" .. z .. "," .. i .. "]",
                  inv = {}, globals = {}, room = get_room(z, i), is_npc = true, is_player = false}
    m.shortdesc = m.name
    W.by_name[m.name] = m
    mobs[key] = m
    if WAND_CRAFTERS[key] then run("2:111", {self = m, actor = m}) end
    if MACE_CRAFTERS[key] then run("2:118", {self = m, actor = m}) end
    return m
end

-- the player hands `it` to `m`: it changes hands, then every RECEIVE trigger runs in order
local function recv(m, p, it)
    m:take(it)
    for _, tid in ipairs(RECEIVE[m.zone_id .. ":" .. m.id] or {"2:108"}) do
        run(tid, {self = m, actor = p, object = it})
    end
end
local function say(m, p, tid, speech) run(tid, {self = m, actor = p, speech = speech}) end
local dummy = {name = "a goblin", composition = "flesh", lifeforce = "living", race = "goblin", hit = 100, alignment = 0,
               damage = function() return 0 end}
local function attack(tid, p, weapon, n)
    for _ = 1, n do run(tid, {self = weapon, actor = p, victim = dummy, damage = 3}) end
end
local DG
local function flag(p, q, v) local x = p:get_quest_var(q .. ":" .. v); return x ~= nil and x ~= 0 and x ~= "" end
local function find(holder, z, i)
    for k = #holder.inv, 1, -1 do local it = holder.inv[k]; if it.zone_id == z and it.id == i then return it end end
end
local function obj_key(vnum) return DG.obj(vnum) end
local function give_vnum(m, p, vnum)
    local z, i = DG.obj(vnum)
    local it = p:spawn_object(z, i)
    recv(m, p, it)
    return it
end

DG = api.require("dg")
@@SCENARIO@@
print("LOG-BEGIN")
for _, line in ipairs(W.log) do print(line) end
print("OK gives_failed=" .. W.gives_failed .. " exp=" .. W.exp)
"""

WAND_SCENARIO = r"""
WAND_CRAFTERS = {}
local WAND_MOB = {
    air = {[3] = {185, 0}, [4] = {586, 1}, [5] = {123, 5}, [6] = {123, 2}, [7] = {490, 3}, [8] = {85, 15}, [9] = {62, 16}, [10] = {185, 81}},
    fire = {[3] = {41, 26}, [4] = {103, 6}, [5] = {123, 4}, [6] = {238, 11}, [7] = {481, 5}, [8] = {481, 150}, [9] = {484, 12}, [10] = {52, 30}},
    ice = {[3] = {178, 6}, [4] = {23, 37}, [5] = {550, 13}, [6] = {238, 2}, [7] = {533, 16}, [8] = {103, 0}, [9] = {100, 12}, [10] = {550, 20}},
    acid = {[3] = {100, 56}, [4] = {625, 4}, [5] = {625, 3}, [6] = {470, 75}, [7] = {40, 17}, [8] = {480, 29}, [9] = {35, 49}, [10] = {163, 15}},
}
local BOSS = {
    air = {[9] = {238, 3}, [10] = {520, 1}}, fire = {[9] = {40, 13}, [10] = {520, 2}},
    ice = {[9] = {533, 0}, [10] = {520, 5}}, acid = {[9] = {520, 18}, [10] = {520, 7}},
}
-- imbue rooms by legacy room number: the step 5 area, the step 8 place, the step 10 plane
local ROOMS = {
    air = {area = {550, 1}, place = {490, 7}, plane = {488, 62}},
    fire = {area = {52, 50}, place = {52, 72}, plane = {478, 0}},
    ice = {area = {390, 10}, place = {551, 5}, plane = {477, 8}},
    acid = {area = {73, 10}, place = {163, 55}, plane = {476, 72}},
}
local BASE = {air = 300, fire = 310, ice = 320, acid = 330}
local GEM = {air = 77, fire = 75, ice = 74, acid = 76}
local ELEMENT = ELEMENT_NAME
for _, el_mobs in pairs(WAND_MOB) do for _, k in pairs(el_mobs) do WAND_CRAFTERS[k[1] .. ":" .. k[2]] = true end end

local quest = ELEMENT .. "_wand"
local p = player("sorcerer", 100)
local dz, di = DG.obj(BASE[ELEMENT])
local wand = p:spawn_object(dz, di)
wand.worn = true

-- Bigby's assistant: greet starts the quest, giving the wand and the gem finishes stage 2
local bigby = mob(30, 13)
run("2:100", {self = bigby, actor = p})
check(p:get_quest_stage(quest) == 1, "greet starts the quest")
check(flag(p, quest, "greet"), "greet var")
say(bigby, p, "2:101", ELEMENT)
say(bigby, p, "2:113", "progress")
wand.worn = false
run("2:104", {self = wand, actor = p, victim = bigby})
attack("2:103", p, wand, 49)
check(p:get_quest_stage(quest) == 1 and not flag(p, quest, "wandtask1"), "no bond at stage 1")
recv(bigby, p, wand)
check(p:get_quest_stage(quest) == 2, "the wand moves the quest to stage 2")
check(find(p, dz, di), "the wand comes back")
attack("2:103", p, wand, 49)
check(not flag(p, quest, "wandtask1"), "49 attacks are not enough")
attack("2:103", p, wand, 1)
check(flag(p, quest, "wandtask1"), "50 attacks bond the wand")
recv(bigby, p, p:spawn_object(555, GEM[ELEMENT]))
check(flag(p, quest, "wandtask2"), "the gem is ticked off")
say(bigby, p, "2:113", "progress")
recv(bigby, p, wand)
check(p:get_quest_stage(quest) == 3, "stage 3 after the first upgrade, got " .. p:get_quest_stage(quest))
check(not find(p, dz, di) and find(p, 2, di + 1), "the next wand replaces the first")
check(not flag(p, quest, "wandtask1") and not flag(p, quest, "greet"), "the stage resets its flags")
wand = find(p, 2, di + 1)

for step = 3, 10 do
    local mk = WAND_MOB[ELEMENT][step]
    local m = mob(mk[1], mk[2])
    local g = m.globals
    check(g.wandstep == step and g.type == ELEMENT, "crafter " .. m.name .. " exports its step")
    check(g.wand_id == BASE[ELEMENT] + step - 2, "wand id of step " .. step .. " is " .. tostring(g.wand_id))
    check(p:get_quest_stage(quest) == step, "stage " .. p:get_quest_stage(quest) .. " at the step " .. step .. " crafter")
    local wz, wi = DG.obj(g.wand_id)
    wand = find(p, wz, wi)
    check(wand, "the player holds the step " .. step .. " weapon")

    run("2:106", {self = m, actor = p})
    say(m, p, "2:107", "can you upgrade my wand")
    check(p:get_quest_var(quest .. ":greet") == 1, "speech sets greet at step " .. step)
    say(m, p, "2:114", "wand progress")
    attack("2:103", p, wand, (step - 1) * 50 - 1)
    check(not flag(p, quest, "wandtask1"), "one attack short at step " .. step)
    attack("2:103", p, wand, 1)
    check(flag(p, quest, "wandtask1"), "bonded at step " .. step)

    local gem = give_vnum(m, p, g.wandgem)
    check(flag(p, quest, "wandtask2") and not gem.holder.inv[1] == false or true, "")
    check(flag(p, quest, "wandtask2"), "gem at step " .. step)
    check(not find(p, DG.obj(g.wandgem)) and not find(m, DG.obj(g.wandgem)), "the gem is consumed at step " .. step)

    if step == 10 then
        local b = mob(BOSS[ELEMENT][10][1], BOSS[ELEMENT][10][2])
        -- the stage 10 boss kill credits wandtask3 to a group member standing in the room
        p.room = b.room
        run("2:112", {self = b, actor = p})
        p.room = get_room(1, 1)
        check(flag(p, quest, "wandtask3"), "boss kill credits wandtask3")
    elseif step == 9 then
        local b = mob(BOSS[ELEMENT][9][1], BOSS[ELEMENT][9][2])
        run("2:112", {self = b, actor = p})
        check(not flag(p, quest, "wandtask4"), "a kill from another room earns nothing")
        p.room = b.room
        run("2:112", {self = b, actor = p})
        p.room = get_room(1, 1)
        check(flag(p, quest, "wandtask4"), "boss kill credits wandtask4")
        give_vnum(m, p, g.wandtask3)
        check(flag(p, quest, "wandtask3"), "task 3 at step 9")
    else
        give_vnum(m, p, g.wandtask3)
        check(flag(p, quest, "wandtask3"), "task 3 at step " .. step)
    end

    if step == 4 or step == 6 or step == 7 or step == 8 then
        give_vnum(m, p, g.wandtask4)
        check(flag(p, quest, "wandtask4"), "task 4 at step " .. step)
    end

    if step == 5 then
        -- imbue the wand in the element's area
        local r = ROOMS[ELEMENT].area
        p.room = get_room(r[1], r[2])
        wand.worn = true
        run("2:109", {self = wand, actor = p, cmd = "imbue", location = "equip"})
        check(flag(p, quest, "wandtask4"), "imbued in the area")
        wand.worn = false
        p.room = get_room(1, 1)
    end

    local before_exp = W.exp
    recv(m, p, wand)
    if step == 6 or step == 8 then
        -- the crafter primes the weapon and hands it back with the item for the next step
        check(flag(p, quest, "wandtask5"), "primed at step " .. step)
        check(p:get_quest_stage(quest) == step, "priming does not advance step " .. step)
        check(find(p, wz, wi), "the primed weapon comes back")
        local tz, ti = DG.obj(g.wandtask4)
        local extra = find(p, tz, ti)
        check(extra, "the primed item comes back at step " .. step)
        if step == 6 then
            -- play the instrument: the stage 6 wand becomes the stage 7 wand
            run("2:127", {self = extra, actor = p})
            check(p:get_quest_stage(quest) == 7, "playing advances to stage 7")
            check(find(p, 2, wi + 1) and not find(p, wz, wi), "the played wand is replaced")
        else
            -- imbue the primed staff with the ward at the place
            local r = ROOMS[ELEMENT].place
            p.room = get_room(r[1], r[2])
            local staff = find(p, wz, wi)
            run("2:109", {self = staff, actor = p, cmd = "imbue", location = "inventory"})
            check(p:get_quest_stage(quest) == 9, "imbuing at the place advances to stage 9")
            check(find(p, 2, wi + 1) and not find(p, wz, wi), "the imbued staff is replaced")
            check(not find(p, tz, ti), "the ward is consumed")
            p.room = get_room(1, 1)
        end
    elseif step == 10 then
        check(flag(p, quest, "wandtask4"), "the staff is primed for the plane")
        check(find(p, wz, wi), "the primed staff comes back")
        local r = ROOMS[ELEMENT].plane
        p.room = get_room(r[1], r[2])
        local staff = find(p, wz, wi)
        run("2:109", {self = staff, actor = p, cmd = "imbue", location = "inventory"})
        check(p:get_has_completed(quest), "the final imbue completes the quest")
        check(find(p, 2, wi + 1) and not find(p, wz, wi), "the final staff replaces the old one")
        p.room = get_room(1, 1)
    else
        check(p:get_quest_stage(quest) == step + 1, "stage " .. p:get_quest_stage(quest) .. " after step " .. step)
        check(find(p, 2, wi + 1) and not find(p, wz, wi), "the upgraded weapon replaces the old at step " .. step)
        check(not flag(p, quest, "wandtask1") and not flag(p, quest, "wandtask3"), "flags reset after step " .. step)
    end
    check(W.exp > before_exp, "experience at step " .. step)
    check(find(p, 2, wi + 1) ~= nil, "the next weapon is in the pack after step " .. step)
end
check(p:get_has_completed(quest), "finished")
check(W.gives_failed == 0, "no give failed: " .. W.gives_failed)
"""

MACE_SCENARIO = r"""
MACE_CRAFTERS = {}
local MACE_MOB = {{30, 25}, {185, 2}, {100, 0}, {62, 18}, {85, 1}, {185, 81}, {60, 7}, {484, 12}, {30, 21}}
for _, k in ipairs(MACE_MOB) do MACE_CRAFTERS[k[1] .. ":" .. k[2]] = true end
-- where the pilgrimage dirt is dug: room, dirt item
local GRAVES = {{{470, 10}, 22}, {{85, 5}, 23}, {{162, 50}, 24}, {{480, 50}, 25}}

local p = player("cleric", 100)
local mace = p:spawn_object(2, 140)
mace.worn = true
local speech_script = function(m)
    local k = m.zone_id .. ":" .. m.id
    if k == "30:25" then return "30:31" end
    if k == "185:81" or k == "484:12" then return "2:107" end
    return "2:115"
end

for step = 1, 9 do
    local mk = MACE_MOB[step]
    local m = mob(mk[1], mk[2])
    local g = m.globals
    check(g.macestep == step, "priest " .. m.name .. " exports its step")
    local mz, mi = 2, 139 + step
    mace = find(p, mz, mi)
    check(mace, "the player holds the step " .. step .. " mace")

    if step == 1 then
        check(p:get_quest_stage("phase_mace") == 0, "not started")
        run("2:105", {self = mace, actor = p})
        run("2:117", {self = mace, actor = p, victim = m})
        check(p:get_quest_stage("phase_mace") == 1, "giving the mace to the first priest starts the quest")
    end
    run("2:117", {self = mace, actor = p, victim = m})
    say(m, p, speech_script(m), "upgrade")
    check(p:get_quest_var("phase_mace:greet") == 1, "speech sets greet at step " .. step)
    say(m, p, "2:116", "mace progress")
    if step == 2 then
        check(find(p, 185, 26), "the Sexton hands out the grave spade")
    end
    attack("2:119", p, mace, step * 50 - 1)
    check(not flag(p, "phase_mace", "macetask1"), "one attack short at step " .. step)
    attack("2:119", p, mace, 1)
    check(flag(p, "phase_mace", "macetask1"), "bonded at step " .. step)

    if step == 2 then
        local spade = find(p, 185, 26)
        spade.worn = true
        local eh = m
        -- the Sexton scatters dirt nobody dug and counts nothing for it
        give_vnum(eh, p, g.maceitem3)
        check(not flag(p, "phase_mace", "macetask3"), "undug dirt does not count")
        check(not find(p, 185, 22) and not find(eh, 185, 22), "the undug dirt is scattered")
        p.room = get_room(1, 1)
        run("2:120", {self = spade, actor = p, cmd = "dig", location = "equip"})
        check(not find(p, 185, 22), "no dirt in the wrong place")
        for _, gr in ipairs(GRAVES) do
            p.room = get_room(gr[1][1], gr[1][2])
            run("2:120", {self = spade, actor = p, cmd = "dig", location = "equip"})
            check(find(p, 185, gr[2]), "dirt dug at " .. gr[1][1])
        end
        check(p:get_quest_var("phase_mace:graves") == "done", "the pilgrimage is complete")
        p.room = get_room(1, 1)
        -- pick the dug dirt: one of each, taken out of the pack
        local dirts = {}
        for _, gr in ipairs(GRAVES) do dirts[#dirts + 1] = find(p, 185, gr[2]) end
        give_vnum(m, p, g.maceitem2)
        for k, d in ipairs(dirts) do recv(m, p, d) end
        for n = 2, 6 do check(flag(p, "phase_mace", "macetask" .. n), "macetask" .. n .. " at step 2") end
    else
        local list = {g.maceitem2, g.maceitem3, g.maceitem4, g.maceitem5}
        for n, v in ipairs(list) do
            give_vnum(m, p, v)
            check(flag(p, "phase_mace", "macetask" .. (n + 1)), "material " .. n .. " at step " .. step)
        end
    end

    local before_exp = W.exp
    recv(m, p, mace)
    check(p:get_quest_stage("phase_mace") == step + 1, "stage " .. p:get_quest_stage("phase_mace") .. " after step " .. step)
    check(find(p, 2, mi + 1) and not find(p, 2, mi), "the next mace replaces the old at step " .. step)
    check(not flag(p, "phase_mace", "macetask1") and not flag(p, "phase_mace", "greet"), "flags reset after step " .. step)
    check(W.exp > before_exp, "experience at step " .. step)
end
check(find(p, 2, 149), "the mace of disruption")
check(p:get_quest_stage("phase_mace") == 10, "stage 10 is the end of the chain")
check(W.gives_failed == 0, "no give failed: " .. W.gives_failed)
"""

TRIGGER_IDS = (
    [(2, n) for n in (100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 126, 127)]
    + [(30, 31), (52, 8), (52, 16), (85, 26), (103, 25), (123, 42), (163, 10), (185, 29), (185, 31),
       (238, 8), (481, 149), (484, 27), (490, 22), (533, 14), (550, 8)]
)


def trigger_table() -> str:
    entries = []
    for zone, tid in TRIGGER_IDS:
        path = next(TRIGGERS.glob(f"{zone:03d}/{zone:03d}_{tid:02d}_*.lua"))
        entries.append(f'["{zone}:{tid}"] = "{path}"')
    return "{" + ", ".join(entries) + "}"


def simulate(scenario: str) -> list[str]:
    chunk = (
        SIM.replace("@@TRIG@@", trigger_table())
        .replace("@@LIBDIR@@", str(LIBRARIES))
        .replace("@@KW@@", ITEM_KEYWORDS.strip())
        .replace("@@SCENARIO@@", scenario)
    )
    r = subprocess.run([LUA, "-"], input=chunk, capture_output=True, text=True)
    assert r.returncode == 0, r.stderr.strip().splitlines()[0] if r.stderr else r.stdout
    lines = r.stdout.splitlines()
    assert lines[-1].startswith("OK gives_failed=0"), lines[-1]
    return lines[lines.index("LOG-BEGIN") + 1 :]


@needs_lua
@pytest.mark.parametrize("element", ["air", "fire", "ice", "acid"])
def test_wand_quest_completes_from_bigby_to_the_final_staff(element):
    log = simulate(WAND_SCENARIO.replace("ELEMENT_NAME", f'"{element}"'))
    # the final staff is handed over, every stage paid experience, nothing was handed to a missing item
    assert sum(1 for line in log if line.startswith("exp|")) >= 8 * 5
    assert not any(line.startswith("give-failed") for line in log)


@needs_lua
def test_mace_quest_completes_from_the_magistrate_to_the_mace_of_disruption():
    log = simulate(MACE_SCENARIO)
    assert sum(1 for line in log if line.startswith("exp|")) >= 9 * 10
    assert not any(line.startswith("give-failed") for line in log)


# ---- single scripts: refusals, greeters, journals, counters ----------------------------------------


def sent(log):
    return [line[2:] for line in log if line.startswith(("A|", "R|"))]


# (script, mob/globals setup that makes a wand or mace item "ours", the quest item, an item that is not)
REFUSERS = [
    ("052/052_16_*", WAND3.replace("55591", "23822") + "self.zone_id, self.id = 52, 30\n", (238, 22), (3, 3)),
    ("085/085_26_*", MACE1 + "self.zone_id, self.id = 85, 1\n", (555, 77), (3, 3)),
    ("103/103_25_*", WAND3 + "self.zone_id, self.id = 103, 0\n", (555, 91), (3, 3)),
    ("123/123_42_*", WAND3 + "self.zone_id, self.id = 123, 4\n", (555, 91), (3, 3)),
    ("163/163_10_*", WAND3 + "self.zone_id, self.id = 163, 15\n", (555, 91), (3, 3)),
    ("185/185_29_*", MACE1 + "self.zone_id, self.id = 185, 2\n", (555, 77), (3, 3)),
    ("185/185_31_*", WAND3 + MACE1 + "self.zone_id, self.id = 185, 81\n", (555, 91), (3, 3)),
    ("238/238_08_*", WAND3 + "self.zone_id, self.id = 238, 2\n", (555, 91), (3, 3)),
    ("481/481_149_*", WAND3 + "self.zone_id, self.id = 481, 150\n", (555, 91), (3, 3)),
    ("484/484_27_*", WAND3 + MACE1 + "self.zone_id, self.id = 484, 12\n", (555, 91), (3, 3)),
    ("490/490_22_*", WAND3 + "self.zone_id, self.id = 490, 3\n", (555, 91), (3, 3)),
    ("533/533_14_*", WAND3 + "self.zone_id, self.id = 533, 16\n", (555, 91), (3, 3)),
    ("550/550_08_*", WAND3 + "self.zone_id, self.id = 550, 13\n", (555, 91), (3, 3)),
    ("625/625_05_*", WAND3 + "self.zone_id, self.id = 625, 3\n", (555, 91), (3, 3)),
]


@needs_lua
@pytest.mark.parametrize("rel, base, ours, other", REFUSERS, ids=[r[0].split("/")[1][:6] for r in REFUSERS])
def test_refusers_let_the_quest_items_through_and_hand_back_the_rest(rel, base, ours, other):
    def setup(item):
        return base + f"\nobject.zone_id, object.id = {item[0]}, {item[1]}\nobject.name = 'a thing'; object.shortdesc = 'a thing'"

    log, _, _ = run(rel, setup(ours))
    assert log == [], "a wand or mace item belongs to the receive trigger"
    log, _, _ = run(rel, setup(other))
    assert has(log, "cmd|give thing Hero") or has(log, "cmd|drop thing"), "everything else goes back"


@needs_lua
def test_refuser_stays_quiet_when_an_earlier_trigger_took_the_item():
    log, _, _ = run("185/185_31_*", WAND3 + "self.zone_id, self.id = 185, 81\nobject.name = nil\n")
    assert log == []


@needs_lua
def test_sexton_lets_the_dirt_the_sexton_asked_for_through():
    base = MACE1 + "globals.maceitem6 = 18525\nself.zone_id, self.id = 185, 2\n"
    log, _, _ = run("185/185_29_*", base + "object.zone_id, object.id = 185, 25\n")
    assert log == []


# greeters: (script, globals of the crafter it is attached to, stage var, expected greeting)
GREETERS = [
    ("178/178_03_*", WAND3.replace("185, 0", "178, 6"), "air_wand", "we can talk about"),
    ("238/238_10_*", WAND3.replace("185, 0", "238, 2"), "air_wand", "we can talk about"),
    ("163/163_01_*", WAND3.replace("185, 0", "163, 15"), "air_wand", "we can talk about"),
    ("533/533_08_*", WAND3.replace("185, 0", "533, 16"), "air_wand", "we can talk about"),
    ("550/550_00_*", WAND3.replace("185, 0", "550, 20"), "air_wand", "we can talk about"),
    ("550/550_34_*", WAND3.replace("185, 0", "490, 3"), "air_wand", "what brings you to me"),
    ("052/052_02_*", WAND3.replace("185, 0", "52, 30"), "air_wand", "we can talk about"),
    ("185/185_01_*", WAND3 + "self.zone_id, self.id = 185, 81\n", "air_wand", "we can talk about"),
    ("484/484_01_*", WAND3.replace("185, 0", "484, 12"), "air_wand", "Tell us what you are working on"),
]


@needs_lua
@pytest.mark.parametrize("rel, base, quest, text", GREETERS, ids=[g[0].split("/")[1][:6] for g in GREETERS])
def test_wand_greeters_offer_the_upgrade_to_a_player_on_their_step(rel, base, quest, text):
    setup = base + f'\nqstage["{quest}"] = 3\nqv["{quest}:greet"] = 0'
    log, _, _ = run(rel, setup)
    assert any(text in line for line in sent(log)), sent(log)
    # greeted once already: the greeting asks for the materials instead
    log, _, _ = run(rel, base + f'\nqstage["{quest}"] = 3\nqv["{quest}:greet"] = 1')
    assert any("Do you have" in line or "what I need" in line or "all set" in line or "ready" in line for line in sent(log) + [x[4:] for x in log if x.startswith("say|")]), log
    # not on the step: nothing about crafting
    log, _, _ = run(rel, base + f'\nqstage["{quest}"] = 4')
    assert not any("crafting something" in line for line in sent(log))


@needs_lua
def test_ziijhan_and_silania_greet_a_mace_player_on_their_step():
    base = MACE1.replace("30, 25", "85, 1").replace("globals.macestep, globals.maceattack, globals.mace_id, globals.reward_mace = 1, 50, 340, 341", "globals.macestep = 5")
    log, _, _ = run("085/085_00_*", base + '\nactor.class = "warrior"; actor.level = 50\nqstage["phase_mace"] = 5\nqv["phase_mace:greet"] = 0')
    assert any("ghostly presence" in line for line in sent(log))
    log, _, _ = run("085/085_00_*", base + '\nactor.class = "warrior"; actor.level = 50\nqstage["phase_mace"] = 5\nqv["phase_mace:greet"] = 1')
    assert any("Do you have what I need" in line for line in sent(log))


@needs_lua
def test_magistrate_offers_the_mace_to_a_player_whose_greet_was_reset_to_zero():
    setup = 'qstage["phase_mace"] = 0\nqv["phase_mace:greet"] = 0\nactor.is_player = true\nfunction actor:has_item(z, i) return z == 2 and i == 140 end\nfunction actor:has_equipped() return false end'
    log, _, _ = run("030/030_25_*", setup)
    assert any("unusual mace" in line for line in sent(log))
    log, _, _ = run("030/030_25_*", 'qstage["phase_mace"] = 1\nqv["phase_mace:greet"] = 1\nactor.is_player = true\nfunction actor:has_item() return false end\nfunction actor:has_equipped() return false end')
    assert any("Have you found what I require" in line for line in sent(log))


# 002_104: the first wand of each element, handed to Bigby's assistant, starts the quest
@needs_lua
def test_giving_the_basic_wand_to_the_assistant_starts_the_quest_and_other_wands_are_warned():
    setup = "self.zone_id, self.id = 2, 110\nvictim = {zone_id = 30, id = 13, name = 'Bigby'}\nfunction actor:start_quest(q) qstage[q] = 1; L('start|' .. q) end"
    log, _, stages = run("002/002_104_*", setup)
    assert stages == {"fire_wand": "1"}
    log, _, stages = run("002/002_104_*", setup.replace("2, 110", "2, 111"))
    assert stages == {} and has(log, "You shouldn't give away something so precious!")


@needs_lua
def test_wielding_the_basic_wand_starts_the_quest_and_a_far_wand_warns():
    log, _, stages = run("002/002_105_*", "self.zone_id, self.id, self.level = 2, 120, 1")
    assert stages == {"ice_wand": "1"} and not has(log, "bound")
    log, _, stages = run("002/002_105_*", "self.zone_id, self.id, self.level = 2, 125, 50\nqstage['ice_wand'] = 3")
    assert has(log, "This weapon is bound to someone else!")
    log, _, _ = run("002/002_105_*", "self.zone_id, self.id, self.level = 2, 125, 50\nqstage['ice_wand'] = 7")
    assert not has(log, "bound")


@needs_lua
def test_attack_counter_counts_per_element_and_stage_and_resets_nothing_else():
    setup = "self.zone_id, self.id, self.level, self.shortdesc = 2, 126, 60, 'a staff'\nqstage['ice_wand'] = 3\nqv['ice_wand:attack_counter'] = 99\nvictim = {}"
    log, state, _ = run("002/002_103_*", setup)
    assert state["ice_wand:attack_counter"] == "100" and state["ice_wand:wandtask1"] == "1"
    assert has(log, "perfected your bond")
    # a flag that was reset to 0 counts as not bonded yet, and the counter keeps running
    log, state, _ = run("002/002_103_*", setup.replace("= 99", "= 3") + "\nqv['ice_wand:wandtask1'] = 0")
    assert state["ice_wand:attack_counter"] == "4" and "ice_wand:wandtask1" in state


@needs_lua
def test_mace_attack_counter_ignores_a_bond_flag_reset_to_zero():
    setup = "self.zone_id, self.id, self.level, self.shortdesc = 2, 141, 10, 'a mace'\nvictim = {}\nqstage['phase_mace'] = 2\nqv['phase_mace:attack_counter'] = 99\nqv['phase_mace:macetask1'] = 0"
    log, state, _ = run("002/002_119_*", setup)
    assert state["phase_mace:attack_counter"] == "100" and state["phase_mace:macetask1"] == "1"


@needs_lua
def test_bigby_generic_word_prompts_for_an_element_without_reading_any_stage():
    log, _, _ = run("002/002_101_*", 'speech = "wand"\nactor.class = "sorcerer"; actor.level = 50\nqstage["air_wand"] = 5')
    assert "say|Yeah, I can help you upgrade any basic wand!" in log
    assert any("Tell me what element" in line for line in sent(log))
    log, _, stages = run("002/002_101_*", 'speech = "fire"\nactor.class = "sorcerer"; actor.level = 50')
    assert stages == {"fire_wand": "1"}


@needs_lua
def test_bigby_receive_reads_the_composite_keys_not_legacy_ids():
    setup = (
        'actor.class = "sorcerer"; actor.level = 50\nqstage["air_wand"] = 1\n'
        "object.zone_id, object.id, object.name, object.shortdesc = 2, 100, 'a lesser wand', 'a lesser wand'\n"
    )
    log, _, stages = run("002/002_102_*", setup)
    assert stages["air_wand"] == "2"
    assert has(log, "OBJ[555,77]")
    assert "cmd|give thing Hero" in log


@needs_lua
def test_death_credit_goes_to_group_members_in_the_room():
    setup = (
        "self.zone_id, self.id = 520, 1\nqstage['air_wand'] = 10\n"
        "local other = {name = 'Pal', is_player = true, room = self.room, qv = {}}\n"
        "function other:get_quest_stage() return 10 end\n"
        "function other:get_quest_var(k) return qv_other and qv_other[k] end\n"
        "function other:set_quest_var(q, k, v) L('pal|' .. q .. ':' .. k .. '=' .. tostring(v)) end\n"
        "function other:send(m) L('P|' .. m) end\n"
        "actor.room = self.room; actor.group_member = {actor, other}\n"
    )
    log, state, _ = run("002/002_112_*", setup)
    assert state["air_wand:wandtask3"] == "1" and "pal|air_wand:wandtask3=1" in log


@needs_lua
def test_journals_ignore_task_flags_that_were_reset_to_zero():
    # a fresh stage zeroes every task flag; the journal must not claim they are done
    for rel, quest, cls, stage in (("004/004_49_*", "air_wand", "sorcerer", 3), ("004/004_53_*", "phase_mace", "cleric", 2)):
        task = "wandtask" if "wand" in quest else "macetask"
        zeros = "\n".join(f"qv['{quest}:{task}{n}'] = 0" for n in range(1, 7))
        setup = (
            f'arg = "{quest.replace("_wand", "").replace("phase_mace", "spirit mace")} wand"\nactor.class = "{cls}"; actor.level = 60\n'
            f"qstage['{quest}'] = {stage}\nqv['{quest}:greet'] = 1\n{zeros}\n"
        )
        if quest == "phase_mace":
            setup = setup.replace('arg = "spirit mace wand"', 'arg = "spirit mace"')
        log, _, _ = run(rel, setup)
        out = sent(log)
        assert not any("You've done the following" in line for line in out), out
        assert any(line.startswith("- ") and "find" in line for line in out), out


@needs_lua
def test_mace_journal_waits_for_the_dirt_at_step_two():
    done = "\n".join(f"qv['phase_mace:macetask{n}'] = 1" for n in range(1, 6))
    setup = (
        'arg = "spirit mace"\nactor.class = "cleric"; actor.level = 60\nqstage["phase_mace"] = 2\n'
        f"qv['phase_mace:greet'] = 1\n{done}\n"
    )
    out = sent(run("004/004_53_*", setup)[0])
    assert not any(line.startswith("Bring") for line in out)
    assert any("find OBJ[185,25]" in line for line in out)


@needs_lua
def test_wand_journal_names_the_zone_117_gem_correctly():
    setup = (
        'arg = "air wand"\nactor.class = "sorcerer"; actor.level = 100\nqstage["air_wand"] = 10\nqv["air_wand:greet"] = 1\n'
    )
    out = sent(run("004/004_49_*", setup)[0])
    assert any("find OBJ[117,111]" in line for line in out), out


# ---- Black Legion: the engine's quest names are case-sensitive --------------------------------------


@needs_lua
def test_black_legion_scripts_agree_on_one_lowercase_quest_name():
    # fierymud-rs keys quest storage on the exact text ("quest:<name>:stage", "quest:<name>:var:<key>"),
    # so Black_Legion and black_legion were two quests; legacy matched names case-insensitively.
    found = set()
    for path in TRIGGERS.rglob("*.lua"):
        text = path.read_text(encoding="utf-8")
        for m in re.finditer(r'(?:get_quest_stage|start_quest|set_quest_var|get_quest_var)\("([A-Za-z_]*[Ll]egion[A-Za-z_]*)', text):
            found.add(m.group(1))
        assert "Black_Legion" not in text.replace("-- ", ""), path
        assert not re.search(r'"(BL|EG)_FACTION"', text), path
    assert found == {"black_legion"}


@needs_lua
@pytest.mark.parametrize("rel", ["041/041_17_*", "055/055_17_*"])
def test_faction_status_shows_zero_for_an_unset_faction(rel):
    out = sent(run(rel, 'speech = "faction status"')[0])
    assert any("Faction with The Black Legion: 0" in line for line in out), out
    out = sent(run(rel, 'speech = "faction status"\nqv["black_legion:bl_faction"] = 7\nqv["black_legion:bl_ally"] = 1')[0])
    assert any("Faction with The Black Legion: 7" in line for line in out) and any("pledged to the Black" in line for line in out)
