"""Behaviour of the hand-rebuilt quest triggers, run against a small mock of the trigger API.

Covers the Black Legion / Eldorian Guard turn-ins (041_03, 041_07, 055_03, 055_07), the Major Globe
journal (004_19) and the phase wand / mace questmasters (002_108, 002_114, 002_126). The mock keeps
quest variables the way the engine does (case-sensitive "quest:key" strings, numbers stay numbers),
records everything the script sends, spawns, destroys and commands, and dumps the final quest state.
"""

import shutil
import subprocess
from pathlib import Path

import pytest

LUA = shutil.which("lua5.4") or shutil.which("lua")
needs_lua = pytest.mark.skipif(LUA is None, reason="lua not installed")

TRIGGERS = Path(__file__).resolve().parent.parent / "data" / "triggers"

PREAMBLE = r"""
local log = {}
local function L(s) log[#log + 1] = s end
local qv, qstage, qdone = {}, {}, {}
local function key(a, b) if b == nil then return a end return a .. ":" .. b end

local actor = {name = "Hero", alignment = 0, level = 50, class = "cleric"}
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

local self = {name = "Mob", zone_id = 1, id = 1, room = {}}
function self.room:send(m) L("R|" .. m) end
function self:say(m) L("say|" .. m) end
function self:command(m) L("cmd|" .. m) end
function self:spawn_object(z, i) L("spawn|" .. z .. "|" .. i) end
function self:destroy_item(n) L("junk|" .. n) end
function self:set_flag(n, v) L("flag|" .. n .. "|" .. tostring(v)) end

local object = {zone_id = 1, id = 1, name = "a thing", shortdesc = "a thing"}
local globals = {}
local speech, arg = "", ""

local env = setmetatable({
    actor = actor, self = self, object = object, globals = globals,
    wait = function() end,
    world = {destroy = function(o) L("destroy|" .. tostring(o and o.name)) end},
    objects = {template = function(z, i) return {name = "OBJ[" .. z .. "," .. i .. "]"} end},
    mobiles = {template = function(z, i) return {name = "MOB[" .. z .. "," .. i .. "]"} end},
    get_room = function(z, i) return {name = "ROOM[" .. z .. "," .. i .. "]"} end,
    get_obj_noadesc = function(z, i) return "noa[" .. z .. "," .. i .. "]" end,
}, {__index = _G})

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
    chunk = PREAMBLE % {"setup": setup, "path": str(path)}
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
        'qstage["Black_Legion"] = 1',
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
    assert state["Black_Legion:" + ("bl_ally" if side == "bl" else "eg_ally")] == "1"
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
    assert "cmd|give all Hero" in log
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
    assert "cmd|give skull Hero" in log
    assert has(log, "to earn that reward")
    assert state[f"black_legion:{fvar}"] == "19"


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_unknown_item_is_not_interesting_and_handed_back(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    log, _, _ = run(rel, turnin_setup(side, align, (7, 7)))
    assert has(log, "I am not interested in this from you")
    assert "cmd|give skull Hero" in log
    assert not any(line.startswith(("spawn|", "exp|")) for line in log)


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_wrong_alignment_is_handed_back(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    log, state, _ = run(rel, turnin_setup(side, -align, trophy))
    assert "cmd|give skull Hero" in log
    assert has(log, "to earn our rewards")
    assert not state


@needs_lua
@pytest.mark.parametrize("rel, side, align, fvar, ovar, trophy, tkey, reward, cap", TURNINS, ids=IDS)
def test_maxed_faction_with_all_trophies_is_handed_back(rel, side, align, fvar, ovar, trophy, tkey, reward, cap):
    setup = turnin_setup(side, align, trophy, {f"black_legion:{fvar}": cap, f"black_legion:{tkey}_trophies": 10})
    log, state, _ = run(rel, setup)
    assert "cmd|give skull Hero" in log
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
    log, state, _ = run("055/055_03_*", turnin_setup("bl", -500, (55, 4), {"Black_Legion:eg_ally": 1}))
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
    assert "cmd|give all Hero" in log
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
    assert "cmd|give all Hero" in log
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
    assert "cmd|give all Hero" in log


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
    assert "cmd|give mace Hero" in log


@needs_lua
def test_mace_upgrade_when_everything_is_done():
    done = {"greet": 1, "macetask1": 1, "macetask2": 1, "macetask3": 1, "macetask4": 1, "macetask5": 1}
    log, state, stages = run("002/002_126_*", mace_setup(MACE1, (2, 140), 1, done))
    assert stages["phase_mace"] == "2"
    assert "spawn|2|141" in log
    assert "cmd|give mace Hero" in log
    # expcap 10: 1440 + (10 - 16) * 175 = 390, x10, ten awards
    assert log.count("exp|3900") == 10
    assert state["phase_mace:greet"] == "0" and state["phase_mace:macetask3"] == "0"


@needs_lua
def test_mace_before_the_other_materials_is_handed_back():
    log, _, _ = run("002/002_126_*", mace_setup(MACE1, (2, 140), 1, {"greet": 1, "macetask2": 1}))
    assert has(log, "Bring me the other materials first.")
    assert "cmd|give mace Hero" in log


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
