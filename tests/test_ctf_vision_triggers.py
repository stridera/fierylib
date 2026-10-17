"""Monk vision (53:42) and the capture-the-flag tag triggers (188:80, 188:97).

The real trigger files and the `dg` library run in a Lua 5.4 interpreter
against fake rooms and fake players. The sandbox only knows the standard
library plus the names the engine binds for a COMMAND trigger, so a script
that reads any other global fails the test. Rooms are compared by their
(zone_id, local_id), the way the engine hands them out.
"""

import shutil
import subprocess
from pathlib import Path

import pytest

LUA = shutil.which("lua5.4") or shutil.which("lua")
needs_lua = pytest.mark.skipif(LUA is None, reason="lua not installed")

ROOT = Path(__file__).resolve().parents[1]
TRIGGERS = ROOT / "data" / "triggers"

HARNESS = r"""
local ROOT = @ROOT@
local VISION = ROOT .. "/data/triggers/053/053_42_monk_vision_command_read.lua"
local ARMBAND = ROOT .. "/data/triggers/188/188_80_ctf_armband_tag.lua"
local BAT = ROOT .. "/data/triggers/188/188_97_fierytag_bat_capturetheflag.lua"
local PASS = ROOT .. "/data/triggers/188/188_82_ctf_flag_pass.lua"
local DEPOSIT = ROOT .. "/data/triggers/519/519_65_academy_revel_command_deposit.lua"

local SAFE = { "assert", "error", "getmetatable", "ipairs", "math", "next",
    "pairs", "pcall", "select", "setmetatable", "string", "table", "tonumber",
    "tostring", "type", "utf8" }

local waits = nil  -- set by a scenario: called on every wait()

local function sandbox(extra)
    local env = {}
    for _, k in ipairs(SAFE) do env[k] = _G[k] end
    for k, v in pairs(extra or {}) do env[k] = v end
    return setmetatable(env, { __index = function(_, k)
        error("read of undefined global '" .. tostring(k) .. "'", 2)
    end })
end

local function slurp(path)
    local f = assert(io.open(path))
    local src = f:read("a")
    f:close()
    return src
end

local libs = {}
local function require_(name)
    if libs[name] == nil then
        local path = ROOT .. "/data/script_libraries/" .. name .. ".lua"
        libs[name] = assert(load(slurp(path), "lib:" .. name, "t", sandbox()))()
    end
    return libs[name]
end

-- Rooms by (zone, id); only the ones a scenario creates exist.
local rooms = {}
local function room(zone, id)
    local key = zone .. ":" .. id
    if not rooms[key] then
        local r = { zone_id = zone, local_id = id, id = id, actors = {},
            log = {}, spawned = {} }
        function r:send_except(who, msg)
            self.log[#self.log + 1] = { except = who, msg = msg }
        end
        function r:spawn_object(z, i)
            self.spawned[#self.spawned + 1] = z .. ":" .. i
            return {}
        end
        function r:find_actor(word)
            for _, a in ipairs(self.actors) do
                if a.name:lower() == word:lower() then return a end
            end
            return nil
        end
        rooms[key] = r
    end
    return rooms[key]
end
local function get_room(zone, id) return rooms[zone .. ":" .. id] end

local function put(actor, r)
    if actor.room then
        for i, a in ipairs(actor.room.actors) do
            if a == actor then table.remove(actor.room.actors, i) break end
        end
    end
    actor.room = r
    r.actors[#r.actors + 1] = actor
end

local cmds = {}  -- queued actor:command() lines, in order
local destroyed = {}  -- handles given to world.destroy()
local allowed = false  -- set by allow_command()

local function player(name, gender, r)
    local a = { name = name, gender = gender, level = 30, is_player = true,
        is_npc = false, is_fighting = false, log = {}, items = {}, worn = {},
        quest = {}, stage = {},
        objective = gender == "female" and "her" or "him",
        possessive = gender == "female" and "her" or "his" }
    function a:send(msg) self.log[#self.log + 1] = msg end
    function a:teleport(r2) put(self, r2) end
    function a:command(line) cmds[#cmds + 1] = { who = self, line = line } end
    function a:heal(n) self.healed = n end
    function a:has_item(z, i) return self.items[z .. ":" .. i] == true end
    function a:has_equipped(z, i) return self.worn[z .. ":" .. i] == true end
    function a:get_quest_stage(q) return self.stage[q] or 0 end
    function a:get_quest_var(k) return self.quest[k] end
    function a:set_quest_var(q, k, v) self.quest[q .. ":" .. k] = v end
    function a:advance_quest(q) self.stage[q] = (self.stage[q] or 0) + 1 end
    put(a, r)
    return a
end

local function wear(a, zone, id) a.worn[zone .. ":" .. id] = true end

-- An object trigger holder: the thing the trigger file is attached to.
local function thing(zone, id, shortdesc)
    return { zone_id = zone, id = id, local_id = id, shortdesc = shortdesc,
        name = shortdesc, globals = {}, log = {} }
end

local function fire(path, self, actor, cmd, arg, location)
    local env = sandbox({
        actor = actor, self = self, globals = self.globals,
        location = location or "equip", cmd = cmd, arg = arg or "",
        require = require_, get_room = get_room,
        world = { destroy = function(x) destroyed[#destroyed + 1] = x end },
        allow_command = function() allowed = true end,
        wait = function(n)
            if waits then waits(n) end
        end,
    })
    local chunk = assert(load(slurp(path), "@" .. path, "t", env))
    return chunk()
end

local function has(actor, text)
    for _, line in ipairs(actor.log) do
        if line:find(text, 1, true) then return true end
    end
    return false
end
local function check(cond, msg)
    if not cond then error("CHECK FAILED: " .. tostring(msg), 2) end
end
local function echoed(r, text)
    for _, e in ipairs(r.log) do
        if e.msg:find(text, 1, true) then return true end
    end
    return false
end
local function queued(who, line)
    for _, c in ipairs(cmds) do
        if c.who == who and c.line == line then return true end
    end
    return false
end
local function at(a, zone, id)
    return a.room.zone_id == zone and a.room.local_id == id
end
"""


def run_lua(scenario: str) -> None:
    code = (
        HARNESS.replace("@ROOT@", f'"{ROOT}"') + scenario + '\nprint("OK")\n'
    )
    r = subprocess.run([LUA, "-"], input=code, capture_output=True, text=True)
    assert r.returncode == 0 and r.stdout.strip().endswith("OK"), (
        r.stderr + r.stdout
    )


VISION_SETUP = r"""
-- The first Sight (590:6) is read in room 4328 = (43, 28) at stage 1, with
-- gem 555:82 carried and the previous Sight 2:190 worn.
local place = room(43, 28)
local elsewhere = room(43, 29)
local monk = player("Monk", "male", place)
monk.stage.monk_vision = 1
monk.items["555:82"] = true
wear(monk, 2, 190)
local item = thing(590, 6, "the Sight of Dreams")
local function read() return fire(VISION, item, monk, "read", "") end
"""


@needs_lua
def test_vision_read_completes_the_task_after_four_waits():
    run_lua(VISION_SETUP + r"""
    local n = 0
    waits = function() n = n + 1 end
    check(read() == false, "the command is consumed")
    check(n == 4, "four waits, got " .. n)
    check(has(monk, "You begin to read the Sight of Dreams..."), "begin")
    local cont = 0
    for _, l in ipairs(monk.log) do
        if l:find("You continue to read...", 1, true) then cont = cont + 1 end
    end
    check(cont == 3, "three continue lines, got " .. cont)
    check(has(monk, "You feel your awareness broadening!"), "done")
    check(monk.quest["monk_vision:visiontask4"] == 1, "task recorded")
    """)


@needs_lua
def test_vision_read_uses_each_items_own_place_stage_gem_and_sight():
    run_lua(VISION_SETUP + r"""
    -- the ninth Sight (584:12): room 52075 = (520, 75), stage 9, gem 557:41,
    -- previous Sight 2:198
    local r9 = room(520, 75)
    local m9 = player("Nine", "female", r9)
    m9.stage.monk_vision = 9
    m9.items["557:41"] = true
    wear(m9, 2, 198)
    local sight9 = thing(584, 12, "the ninth Sight")
    check(fire(VISION, sight9, m9, "read", "") == false, "read starts")
    check(m9.quest["monk_vision:visiontask4"] == 1, "ninth task done")
    -- the first Sight does not work in the ninth room
    local m1 = player("One", "male", r9)
    m1.stage.monk_vision = 1
    m1.items["555:82"] = true
    wear(m1, 2, 190)
    check(fire(VISION, item, m1, "read", "") == true, "wrong place")
    """)


@needs_lua
def test_vision_read_passes_through_unless_everything_lines_up():
    run_lua(VISION_SETUP + r"""
    put(monk, elsewhere)
    check(read() == true, "wrong room passes the command on")
    put(monk, place)
    monk.stage.monk_vision = 2
    check(read() == true, "wrong stage")
    monk.stage.monk_vision = 1
    monk.items["555:82"] = nil
    check(read() == true, "no gem")
    monk.items["555:82"] = true
    monk.worn["2:190"] = nil
    check(read() == true, "previous Sight not worn")
    check(#monk.log == 0, "no messages while not ready")
    check(fire(VISION, item, monk, "look", "") == true, "other commands")
    check(fire(VISION, item, monk, "read", "", "room") == true, "on floor")
    check(fire(VISION, thing(1, 1, "x"), monk, "read", "") == true,
        "not a Sight")
    """)


@needs_lua
def test_vision_read_stops_when_done_fighting_or_moved():
    run_lua(VISION_SETUP + r"""
    monk.quest["monk_vision:visiontask4"] = 1
    check(read() == false, "already done")
    check(has(monk, "already expanded your mind"), "done message")
    monk.quest["monk_vision:visiontask4"] = nil

    monk.is_fighting = true
    check(read() == false, "fighting at the start")
    check(has(monk, "cannot properly focus"), "fight message")
    monk.is_fighting = false
    monk.log = {}

    -- walks away during the first wait
    local n = 0
    waits = function() n = n + 1 if n == 1 then put(monk, elsewhere) end end
    check(read() == false, "left before the first pause ended")
    check(has(monk, "must be in the proper place"), "place message")
    check(monk.quest["monk_vision:visiontask4"] == nil, "no credit")
    put(monk, place)
    monk.log = {}

    -- fights during the third wait
    n = 0
    waits = function() n = n + 1 if n == 3 then monk.is_fighting = true end end
    check(read() == false, "fight in the loop")
    check(has(monk, "cannot properly focus"), "loop fight message")
    check(monk.quest["monk_vision:visiontask4"] == nil, "no credit after fight")
    """)


CTF_SETUP = r"""
-- Team A (armband 188:80, home zone 3500-3599, flag room 3500 = (35, 0),
-- jail 188:80) against team B (armband 188:81, home zone 8000-8199, jail
-- 188:81).
local jail_a = room(188, 80)
local jail_b = room(188, 81)
local home_a = room(35, 0)       -- 3500
local home_b = room(80, 25)      -- 8025
local flag_room_b = room(80, 50) -- 8050
local field = room(35, 5)        -- 3505, inside zone A
local far = room(30, 9)          -- 3009, nobody's zone here
local band_a = thing(188, 80, "a red armband")
local band_b = thing(188, 81, "a blue armband")

local ann = player("Ann", "female", field)
wear(ann, 188, 80)
local bob = player("Bob", "male", field)
wear(bob, 188, 81)
local cat = player("Cat", "female", field)
wear(cat, 188, 80)

local function tag(who, band, arg) return fire(ARMBAND, band, who, "tag", arg) end

-- Deliver the commands queued with actor:command(), as the engine would: a
-- "tag X" typed by a player fires that player's armband.
local bands = { [ann] = band_a, [bob] = band_b, [cat] = band_a }
local function flush()
    local todo = cmds
    cmds = {}
    for _, c in ipairs(todo) do
        local arg = c.line:match("^tag (.+)$")
        if arg and bands[c.who] then
            fire(ARMBAND, bands[c.who], c.who, "tag", arg)
        end
    end
end
"""


@needs_lua
def test_armband_tag_sends_an_enemy_in_your_zone_to_your_jail():
    run_lua(CTF_SETUP + r"""
    check(tag(ann, band_a, "bob") == false, "consumed")
    check(at(bob, 188, 80), "Bob is in Ann's jail (team A jail)")
    check(at(ann, 35, 5), "Ann stays put")
    check(has(bob, "Ann tags you, sending you to her jail!"), "to the victim")
    check(has(ann, "You tag Bob, sending him to your jail!"), "to the tagger")
    check(echoed(field, "Ann tags Bob, sending him to jail!"), "room echo")
    check(echoed(jail_a, "Bob appears in a bright flash of light!"), "arrival")
    check(queued(bob, "tag DeactivateArmband"), "armband forced off")
    flush()
    check(band_b.globals.inactive == "yes", "Bob's armband is inactive")
    -- an inactive armband cannot tag
    tag(bob, band_b, "ann")
    check(has(bob, "Sorry, you can't tag anyone right now!"), "inactive")
    """)


@needs_lua
def test_armband_tag_outside_your_zone_has_no_effect():
    run_lua(CTF_SETUP + r"""
    put(ann, far)
    put(bob, far)
    tag(ann, band_a, "Bob")
    check(has(ann, "Tagging Bob has no effect outside your zone!"), "no effect")
    check(at(bob, 30, 9), "Bob not moved")
    """)


@needs_lua
def test_armband_tag_team_b_uses_its_own_zone_and_jail():
    run_lua(CTF_SETUP + r"""
    local b_field = room(80, 40)   -- 8040, inside zone B
    put(ann, b_field)
    put(bob, b_field)
    tag(bob, band_b, "ann")
    check(at(ann, 188, 81), "Ann goes to the team B jail")
    tag(ann, band_a, "bob")
    """)


@needs_lua
def test_armband_tag_rescues_a_teammate_from_jail():
    run_lua(CTF_SETUP + r"""
    put(ann, jail_b)
    put(cat, jail_b)
    check(tag(ann, band_a, "cat") == false, "consumed")
    check(at(cat, 35, 0) and at(ann, 35, 0), "both back at the team A home")
    check(has(cat, "Ann tags you, rescuing you from jail!"), "rescued")
    check(has(ann, "You tag Cat, rescuing her from jail!"), "tagger")
    check(queued(cat, "tag ReactivateArmband"), "armband switched back on")
    flush()
    check(band_a.globals.inactive == "no", "armband active again")
    """)


@needs_lua
def test_armband_tag_teammate_messages_and_enemy_in_a_jail():
    run_lua(CTF_SETUP + r"""
    tag(ann, band_a, "cat")
    check(has(ann, "Cat doesn't need saving in your own zone!"), "own zone")
    put(ann, far)
    put(cat, far)
    tag(ann, band_a, "cat")
    check(has(ann, "Cat doesn't need saving right now!"), "elsewhere")
    -- an enemy standing in the enemy jail goes to ours, the tagger home
    put(ann, jail_b)
    put(bob, jail_b)
    tag(ann, band_a, "bob")
    check(at(bob, 188, 80), "Bob banished to the team A jail")
    check(at(ann, 35, 0), "Ann sent home")
    check(has(bob, "banishing you for jail-guarding!"), "victim message")
    -- an enemy in your own jail is already there
    put(ann, jail_a)
    put(bob, jail_a)
    tag(ann, band_a, "bob")
    check(has(ann, "Bob is already in your jail!"), "already in jail")
    """)


@needs_lua
def test_armband_tag_enemy_flag_carrier_returns_the_flag():
    run_lua(CTF_SETUP + r"""
    wear(bob, 188, 83)   -- the blue flag
    tag(ann, band_a, "bob")
    check(queued(bob, "remove ctf-flag"), "flag taken off")
    check(home_a.spawned[1] == "188:82", "red flag back in Ann's flag room")
    check(at(ann, 35, 5), "Ann returns to where she tagged")
    """)


@needs_lua
def test_armband_tag_refusals():
    run_lua(CTF_SETUP + r"""
    tag(ann, band_a, "self")
    check(has(ann, "no point to that"), "self")
    tag(ann, band_a, "Ann")
    check(has(ann, "no point to that"), "own name")
    ann.log = {}
    tag(ann, band_a, "nobody")
    check(has(ann, "Tag whom?  They're not here!"), "not here")
    ann.log = {}
    tag(ann, band_a, "")
    check(has(ann, "Tag whom?"), "no argument")
    bob.level = 100
    tag(ann, band_a, "bob")
    check(has(ann, "not very nice to tag immortals"), "immortal")
    bob.level = 30
    wear(ann, 188, 82)
    tag(ann, band_a, "bob")
    check(has(ann, "You cannot tag someone while holding the flag!"), "flag")
    ann.worn["188:82"] = nil
    local dan = player("Dan", "male", field)
    tag(ann, band_a, "dan")
    check(has(ann, "Dan doesn't seem to be playing."), "no armband")
    local mob = player("Goblin", "male", field)
    mob.is_player, mob.is_npc, mob.zone_id, mob.id = false, true, 7, 1
    tag(ann, band_a, "goblin")
    check(has(ann, "You can only tag players!"), "other mob")
    -- the referee (mob 188:80) wearing an armband can be tagged
    mob.zone_id, mob.id = 188, 80
    wear(mob, 188, 81)
    tag(ann, band_a, "goblin")
    check(at(mob, 188, 80), "referee sent to jail")
    check(tag(ann, band_a, "x") == false and fire(ARMBAND, band_a, ann,
        "look", "") == true, "only tag is consumed")
    fire(ARMBAND, band_a, ann, "tag", "", "inventory")
    """)


BAT_SETUP = r"""
-- Males: home zone 3000-3199, jail 3009, home room 3054. Females: zone
-- 8000-8199, jail 8133, home 8049. Neutral: zone 3500-3699, jail 3514,
-- home 3500.
local m_jail, m_home = room(30, 9), room(30, 54)
local f_jail, f_home = room(80, 133), room(80, 49)
local n_jail, n_home = room(35, 14), room(35, 0)
local m_zone = room(30, 20)        -- 3020, male zone
local f_zone = room(80, 20)        -- 8020, female zone
local neutral_zone = room(35, 20)  -- 3520
local bat = thing(188, 97, "a FieryTag bat")
local function tag(who, arg) return fire(BAT, bat, who, "tag", arg) end

local al = player("Al", "male", m_zone)
local bo = player("Bo", "male", m_zone)
local cy = player("Cy", "female", m_zone)
"""


@needs_lua
def test_fierytag_tag_opponent_in_home_zone_sends_to_jail():
    run_lua(BAT_SETUP + r"""
    check(tag(al, "cy") == false, "consumed")
    check(at(cy, 30, 9), "Cy is in the male jail")
    check(queued(cy, "remove fiery-tag-bat"), "bat removed")
    check(queued(cy, "junk fiery-tag-bat"), "bat junked")
    check(has(cy, "Al tags you, sending you to jail!"), "victim")
    check(has(al, "You tag Cy, sending her to jail!"), "tagger")
    check(echoed(m_zone, "Al tags Cy!  To jail Cy goes!"), "room")
    -- female team: home zone 8000-8199, jail 8133
    put(al, f_zone)
    put(cy, f_zone)
    tag(cy, "al")
    check(at(al, 80, 133), "Al in the female jail")
    -- neutral team
    local ne = player("Ne", "neutral", neutral_zone)
    local nf = player("Nf", "female", neutral_zone)
    tag(ne, "nf")
    check(at(nf, 35, 14), "Nf in the neutral jail")
    """)


@needs_lua
def test_fierytag_rescue_teammate_from_opponent_jail():
    run_lua(BAT_SETUP + r"""
    put(al, f_jail)
    put(bo, f_jail)
    tag(al, "bo")
    check(at(bo, 30, 54) and at(al, 30, 54), "both at the male home")
    check(f_jail.spawned[1] == "188:97", "a bat appears for the rescued")
    check(bo.healed == 10, "healed")
    check(queued(bo, "wake") and queued(bo, "get fiery-tag-bat"), "wakes")
    check(has(bo, "Al tags you, rescuing you from your imprisonment!"), "msg")
    check(has(al, "You tag Bo, rescuing him from his imprisonment!"), "tagger")
    """)


@needs_lua
def test_fierytag_teammate_in_own_jail_goes_home_and_other_messages():
    run_lua(BAT_SETUP + r"""
    -- in the tagger's own jail a teammate is sent home
    put(al, m_jail)
    put(bo, m_jail)
    tag(al, "bo")
    check(at(bo, 30, 54) and at(al, 30, 54), "both home")
    check(has(bo, "Al tags you, returning you to home!"), "message")
    -- an opponent in the tagger's own jail is already there
    put(al, m_jail)
    put(cy, m_jail)
    tag(al, "cy")
    check(has(al, "is already in your jail."), "already")
    -- teammate in the home zone
    put(al, m_zone)
    put(bo, m_zone)
    tag(al, "bo")
    check(has(al, "But you're in your own zone!  Bo is on your team!"), "home")
    -- teammate away from home, not in jail
    put(al, f_zone)
    put(bo, f_zone)
    tag(al, "bo")
    check(has(al, "Bo doesn't need rescuing right now."), "not jailed")
    -- opponent away from home
    put(cy, f_zone)
    al.log = {}
    tag(al, "cy")
    check(has(al, "No point in tagging her if you're not in your zone."), "away")
    """)


@needs_lua
def test_fierytag_refusals():
    run_lua(BAT_SETUP + r"""
    tag(al, "self")
    check(has(al, "a little pointless"), "self")
    tag(al, "Al")
    check(has(al, "a little pointless"), "own name")
    tag(al, "nobody")
    check(has(al, "Tag who? They don't seem to be here!"), "absent")
    put(cy, f_zone)
    tag(al, "cy")
    check(has(al, "Tag who? They don't seem to be here!"), "other room")
    put(cy, m_zone)
    cy.level = 100
    tag(al, "cy")
    check(has(al, "You cannot tag immortals!"), "immortal")
    local mob = player("Goblin", "male", m_zone)
    mob.is_player, mob.is_npc = false, true
    tag(al, "goblin")
    check(has(al, "You can only tag players!"), "mob")
    check(fire(BAT, bat, al, "look", "") == true, "other commands")
    check(fire(BAT, bat, al, "tag", "cy", "room") == true, "on the floor")
    """)


def test_fixed_triggers_are_marked_clean_and_fit_79_columns():
    files = [
        TRIGGERS / "053" / "053_42_monk_vision_command_read.lua",
        TRIGGERS / "188" / "188_80_ctf_armband_tag.lua",
        TRIGGERS / "188" / "188_97_fierytag_bat_capturetheflag.lua",
    ]
    for path in files:
        text = path.read_text(encoding="utf-8")
        assert "-- Status: CLEAN" in text, path.name
        assert "TODO(parity)" not in text, path.name
        long = [
            n for n, line in enumerate(text.splitlines(), 1) if len(line) > 79
        ]
        assert not long, (path.name, long)


PASS_SETUP = r"""
local field = room(35, 5)
local home_a = room(35, 0)
local home_b = room(80, 50)
local ann = player("Ann", "female", field)
local bob = player("Bob", "male", field)
local cat = player("Cat", "female", field)
local dan = player("Dan", "male", field)
wear(ann, 188, 80)   -- team A
wear(bob, 188, 80)   -- team A
wear(cat, 188, 81)   -- team B
-- Dan wears no armband
local flag = thing(188, 83, "the blue flag")  -- team B's flag, carried by Ann
local function pass(arg) return fire(PASS, flag, ann, "pass", arg) end
"""


@needs_lua
def test_flag_pass_finds_the_target_in_the_room_and_hands_off_to_a_teammate():
    # playtest r14 B6: `arg.room` was read off the typed string, so every pass
    # answered "They're not here!".
    run_lua(PASS_SETUP + r"""
    check(pass("flag Bob") == false, "consumed")
    check(not has(ann, "They're not here!"), "Bob is found in the room")
    check(has(bob, "Ann quickly passes the blue flag to you."), "to the receiver")
    check(has(ann, "You slyly hand off the blue flag to Bob."), "to the passer")
    check(echoed(field, "Ann quietly passes a flag to Bob."), "room echo")
    check(field.spawned[1] == "188:83", "a fresh flag lands in the room")
    check(queued(bob, "get ctf-flag"), "Bob picks it up")
    check(destroyed[1] == flag, "the passed flag is gone")
    """)


@needs_lua
def test_flag_pass_accepts_the_name_alone_in_any_case():
    run_lua(PASS_SETUP + r"""
    check(pass("BOB") == false, "consumed")
    check(has(bob, "Ann quickly passes the blue flag to you."), "to the receiver")
    """)


@needs_lua
def test_flag_pass_to_the_other_team_resets_the_flag_at_its_home_room():
    run_lua(PASS_SETUP + r"""
    check(pass("flag cat") == false, "consumed")
    check(has(ann, "You accidentally pass the flag to Cat, resetting it."), "message")
    check(home_b.spawned[1] == "188:83", "team B's flag returns to team B's flag room")
    check(#home_a.spawned == 0, "not to the other team's room")
    check(destroyed[1] == flag, "the passed flag is gone")
    check(#field.spawned == 0, "nothing lands in the field")
    """)


@needs_lua
def test_flag_pass_refusals():
    run_lua(PASS_SETUP + r"""
    local away = player("Eve", "female", room(35, 6))
    wear(away, 188, 80)
    pass("flag Eve")
    check(has(ann, "Pass the flag to whom?  They're not here!"), "not in the room")
    pass("flag self")
    check(has(ann, "There's really no point to that, now is there?"), "self")
    pass("flag Ann")
    check(has(ann, "There's really no point to that, now is there?"), "own name")
    pass("flag Dan")
    check(has(ann, "Dan doesn't seem to be playing."), "no armband")
    bob.level = 105
    pass("flag Bob")
    check(has(ann, "You can't pass to an immortal!"), "immortal")
    local rat = { name = "a rat", level = 3, is_player = false, is_npc = true,
        zone_id = 30, id = 7, send = function() end,
        has_equipped = function() return false end }
    field.actors[#field.actors + 1] = rat
    pass("flag rat")
    -- find_actor() matches by exact name in this fake, so no mob is found
    check(#destroyed == 0 and #field.spawned == 0, "nothing was passed")
    -- another command and a flag on the floor are left alone
    check(fire(PASS, flag, ann, "get", "flag") == true, "other command passes through")
    check(fire(PASS, flag, ann, "pass", "flag Bob", "room") == true, "not worn")
    """)


DEPOSIT_SETUP = r"""
local hall = room(519, 7)
local revel = thing(519, 8, "the Master of the Revel")
local pip = player("Pip", "male", hall)
pip.stage.school = 5
pip.quest["school:money"] = 1
pip.quest["school:rest"] = "complete"
local function deposit(arg) allowed = false return fire(DEPOSIT, revel, pip, "deposit", arg) end
"""


@needs_lua
def test_deposit_lesson_advances_after_a_deposit_the_command_accepts():
    # playtest r14 B2: the lesson asked for "deposit 1 gold 1 silver 1 copper",
    # which the command rejects, and advanced anyway.
    run_lua(DEPOSIT_SETUP + r"""
    deposit("1 gold")
    check(allowed, "the real command runs")
    check(pip.quest["school:money"] == "complete", "money lesson done")
    check(has(pip, "Thank you for using Academy Bank."), "thanks")
    check(pip.stage.school == 6, "rest was already done: ready to graduate")
    check(has(pip, "Say finish"), "graduate prompt")
    """)


@needs_lua
def test_deposit_lesson_does_not_advance_on_a_usage_error():
    run_lua(DEPOSIT_SETUP + r"""
    for _, bad in ipairs({ "1 gold 1 silver 1 copper", "", "gold", "lots", "0",
        "1 gold silver", "5 shillings", "-3" }) do
        deposit(bad)
        check(allowed, "the real command still runs: " .. bad)
        check(pip.quest["school:money"] == 1, "still open: " .. bad)
        check(pip.stage.school == 5, "no advance: " .. bad)
        check(not has(pip, "Thank you"), "no thanks: " .. bad)
    end
    check(has(pip, "Name one amount, like <b:green>deposit 1 gold</>"), "hint")
    """)


@needs_lua
def test_deposit_lesson_accepts_every_form_the_command_accepts():
    run_lua(DEPOSIT_SETUP + r"""
    for _, good in ipairs({ "1 gold", "1gold", "1g", "100", "10 silver", "ALL",
        "5 Copper", "  2 gol  ", "all" }) do
        pip.quest["school:money"] = 1
        pip.stage.school = 5
        pip.log = {}
        deposit(good)
        check(pip.quest["school:money"] == "complete", "accepted: " .. good)
    end
    """)


@needs_lua
def test_deposit_lesson_ignores_amounts_beyond_the_lesson_purse():
    run_lua(DEPOSIT_SETUP + r"""
    deposit("1 platinum")
    check(pip.quest["school:money"] == 1, "1 platinum is more than the 5g5s5c purse")
    check(pip.stage.school == 5, "no advance")
    """)


@needs_lua
def test_deposit_outside_the_lesson_is_untouched():
    run_lua(DEPOSIT_SETUP + r"""
    pip.quest["school:money"] = nil
    check(deposit("1 gold") == true, "plain command passes through")
    check(not allowed and #pip.log == 0, "no lesson output")
    check(pip.stage.school == 5, "no advance")
    """)


def test_money_lesson_teaches_a_deposit_the_command_accepts():
    text = (TRIGGERS / "519" / "519_92_academy_revel_speech_money.lua").read_text()
    assert "deposit 1 gold</>" in text
    assert "1 silver 1 copper" not in text
    assert "platinum] [amount] gold" not in text


def test_graduation_no_longer_promises_a_level_command_that_advances():
    text = (TRIGGERS / "519" / "519_73_academy_revel_speech_finish.lua").read_text()
    assert "to advance to the next level" not in text
    assert "until you do" not in text
    assert "automatically" in text


def test_graduation_directions_have_no_legacy_newline_codes():
    # playtest r14 B3: "&_" is the legacy colour code for a newline; the engine has no & layer.
    text = (TRIGGERS / "519" / "519_73_academy_revel_speech_finish.lua").read_text()
    assert "&_" not in text
    assert 'for step in string.gmatch(direction2, "[^\\n]+")' in text
