-- Command-trigger fixes, round 2 (fierymud-rs trigger dispatch).
--
-- ORDER: apply AFTER 2026-10-10-command-trigger-default.sql (and trigger-api-fixes.sql). Bodies are
-- the data/triggers/*.lua text the importer would write, so the earlier patches' edits are included.
--
-- 1. allow_command() before the first wait in 11 COMMAND scripts whose legacy DG runs `return 0` and
--    then `wait` (15/3, 51/19, 62/13, 87/2, 123/23, 185/66, 200/38, 390/4, 484/19, 550/41, 580/107).
--    The command goes ahead and the script keeps running; without it a script that reaches wait()
--    consumes the typed command. Needs the fierymud-rs build that binds allow_command().
-- 2. OBJECT COMMAND location guards (the numeric DG argument is the OCMD_* mask): percent gates of
--    49/3, 49/4, 49/6, 49/7, 237/90 and 390/4 replaced, 32 more scripts that never got a guard.
-- 3. 51/19 and 237/90 no longer re-issue their own command (endless recursion); 580/107 target check.
--
-- After applying, reload the catalog: `treload` in game or POST /api/admin/triggers/reload.
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/001/001_29_unused.lua
  (1, 29, $trig$-- Converted from DG Script #129: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: hi
if not (cmd == "hi") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value$trig$),
  -- data/triggers/001/001_30_unused.lua
  (1, 30, $trig$-- Converted from DG Script #130: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: p
if not (cmd == "p") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value$trig$),
  -- data/triggers/001/001_31_unused.lua
  (1, 31, $trig$-- Converted from DG Script #131: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: for
if not (cmd == "for") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value$trig$),
  -- data/triggers/001/001_32_unused.lua
  (1, 32, $trig$-- Converted from DG Script #132: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: se
if not (cmd == "se") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value$trig$),
  -- data/triggers/002/002_109_phase_wand_command_imbue.lua
  (2, 109, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

if cmd ~= "imbue" then
    return true
end
return true$trig$),
  -- data/triggers/002/002_120_phase_mace_dig_trigger.lua
  (2, 120, $trig$-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: dig (block "d" / "di" abbreviations)
if cmd == "d" or cmd == "di" then
    return true
end
if cmd ~= "dig" then
    return true
end
if actor:get_quest_stage("phase_mace") ~= 2 then
    return true
end
if actor:get_quest_var("phase_mace:graves") == "done" then
    actor:send("<b:yellow>You have already completed your pilgrimage.</>")
    return true
end
local room = actor.room
local dig, item, num
-- Graveyard*
if room.id >= 47000 and room.id <= 47404 then
    dig, item, num = "yes", 22, 3
-- Cathedral*
elseif room.id >= 8504 and room.id <= 8509 then
    dig, item, num = "yes", 23, 4
-- Pyramid*
elseif room.id >= 16200 and room.id <= 16299 then
    dig, item, num = "yes", 24, 5
-- Barrow*
elseif room.id >= 48000 and room.id <= 48099 then
    dig, item, num = "yes", 25, 6
end
if dig == "yes" then
    actor:send("You dig up a handful of dirt.")
    self.room:spawn_object(185, item)
    actor:set_quest_var("phase_mace", "dirt" .. tostring(num), 1)
    actor:command("get dirt")
    local dirt3 = actor:get_quest_var("phase_mace:dirt3")
    local dirt4 = actor:get_quest_var("phase_mace:dirt4")
    local dirt5 = actor:get_quest_var("phase_mace:dirt5")
    local dirt6 = actor:get_quest_var("phase_mace:dirt6")
    if dirt3 and dirt4 and dirt5 and dirt6 then
        if not actor:get_quest_var("phase_mace:graves") then
            actor:send("<b:yellow>You have completed your pilgrimage.</>")
            actor:set_quest_var("phase_mace", "graves", "done")
        end
    end
else
    actor:send("This isn't the proper place to dig for grave dirt.")
end
return true$trig$),
  -- data/triggers/012/012_03_nexus_clock_pin_reload.lua
  (12, 3, $trig$-- Converted from DG Script #1203: nexus_clock_pin_reload
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: Rock well demon
if not (cmd == "Rock" or cmd == "well" or cmd == "demon") then
    return true  -- Not our command
end
self.room:spawn_object(12, 3)
self.room:send("The &9<blue>Nexus</> <red>Cloak</> &9<blue>Pin</> beings to <b:blue>gl<b:cyan>ow</> mysteriously then fades back to normal.")
world.destroy(self)$trig$),
  -- data/triggers/015/015_03_wear_membership_ring_and_portal_opens.lua
  (15, 3, $trig$if cmd ~= "wear" then
    return true
end

-- Legacy `return 0` ahead of the wait: the typed command goes ahead and the script carries on.
allow_command()
wait(2)
if actor:has_equipped(15, 0) then
    if not globals.wof_exit then
        globals.wof_exit = true
        wait(4)
        self.room:send_except(actor, tostring(actor.name) .. "'s <magenta>Soul Gem</> begins to glow.")
        actor:send("Your <magenta>Soul Gem</> begins to glow.")
        self.room:send("A light shimmering develops to the east, and resolves itself into a portal.")
        get_room(390, 23):exit("east"):set_state({hidden = false})
        get_room(390, 23):exit("east"):set_state({description = "A slowly shimmering portal leads east."})
        wait(8)
        self.room:send("The shimmering of the eastern exit is a bit faster now.")
        wait(8)
        self.room:send("The eastern portal is positively spinning, and seems to be fading.")
        wait(4)
        self.room:send("There is a sharp *snap* and the portal collapses into nothingness.")
        get_room(390, 23):exit("east"):set_state({hidden = true})
        get_room(390, 23):exit("east"):set_state({description = "The Blue Fog Sea rolls on to the East."})
        globals.wof_exit = false
    end
end
return true$trig$),
  -- data/triggers/018/018_03_fountain_whisper.lua
  (18, 3, $trig$-- Converted from DG Script #1803: fountain_whisper
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
if random(1, 100) > 75 then
    self.room:send("The wind whispers, 'Please... help us!'")
end
return true$trig$),
  -- data/triggers/022/022_80_dual_axe_blur_script.lua
  (22, 80, $trig$-- Converted from DG Script #2280: dual_axe_blur_script
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- TODO(parity): original DG #2280 (dual axe blur) had only a placeholder body
-- ("My trigger commandlist is not complete!") — needs full implementation
-- (e.g. blur effect, extra attack on command "Niamh"). Placeholder kept verbatim.
-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: Niamh
if not (cmd == "Niamh") then
    return true  -- Not our command
end
self:say("My trigger commandlist is not complete!")$trig$),
  -- data/triggers/028/028_09_unused.lua
  (28, 9, $trig$if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

return true$trig$),
  -- data/triggers/030/030_296_make_fountain_heal.lua
  (30, 296, $trig$-- Converted from DG Script #3296: Make_Fountain_heal
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if arg == "pool" or arg == "granite" then
    actor:heal(400)
    _return_value = true
end
return _return_value$trig$),
  -- data/triggers/049/049_03_td_ab_normalizer.lua
  (49, 3, $trig$-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

if cmd ~= "ca" then
    return true
end

return true$trig$),
  -- data/triggers/049/049_04_td_ab_capture.lua
  (49, 4, $trig$-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

if cmd ~= "capture" then
    return true
end

local team = self.state and self.state.team
if team and team ~= "" then
    actor:command("xcapture T" .. tostring(team) .. "T")
    return false  -- consume the player's command
end

return true$trig$),
  -- data/triggers/049/049_06_td_py_normalize.lua
  (49, 6, $trig$-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

if cmd ~= "xcaptur" then
    return true
end

return true$trig$),
  -- data/triggers/049/049_07_td_py_capture.lua
  (49, 7, $trig$-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

if cmd ~= "xcapture" then
    return true
end

if not arg or arg == "" then
    return true
end

self.state = self.state or {}
local pylonname = self.state.pylonname or "Caelian Pylon"
local pylon = self.state.pylon or 0
local teams = self.state.teams or (globals.teams or 4)

-- Parse "T<team>T" out of arg.
local team_idx = tonumber(string.match(arg, "T(%d+)T"))
if not team_idx or team_idx < 0 or team_idx >= teams then
    return true
end

local candidate = self.state.candidate
local owner = self.state.owner

if candidate == team_idx then
    -- Same team is already counting down; remind them.
    local timeout = self.state.timeout or 0
    local seconds = timeout * 12
    actor:send("Your team will capture this " .. pylonname
               .. " in " .. seconds .. " seconds!")
elseif owner == team_idx then
    if candidate then
        -- Owner returns mid-attempt and disrupts the rival capture.
        actor:send("You touch the " .. pylonname
                   .. ", canceling team " .. tostring(candidate)
                   .. "'s attempt to capture your " .. pylonname .. "!")
        self.room:send_except(actor, tostring(actor.name)
                              .. " touches the " .. pylonname
                              .. ", disrupting its pulsing.")
        local mc = self.room:find_actor("teamdominationmc")
        if mc then
            mc:command("say TDCommand Cancel T" .. team_idx
                       .. "T P" .. pylon .. "P")
        end
        self.state.candidate = nil
    else
        actor:send("But your team already controls this " .. pylonname .. "!")
    end
else
    -- New countdown.
    local timeout = 4
    self.state.timeout = timeout
    self.state.candidate = team_idx
    local seconds = timeout * 12
    actor:send("You touch the " .. pylonname .. ", and it starts pulsating.")
    actor:send("Your team will capture this " .. pylonname
               .. " in " .. seconds .. " seconds!")
    self.room:send_except(actor, tostring(actor.name)
                          .. " touches the " .. pylonname
                          .. ", and it starts pulsating.")
    local mc = self.room:find_actor("teamdominationmc")
    if mc then
        mc:command("say TDCommand Countdown T" .. team_idx
                   .. "T P" .. pylon .. "P")
    end
end

return false  -- consume the relayed command$trig$),
  -- data/triggers/051/051_19_lantern_shows_the_path.lua
  (51, 19, $trig$-- Converted from DG Script #5119: lantern shows the path
-- Original: WORLD trigger, flags: COMMAND, probability: 0%
--
-- "look lantern" (any abbreviation of `lantern`) -- the stone lantern
-- emits a glow that briefly reveals a hidden west exit from 580/1 to
-- 580/17, then fades and clears the exit destination again.
--
-- Note: legacy DG header listed probability 0%, but command triggers in
-- DG fired on every keyword match regardless of header probability --
-- the converter's percent_chance(0) gate has been removed.

-- Command filter: look <lantern abbreviation>
if cmd ~= "look" then
    return true  -- Not our command
end
local arg_lower = string.lower(arg or "")
if not (#arg_lower > 0 and string.find("lantern", "^" .. arg_lower)) then
    return true  -- Not looking at the lantern
end
local entry = get_room(580, 1)
local west = entry:exit("west")
local hidden_break = get_room(580, 17)

-- The typed `look lantern` goes ahead (legacy forced the actor to look and blocked the typed
-- line; re-issuing it from here fired this trigger again, without end).
allow_command()
self.room:send_except(actor, actor.name .. " looks at the stone lantern.")
wait(2)
self.room:send("An eerie <b:yellow>glow</> begins emitting from the lantern...")
wait(5)
west:set_destination(hidden_break)
self.room:send("The light reveals a well-concealed break in the rocky hills to the west!")
wait(20)
self.room:send("The light begins to flicker and fade...")
wait(5)
west:set_destination(nil)
self.room:send("The passage west is obscured again as the glow of the lantern fades.")
return true$trig$),
  -- data/triggers/062/062_13_supernova_gateway_enter_command.lua
  (62, 13, $trig$-- The DG numeric argument 4 is the OCMD_* location mask (the gateway on the floor), not a
-- probability; the old synthetic `percent_chance(4)` gate is replaced by the location guard.

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: enter
if cmd ~= "enter" then
    return true  -- Not our command
end
if not (arg == "r" or arg == "ri" or arg == "rin" or arg == "ring"
   or arg == "g" or arg == "ga" or arg == "gat" or arg == "gate"
   or arg == "gatew" or arg == "gatewa" or arg == "gateway") then
    return true  -- Not the ring / gateway: legacy `default: return 0`
end
if not (actor:has_item(510, 73) or actor:has_equipped(510, 73)) then
    actor:send("The gateway is inactive.")
    return false  -- legacy `return 1`
end
actor:send("The gateway draws power from " .. tostring(objects.template(510, 73).name) .. " and activates!")
-- Legacy `return 0` ahead of the wait: the typed command goes ahead and the script carries on.
allow_command()
wait(2)
self.room:send("The gateway folds in on itself and collapses!")
world.destroy(self)
return true$trig$),
  -- data/triggers/087/087_02_drag_the_handcart.lua
  (87, 2, $trig$-- Converted from DG Script #8702: drag the handcart
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- Command location mask 4: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drag
if not (cmd == "drag") then
    return true  -- Not our command
end
-- Legacy `return 0` ahead of the wait: the typed command goes ahead and the script carries on.
allow_command()
wait(1)
if string.find(arg, "cart") or string.find(arg, "wagon") then
    actor:send("The handcart creaks along behind you.")
    self.room:send_except(actor, "The handcart creaks along behind " .. tostring(actor.name) .. ".")
    -- TODO(parity): legacy compared actor.room == 8711 (DG vnum). Confirm intended room
    -- is (zone 87, id 11) and adjust this check if mapping differs.
    if actor.room.zone_id == 87 and actor.room.local_id == 11 then
        wait(1)
        self.room:find_actor("blacksmith"):command("blink " .. tostring(actor.name))
        self.room:find_actor("blacksmith"):emote("rubs his eyes in disbelief.")
        actor:send("The blacksmith says, 'Oh it's you, you found the handcart, thank the gods!'")
        wait(1)
        self.room:find_actor("blacksmith"):spawn_object(87, 0)
        actor:send("The blacksmith says, 'I must reward such heroism, and I know just the thing.'")
        self.room:find_actor("blacksmith"):command("give axe " .. tostring(actor.name))
        self.room:find_actor("blacksmith"):emote("moves the handcart into a bay near his tools.")
        world.destroy(self)
    elseif random(1, 6) == 3 then
        actor:send("<green>You hear a rustling in the grass nearby.</>")
        wait(1)
        self.room:spawn_mobile(87, 13)
        self.room:find_actor("bandit"):command("kill " .. tostring(actor.name))
        self.room:spawn_mobile(87, 13)
        self.room:find_actor("bandit"):command("kill " .. tostring(actor.name))
    end
end
return true$trig$),
  -- data/triggers/087/087_10_ambush.lua
  (87, 10, $trig$-- Converted from DG Script #8710: ambush
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drag
if not (cmd == "drag") then
    return true  -- Not our command
end
self.room:send("checking..")
if random(1, 10) < 2 then
    self.room:send("proc")
end$trig$),
  -- data/triggers/123/123_23_megalith_quest_mother_act_kneel_rewards.lua
  (123, 23, $trig$-- Converted from DG Script #12323: megalith_quest_mother_act_kneel_rewards
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kneel
if not (cmd == "kneel") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- Legacy `return 0` comes first: the typed kneel always goes ahead.
_return_value = true
allow_command()
wait(2)
local bad1 = (actor:get_quest_var("megalith_quest:bad1") == 1) and 1 or 0
local bad2 = (actor:get_quest_var("megalith_quest:bad2") == 1) and 1 or 0
local bad3 = (actor:get_quest_var("megalith_quest:bad3") == 1) and 1 or 0
if actor:get_quest_stage("megalith_quest") == 5 then
    local total = bad1 + bad2 + bad3
    if total == 0 then
        actor:send(tostring(self.name) .. " gently leans forward and kisses your brow.")
        self.room:send_except(actor, tostring(self.name) .. " gently leans forward and kisses " .. tostring(actor.name) .. "'s brow.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you the gifts of stars.  May their light")
        self.room:send("</>guide you the rest of your days.'")
        self.room:spawn_object(123, 98)
        self.room:spawn_object(123, 99)
        self:command("give belt-stars " .. tostring(actor.name))
        self:command("give starseed " .. tostring(actor.name))
        local gem = 0
        while gem < 3 do
            -- TODO(parity): the original drop pool used legacy 5-digit
            -- vnums 55736..55747. After the (zone, local_id) split, this
            -- gem set should live at zone 557 ids 36..47. Verify.
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor.name))
    elseif total > 0 then
        actor:send(tostring(self.name) .. " places her hand on your shoulder.")
        self.room:send_except(actor, tostring(self.name) .. " places her hand on " .. tostring(actor.name) .. "'s shoulder.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I bestow upon you a gift of stars.  May its light")
        self.room:send("</>guide you the rest of your days.'")
        local pick = random(1, 2)
        if pick == 1 then
            self.room:spawn_object(123, 98)
        elseif pick == 2 then
            self.room:spawn_object(123, 99)
        end
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 36 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all " .. tostring(actor.name))
        wait(4)
        self:command("bow " .. tostring(actor.name))
    end
    -- Clear all the Bads, just in case.
    for slot = 1, 5 do
        actor:set_quest_var("megalith_quest", "bad" .. tostring(slot), 0)
    end
    actor:complete_quest("megalith_quest")
    -- Set X to the level of the award.
    local expcap
    if actor.level < 70 then
        expcap = actor.level
    else
        expcap = 70
    end
    local expmod
    if expcap < 9 then
        expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        expmod = 8640 + ((expcap - 48) * 300)
    else
        expmod = 20940 + ((expcap - 89) * 600)
    end
    -- Adjust exp award by class so all classes receive the same proportionate amount.
    if actor.class == "Warrior" or actor.class == "Berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif actor.class == "Necromancer" or actor.class == "Monk" then
        -- 130% of standard
        expmod = expmod + (expmod * 2) / 5
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 10 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
end
return _return_value$trig$),
  -- data/triggers/125/125_13_red_wall.lua
  (125, 13, $trig$-- Converted from DG Script #12513: Red_wall
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = false
local which = random(1, 10)
if which == 4 then
    actor:send("You feel a burning sensation, but push through!")
    self.room:send_except(actor, tostring(actor.name) .. " pushes through the red field!")
    actor:teleport(get_room(126, 8))
    actor:command("look")
else
    actor:damage(75)  -- type: fire
    if damage_dealt == 0 then
        _return_value = false
    else
        -- TODO(parity): on damage hit, original sets _return_value=true (allow default west).
        -- That contradicts the flavor message ("forced back"). Confirm legacy intent.
        _return_value = true
        actor:send("The red field burns you, and you are forced back! (<red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, tostring(actor.name) .. " is forced back by the red field. (<red>" .. tostring(damage_dealt) .. "</>)")
    end
end
return _return_value$trig$),
  -- data/triggers/125/125_14_blue_field.lua
  (125, 14, $trig$-- Converted from DG Script #12514: Blue_field
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
actor:damage(115)  -- type: shock
if damage_dealt == 0 then
    _return_value = true
else
    _return_value = false
    actor:send("The blue field shocks you, flinging you back into the room! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
    self.room:send_except(actor, tostring(actor.name) .. " is forced back by the blue field. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
end
return _return_value$trig$),
  -- data/triggers/133/133_29_heavens_gate_key_seal.lua
  (133, 29, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: seal
if cmd ~= "seal" then
    return true
end

if not (string.find(arg, "rift") or string.find(arg, "portal")
     or string.find(arg, "pool") or string.find(arg, "arch")) then
    return true
end

if actor:get_quest_stage("heavens_gate") ~= 3 then
    return true
end

local room_legacy_id = self.room.zone_id * 100 + self.room.local_id

local anomaly_rooms = {
    [51077] = "arch",
    [16407] = "arch",
    [16094] = "portal",
    [55735] = "portal",
    [49024] = "energy",
    [55126] = "energy",
    [55112] = "energy",
}

local anomaly_keyword = anomaly_rooms[room_legacy_id]
if not anomaly_keyword then
    actor:send("There are no active rifts here to seal.")
    return true
end

local room_var = "heavens_gate:" .. tostring(room_legacy_id)
if actor:get_quest_var(room_var) then
    actor:send("You have already sealed this anomaly.")
    return true
end

actor:set_quest_var("heavens_gate", tostring(room_legacy_id), 1)
actor:send("You begin to chant...")
self.room:send_except(actor, tostring(actor.name) .. " begins to chant...")
actor:send("The power of the heavens courses through " .. tostring(self.shortdesc) .. ".")
wait(2)
self.room:send(tostring(self.shortdesc) .. " begins to burn with a fierce energy!")
wait(2)
self.room:send("Brilliant rays of light shoot out of " .. tostring(self.shortdesc) .. ", sealing the dimensional portal!")

world.destroy(self.room:find_object(anomaly_keyword))

-- Special case: Nordus seals also sweep the room contents to (510, 3).
if room_legacy_id == 51077 then
    self.room:teleport_all(get_room(510, 3))
end

local sealed = (actor:get_quest_var("heavens_gate:sealed") or 0) + 1
actor:set_quest_var("heavens_gate", "sealed", sealed)
wait(1)

-- Each step appends one more chunk of the cipher to be revealed.
local phrase_steps = {
    "yamo lv",
    "yamo lv soeeiy",
    "yamo lv soeeiy vrtvln",
    "yamo lv soeeiy vrtvln eau okia khz",
    "yamo lv soeeiy vrtvln eau okia khz lrrvzryp",
    "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj",
    "yamo lv soeeiy vrtvln eau okia khz lrrvzryp gvxrj bzjbie hi",
}

local phrase = phrase_steps[sealed]
if phrase then
    actor:send("As the rift collapses, words float up in your mind:")
    actor:send("<b:white>" .. phrase .. "</>")
end

if sealed == 7 then
    wait(2)
    local room = get_room(133, 58)
    actor:send("<b:white>A vision of starlight beckons you back to " .. tostring(room.name) .. ".</>")
    actor:advance_quest("heavens_gate")
end

return true$trig$),
  -- data/triggers/185/185_66_kneel_door_open.lua
  (185, 66, $trig$if not (cmd == "kneel") then
    return true
end
-- Legacy `return 0` ahead of the wait: the typed command goes ahead and the script carries on.
allow_command()

if actor.alignment > -349 then
    actor:send("A bright white beam of light descends upon you.")
    self.room:send_except(actor, "A bright beam of white light descends upon " .. tostring(actor.name) .. ".")
    local west = get_room(185, 66):exit("west")
    west:set_state({has_door = true})
    west:set_state({hidden = false})
    west:set_state({name = "large wooden door"})
    west:set_state({description = "A large wooden door bars your way."})
    wait(3)
    actor:send("A door in the cross to the west opens silently.")
    self.room:send_except(actor, "A door in the cross to the west opens silently.")
else
    actor:send("A bright white beam of light descends upon you.")
    self.room:send_except(actor, "A bright beam of white light descends upon " .. tostring(actor.name) .. ".")
    wait(2)
    actor:send("The light becomes increasingly bright, and turns painful!")
    actor:damage(179)
    self.room:send_except(actor, "The light brightens significantly, burning " .. tostring(actor.name) .. "'s skin.")
end
return true$trig$),
  -- data/triggers/200/200_35_bread_purge.lua
  (200, 35, $trig$-- Converted from DG Script #20035: bread_purge
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: CURSED!
if not (cmd == "CURSED!") then
    return true  -- Not our command
end
self:destroy_item("bread")$trig$),
  -- data/triggers/200/200_38_drink_fountain.lua
  (200, 38, $trig$-- Converted from DG Script #20038: drink_fountain
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drink
if not (cmd == "drink") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
allow_command()  -- the drink goes ahead; the choking below follows the wait
wait(1)
if actor.level < 99 then
    actor:damage(50)  -- type: physical
    self.room:send_except(actor, tostring(actor.name) .. " is caught in a fit of choking. (<red>" .. tostring(damage_dealt) .. "</>)")
    actor:send("You are caught in a fit of choking. (<red>" .. tostring(damage_dealt) .. "</>)")
end
return _return_value$trig$),
  -- data/triggers/237/237_90_recall_nymrill.lua
  (237, 90, $trig$-- Converted from DG Script #23790: recall_nymrill
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%
-- Black potion of recall. Evil-aligned drinkers (alignment <= -350) recall to a
-- class-appropriate Nymrill room and the potion is consumed. Other drinkers get a
-- flavor message and the quaff proceeds.
-- The DG numeric argument 2 is the OCMD_* location mask (carried), not a 2% chance. Legacy
-- re-issued `quaff black-potion-recall` for the non-evil drinker while also blocking the typed
-- one, which fired this trigger again without end; the typed quaff is now simply let through.

-- Command location mask 2: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: quaff
if cmd ~= "quaff" then
    return true  -- Not our command
end

if not actor.is_player then
    return true  -- the quaff goes ahead
end

if actor.alignment <= -350 then
    actor:send("You quaff a potion and begin to feel a little light-headed...")
    self.room:send_except(actor, tostring(actor.name) .. " quaffs a black potion of recall.")
    self.room:send_except(actor, tostring(actor.name) .. " disappears in a flash of darkness!")
    if string.find(actor.class, "Thief") or string.find(actor.class, "Assassin") or string.find(actor.class, "Mercenary") or string.find(actor.class, "Rogue") then
        actor:teleport(get_room(495, 25))
    elseif string.find(actor.class, "Sorcerer") or string.find(actor.class, "Cryomancer") or string.find(actor.class, "Pyromancer") then
        actor:teleport(get_room(495, 22))
    elseif string.find(actor.class, "Necromancer") then
        actor:teleport(get_room(495, 14))
    else
        actor:teleport(get_room(495, 12))
    end
    actor:command("look")
    world.destroy(self)
    return false
end

actor:send("As you quaff a potion, you get a funny burning sensation in your stomach...")
return true  -- the quaff goes ahead$trig$),
  -- data/triggers/302/302_06_try_to_drag_exploding_bag_bang.lua
  (302, 6, $trig$-- Makes the red leather bag explode if you try to drag it.
-- Applied to: o30209

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drag (must be the full word, not a prefix-match like 'd')
if cmd ~= "drag" then
    return true  -- Not our command
end
self.room:send_except(actor, tostring(actor.alias) .. " reaches for " .. tostring(self.shortdesc) .. ", but it suddenly <b:red>explodes!</>")
actor:send("As you reach for " .. tostring(self.shortdesc) .. ", it suddenly <b:red>explodes!</>")
local damage = actor.level * 3 + random(1, 19)
local damage_dealt = actor:damage(damage)  -- type: slash
if damage_dealt == 0 then
    self.room:send_except(actor, "Shards of metal fly right by " .. tostring(actor.name) .. "!")
    actor:send("Shards of metal fly by!  Luckily, none of them hit you!")
else
    self.room:send_except(actor, "Shards of metal hit " .. tostring(actor.alias) .. " in the legs, causing serious wounds! (<red>" .. tostring(damage_dealt) .. "</>)")
    actor:send("OUCH!  The shards cut your legs painfully! (<red>" .. tostring(damage_dealt) .. "</>)")
end
world.destroy(self)
return false  -- Block the drag command$trig$),
  -- data/triggers/302/302_07_unused.lua
  (302, 7, $trig$-- Allows normal use of 'd' command around red leather bag (it intercepts
-- the "drag" command in trigger 30206).
-- Applied to: o30209

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: d
if cmd ~= "d" then
    return true  -- Not our command
end
return true$trig$),
  -- data/triggers/364/364_05_illusory_wall_glasses_examine.lua
  (364, 5, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: examine (full word; ignore the standalone "e" abbrev)
if cmd ~= "examine" then
    return true
end
-- DG passed `arg` to mean "user supplied an argument"; if so, leave to default.
if arg and arg ~= "" then
    return true
end

-- Zone -> region key. Legacy zones grouped by area name.
local ZONE_TO_REGION = {
    [16]  = "Outback",
    [18]  = "Shadows",
    [20]  = "Merchant",
    [23]  = "Caelia_West", [24] = "Caelia_West", [25] = "Caelia_West",
    [26]  = "Caelia_West", [27] = "Caelia_West",
    [28]  = "River",
    [30]  = "Mielikki", [31] = "Mielikki", [32] = "Mielikki",
    [33]  = "Mielikki", [34] = "Mielikki", [53] = "Mielikki",
    [35]  = "Mielikki_Forest", [36] = "Mielikki_Forest", [37] = "Mielikki_Forest",
    [40]  = "Labyrinth",
    [41]  = "Split", [42] = "Split",
    [43]  = "Theatre",
    [51]  = "Rocky_Tunnels",
    [52]  = "Lava",
    [54]  = "Misty", [127] = "Misty", [128] = "Misty", [361] = "Misty",
    [55]  = "Combat",
    [60]  = "Anduin", [61] = "Anduin", [62] = "Anduin",
    [69]  = "Pastures",
    [70]  = "Great_Road",
    [73]  = "Nswamps",
    [80]  = "Farmlands", [81] = "Farmlands", [82] = "Farmlands",
    [83]  = "Frakati",
    [85]  = "Cathedral",
    [86]  = "Meercats",
    [87]  = "Logging",
    [88]  = "Dairy",
    [100] = "Ickle",
    [102] = "Frostbite",
    [103] = "Phoenix",
    [117] = "Blue_Fog_Trail", [118] = "Blue_Fog_Trail", [119] = "Blue_Fog_Trail",
    [120] = "Twisted", [121] = "Twisted", [122] = "Twisted",
    [123] = "Megalith", [124] = "Megalith",
    [125] = "Tower", [126] = "Tower",
    [133] = "Miner",
    [136] = "Morgan",
    [160] = "Mystwatch", [164] = "Mystwatch",
    [161] = "Desert",
    [162] = "Pyramid",
    [163] = "Highlands",
    [169] = "Haunted",
    [172] = "Citadel",
    [173] = "Chaos",
    [178] = "Canyon",
    [180] = "Topiary",
    [185] = "Abbey",
    [203] = "Plains",
    [237] = "Dheduu",
    [238] = "Dargentan",
    [300] = "Ogakh", [301] = "Ogakh",
    [302] = "Bluebonnet",
    [324] = "Caelia_East", [325] = "Caelia_East",
    [350] = "Brush", [351] = "Brush",
    [360] = "Kaaz",
    [362] = "SeaWitch", [411] = "SeaWitch", [412] = "SeaWitch",
    [363] = "Smuggler",
    [364] = "Sirestis",
    [365] = "Ancient_Ruins",
    [370] = "Minithawkin",
    [390] = "Arabel", [391] = "Arabel",
    [410] = "Hive",
    [430] = "Demise", [431] = "Demise", [432] = "Demise",
    [462] = "Nukreth",
    [464] = "Aviary",
    [470] = "Graveyard", [471] = "Graveyard", [472] = "Graveyard",
    [473] = "Graveyard", [474] = "Graveyard",
    [476] = "Earth",
    [477] = "Water",
    [478] = "Fire",
    [480] = "Barrow",
    [481] = "Fiery", [482] = "Fiery",
    [484] = "Doom",
    [488] = "Air",
    [489] = "Lokari",
    [490] = "Griffin", [491] = "Griffin",
    [492] = "BlackIce",
    [495] = "Nymrill",
    [502] = "Bayou",
    [510] = "Nordus", [511] = "Nordus",
    [520] = "Templace",
    [530] = "Sunken", [531] = "Sunken", [532] = "Sunken",
    [533] = "Cult",
    [534] = "Frost", [535] = "Frost",
    [550] = "Technitzitlan", [551] = "Technitzitlan",
    [552] = "Black_Woods",
    [553] = "Kaas_Plains",
    [554] = "Dark_Mountains",
    [555] = "Cold_Fields",
    [556] = "Iron",
    [557] = "Blackrock",
    [558] = "Eldorian", [559] = "Eldorian",
    [564] = "Blacklake",
    [580] = "Odz", [581] = "Odz", [582] = "Odz",
    [583] = "Syric",
    [584] = "KoD", [585] = "KoD",
    [586] = "Beachhead", [587] = "Beachhead",
    [588] = "Ice_Warrior", [589] = "Ice_Warrior",
    [590] = "Haven",
    [615] = "Hollow",
    [625] = "Rhell",
}

local room = self.room
local region = ZONE_TO_REGION[room.zone_id]
if not region then
    return true
end

if actor:get_quest_stage("illusory_wall") ~= 2 or actor:get_has_completed("illusory_wall") then
    return true
end

-- TODO(parity): legacy DG only credits a room if it has at least one DOOR-flag
-- exit in every cardinal direction (n/s/e/w/u/d). The runtime exit API we
-- currently expose does not expose the DOOR flag in a uniform way, so for now
-- we credit the room if it has any closeable exit. Once `exit:has_door()` (or
-- equivalent) lands, gate this check on it.
local has_any_door = false
for _, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
    local ex = room["exit_" .. dir] or (room.exit and room:exit(dir))
    if ex then has_any_door = true; break end
end
if not has_any_door then
    return true
end

local region_key = "illusory_wall:" .. region
if actor:get_quest_var(region_key) then
    actor:send("<b:white>You have already learned all you can from this region.</>")
    return true
end

actor:set_quest_var("illusory_wall", region, 1)
local clue = (actor:get_quest_var("illusory_wall:total") or 0) + 1
actor:send("<b:white>You begin to analyze the room.</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:yellow>Analyzing...</>")
wait(3)
actor:send("<b:cyan>You gain more insight on doors and barriers!</>")
actor:set_quest_var("illusory_wall", "total", clue)

if clue >= 20 then
    wait(2)
    self.room:spawn_mobile(364, 2)
    local lyara = self.room:find_actor("post-commander")
    if lyara then
        lyara:command("mskillset " .. tostring(actor.name) .. " illusory wall")
    end
    actor:send("<b:cyan>You have learned everything you need to cast illusory walls!</>")
    actor:complete_quest("illusory_wall")
    wait(1)
    if lyara then
        world.destroy(lyara)
    end
end
return true$trig$),
  -- data/triggers/390/390_04_flood_heart_speech.lua
  (390, 4, $trig$if cmd ~= "say" then
    return true
end
-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Legacy `return 0` ahead of the wait: the player's `say` goes ahead and the script carries on.
allow_command()
wait(2)
if actor:get_quest_stage("flood") == 1 then
    local room = actor.room
    local zone = room.id  -- TODO: should be a (zone_id, local_id) tuple
    if string.find(arg, "the Arabel ocean calls for aid") or string.find(arg, "spirit I have returned") or string.find(arg, "spirit, I have returned") then
        -- 
        -- for Blue-Fog River and Lake
        -- 
        if zone >= 2800 and zone <= 2910 then
            local color = "&4"
            local spirit = mobiles.template(390, 13).name
            if world.count_mobiles(390, 13) == 0 and not actor:get_quest_var("flood:water1") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 13)
                self.room:send(tostring(color) .. "A misty blue spirit rises from the water.</>")
            end
            -- 
            -- for Phoenix Feather Hot Springs
            -- 
        elseif zone == 10314 or zone == 10316 or zone >= 10318 and zone <= 10335 then
            local color = "&6"
            local spirit = mobiles.template(390, 14).name
            if world.count_mobiles(390, 14) == 0 and not actor:get_quest_var("flood:water2") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 14)
                self.room:send(tostring(color) .. "A shining watery bird rises from the water.</>")
            end
            -- 
            -- for Canyon - multiple lines because one is too long
            -- 
        elseif zone == 17802 or (zone >= 17811 and zone <= 17813) or zone == 17816 or zone == 17817 or (zone >= 17823 and zone <= 17827) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
        elseif zone == 17834 or (zone >= 17839 and zone <= 17841) or zone == 17847 or zone == 17850 or (zone >= 17853 and zone <= 17856) then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
        elseif zone == 17862 or zone == 17867 then
            local color = "&4&b"
            local spirit = mobiles.template(390, 15).name
            if world.count_mobiles(390, 15) == 0 and not actor:get_quest_var("flood:water3") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 15)
                self.room:send(tostring(color) .. "A three-faced humanoid figure rises from the water.</>")
            end
            -- 
            -- for Greengreen Sea
            -- 
        elseif zone >= 36200 and zone <= 36231 then
            local color = "&2"
            local spirit = mobiles.template(390, 16).name
            if world.count_mobiles(390, 16) == 0 and not actor:get_quest_var("flood:water4") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 16)
                self.room:send(tostring(color) .. "A hideous creature with distended mouth and belly rises from the water.</>")
            end
            -- 
            -- for SeaWitch
            -- 
        elseif zone >= 41100 and zone <= 41242 then
            local color = "&4&b"
            local spirit = mobiles.template(390, 17).name
            actor:send("Watery song whispers in your ear, " .. tostring(color) .. "'The Sea Witch must be removed before I may</>")
            actor:send("</>" .. tostring(color) .. "speak to thee...  Call to me from the bottom of the sea...'</>")
        elseif zone == 41243 then
            local color = "&4&b"
            local spirit = mobiles.template(390, 17).name
            if world.count_mobiles(411, 19) == 0 then
                if world.count_mobiles(390, 17) == 0 and not actor:get_quest_var("flood:water5") then
                    self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                    wait(1)
                    self.room:spawn_mobile(390, 17)
                    self.room:send(tostring(color) .. "The sea's currents noticeably ripple and flux in response.</>")
                end
            else
                actor:send(tostring(color) .. "Watery song whispers in your ear, 'The Sea Witch must be removed before I may</>")
                actor:send("</>" .. tostring(color) .. "speak to thee...'</>")
            end
            -- 
            -- for Frost Valley - two lines
            -- 
        elseif zone >= 53438 and zone <= 53440 or zone >= 53445 and zone <= 53449 or zone == 53452 or zone == 53455 or zone == 53456 or zone == 53464 then
            local color = "&7&b"
            local spirit = mobiles.template(390, 18).name
            if world.count_mobiles(390, 18) == 0 and not actor:get_quest_var("flood:water6") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 18)
                self.room:send(tostring(color) .. "A willowy white woman rises from the lake.</>")
            end
        elseif zone == 53467 or zone == 53468 or zone >= 53472 and zone <= 53475 or zone == 53481 or zone == 53482 then
            local color = "&7&b"
            local spirit = mobiles.template(390, 18).name
            if world.count_mobiles(390, 18) == 0 and actor:get_quest_var("flood:water6") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 18)
                self.room:send(tostring(color) .. "A willowy icy white woman rises from the lake.</>")
            end
            -- 
            -- for Black Lake
            -- 
        elseif (zone >= 56402 and zone <= 56404) or (zone >= 56406 and zone <= 56431) or zone == 37072 then
            local color = "&9&b"
            local spirit = mobiles.template(390, 19).name
            if world.count_mobiles(390, 19) == 0 and not actor:get_quest_var("flood:water7") then
                self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                wait(1)
                self.room:spawn_mobile(390, 19)
                self.room:send(tostring(color) .. "An inky black shade rises from the depths.</>")
            end
            -- 
            -- for KoD
            -- 
        elseif zone >= 58511 and zone <= 58519 then
            local color = "&6&b"
            local spirit = mobiles.template(390, 20).name
            if time.hour > 19 or time.hour < 5 then
                if world.count_mobiles(390, 20) == 0 and not actor:get_quest_var("flood:water8") then
                    self.room:send("<cyan>" .. tostring(self.shortdesc) .. " shimmers with pale light!</>")
                    wait(1)
                    self.room:spawn_mobile(390, 20)
                    self.room:send(tostring(color) .. "In a spray of moon-lit iridescent mist, a beautiful translucent blue woman emerges from the stream.</>")
                end
            else
                self.room:send("A giggling voice says, " .. tostring(color) .. "'None dream while the sun shines.'</>")
            end
        end
        wait(1)
        if string.find(arg, "the arabel ocean calls for aid") then
            self.room:find_actor("spirit"):command("mecho %spirit% says, color%'Why does the ocean call for aid?'&0")
        else
            self.room:find_actor("spirit"):command("mecho %spirit% says, color%'Do you have what I asked for?'&0")
        end
    end
end
return true$trig$),
  -- data/triggers/484/484_19_wild-hunt_deer_flee.lua
  (484, 19, $trig$-- Converted from DG Script #48419: wild-hunt deer flee
-- Original: MOB trigger, flags: GLOBAL, COMMAND, probability: 100%

-- Command filter: drop
if not (cmd == "drop") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- If drop the player is using the secret keyword to drop
-- the rag, flee!  Unfortunately, players can force the
-- deer to flee any time, so don't tell any of them this
-- keyword.
_return_value = true
allow_command()  -- legacy `return 0` ahead of the wait: the drop goes ahead
if actor:get_quest_stage("doom_entrance") and actor:get_quest_var("doom_entrance:wild_hunt") == 1 and arg == "ragtoscarewhitetaileddeer" then
    wait(1)
    local room = self.room
    while room == self.room do
        self:command("flee")
    end
end
return _return_value$trig$),
  -- data/triggers/488/488_10_mdamage.lua
  (488, 10, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: mdamage
if not (cmd == "mdamage") then
    return true  -- Not our command
end
if (actor.id > 0) and not actor:has_effect(Effect.Charm) then
    actor:damage(tonumber(arg) or 0)
end
return true$trig$),
  -- data/triggers/488/488_11_mheal.lua
  (488, 11, $trig$-- Command location mask 3: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip" or location == "inventory") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: mheal
if not (cmd == "mheal") then
    return true  -- Not our command
end
if (actor.id > 0) and not actor:has_effect(Effect.Charm) then
    actor:heal(tonumber(arg) or 0)
end
return true$trig$),
  -- data/triggers/550/550_30_unused.lua
  (550, 30, $trig$-- Converted from DG Script #55030: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: enter
if not (cmd == "enter") then
    return true  -- Not our command
end
-- 
-- Test trigger to see if checks can be done
-- before a player can enter a portal.
-- 
if actor:get_has_completed("doom_entrance") == "true" then
    self.room:send_except(actor, "Dude like disappears and stuff.")
    actor:send("You step through the portal.")
    actor:teleport(get_room(12, 10))
else
    self.room:send_except(actor, "Dude tries to enter... NOT.")
    actor:send("Hows about you complete the quest first?")
end$trig$),
  -- data/triggers/550/550_41_wizard_eye_shaman_sleep.lua
  (550, 41, $trig$-- Converted from DG Script #55041: wizard_eye_shaman_sleep
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: sleep
if not (cmd == "sleep") then
    return true  -- Not our command
end
if actor:get_quest_stage("wizard_eye") == 12 then
    allow_command()  -- legacy `return 0` ahead of the wait: the sleep goes ahead
    wait(1)
    actor:send("A hazy dreamscape appears before you.")
    -- (empty room echo)
    actor:send("The Great Snow Leopard comes into focus!")
    actor:send("The Great Snow Leopard says, 'Come, follow where I walk.'")
    wait(2)
    actor:send("The Great Snow Leopard leads you on a journey through crisp, cold, snowy mountains...")
    wait(3)
    actor:send("hot burning deserts, sweltering jungles of sweet scented flowers...")
    wait(3)
    actor:send("distant mysterious islands of alien sounds...")
    wait(3)
    actor:send("through cities of people speaking languages you do not understand...")
    wait(6)
    actor:send("Soaring through the open sky, the Great Snow Leopard roars to shake the heavens!")
    -- (empty room echo)
    actor:send("In the echoes of the roar, you can see shape distant lands!")
    actor:send("The nature of the spell becomes clear!")
    actor:complete_quest("wizard_eye")
    skills.set_level(actor, "wizard eye", 100)
    actor:send("<b:cyan>You have learned Wizard Eye!</>")
end
return true$trig$),
  -- data/triggers/580/580_107_sunbird_speech1_bow.lua
  (580, 107, $trig$-- Command filter: bow
if not (cmd == "bow") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true  -- legacy `return 0` before anything else
allow_command()
local target = string.lower(arg or "")
if target ~= "" and string.find(string.lower(self.name), target, 1, true) then
    wait(7)
    self:say("Through her holy benevolence, I once protected this entire island.")
    self.room:send("The Sunbird spreads its wings and begins to radiate a <b:white>glowing</> <blue><black>l</><b:white>i<b:yellow>g</><b:white>h</><blue><black>t.</>")
    wait(15)
    self.room:send("<b:white>The light grows...</>")
    wait(15)
    self.room:send("The light suddenly <b:white>FL</><b:yellow>AR</><b:white>ES!</>")
    wait(7)
    self.room:send("The Sunbird falters and stumbles before the altar.")
    wait(8)
    self:say("But now her divine presence has waned.")
    self:say("I can only shelter this small space near her shrine.")
    self:say("I fear something terrible has happened to her...")
end
return _return_value$trig$),
  -- data/triggers/590/590_02_glasscase_break.lua
  (590, 2, $trig$-- Converted from DG Script #59002: glasscase_break
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: break
if not (cmd == "break") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- you must break glass to get reset sword out
if arg == "glass" or arg == "case" then
    _return_value = false
    -- check to see what PC can break case with
    local item = nil
    if actor:get_worn("shield") then
        item = actor:get_worn("shield")
    elseif actor:get_worn("wield2h") then
        item = actor:get_worn("wield2h")
    elseif actor:get_worn("wield") then
        item = actor:get_worn("wield")
    elseif actor:get_worn("wield2") then
        item = actor:get_worn("wield2")
    elseif actor:get_worn("held") then
        item = actor:get_worn("held")
    elseif actor:get_worn("held2") then
        item = actor:get_worn("held2")
    end
    -- break case with item or hands
    if item then
        actor:send("You smash the glass with " .. tostring(item.shortdesc) .. " and the dusty case shatters into small pieces on the ground.")
        self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(item.shortdesc) .. " and the dusty case shatters into small pieces on the ground.")
    else
        actor:damage(150)  -- type: slash
        if damage_dealt ~= 0 then
            actor:send("You smash the glass with your bare hands, shattering the glass and slicing your hands. (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(actor.possessive) .. " bare hands, shattering the glass and slicing deep grooves into " .. tostring(actor.possessive) .. " hands. (<b:yellow>" .. tostring(damage_dealt) .. "</>)")
        else
            actor:send("You smash the glass with your bare hands.")
            self.room:send_except(actor, tostring(actor.name) .. " smashes the glass with " .. tostring(actor.possessive) .. " bare hands.")
        end
    end
    wait(1)
    self.room:send("A pristine iridescent sword falls out of the broken case, landing on the ground.")
    -- destroy case and load it in rm 59091 to prevent it from loading here again, as it is a reset item
    -- TODO(parity): both spawn calls reference (590, 24); original DG comment says one should
    -- spawn the iridescent sword in this room while the other respawns the glass case into 590/91.
    -- Verify the correct object IDs and target rooms before using in production.
    self.room:spawn_object(590, 24)
    world.destroy(self.room:find_object("dusty-glass-case"))
    self.room:spawn_object(590, 24)
else
    _return_value = true
end
return _return_value$trig$),
  -- data/triggers/590/590_03_rydack_test.lua
  (590, 3, $trig$-- Converted from DG Script #59003: Rydack_test
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- TODO(parity): original was a developer probe; logic and message text are
-- inconsistent (claims "not wearing shield" inside the wearing branch). Leave
-- as-is until intent is confirmed by the area author.

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: fire
if not (cmd == "fire") then
    return true  -- Not our command
end
local _return_value = false
if actor:get_worn("shield") then
    self.room:send("ok, not wearing shield")
    local shield_obj = actor:get_worn("shield")
    self.room:send(tostring(shield_obj))
end
return _return_value$trig$),
  -- data/triggers/590/590_04_glasscase_break_return0.lua
  (590, 4, $trig$-- Converted from DG Script #59004: glasscase_break_return0
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: brea
if not (cmd == "brea") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
-- returns normal value so nothing but break glass sets trigger off
return _return_value$trig$),
  -- data/triggers/590/590_49_unused.lua
  (590, 49, $trig$-- Converted from DG Script #59049: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: commun
if not (cmd == "commun") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value$trig$),
  -- data/triggers/615/615_38_cannot_drag_hanging_cherry.lua
  (615, 38, $trig$-- Converted from DG Script #61538: Cannot drag hanging cherry
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: drag
if not (cmd == "drag") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "d" then
    _return_value = true
    return _return_value
end
if string.find(arg, "purple") or string.find(arg, "cherry") then
    _return_value = false
    actor:send("You can't reach that high!")
else
    _return_value = true
end
return _return_value$trig$),
  -- data/triggers/615/615_39_unused.lua
  (615, 39, $trig$-- Converted from DG Script #61539: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: down
if not (cmd == "down") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value$trig$),
  -- data/triggers/615/615_95_lighting_a_string_of_firecrackers.lua
  (615, 95, $trig$-- Converted from DG Script #61595: Lighting a string of firecrackers
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: light
if not (cmd == "light") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if string.find(arg, "firework") or string.find(arg, "firecracker") or string.find(arg, "string") or string.find(arg, "firecrackers") then
    if globals.burning == 1 then
        _return_value = false
        actor:send("It's already lit!")
    elseif globals.on_ground == 0 then
        _return_value = false
        actor:send("To avoid being horribly disfigured by fire, dropping it first might be a good idea.")
    else
        _return_value = false
        globals.burning = 1
        self.room:send_except(actor, tostring(actor.name) .. " lights " .. tostring(self.shortdesc) .. ".")
        actor:send("You light " .. tostring(self.shortdesc) .. ".")
        wait(2)
        self.room:send("The fuse on " .. tostring(self.shortdesc) .. " burns slowly, giving off some smoke.")
        wait(1)
        local bangs = {
            "<blue>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <b:red>BANG!</>  <magenta>BANG!</>  <b:yellow>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>",
            "<b:blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <red>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:blue>BANG!</>",
            "<b:yellow>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>",
            "<b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <b:red>BANG!</>",
            "<b:magenta>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <red>BANG!</>",
            "<blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>",
            "<blue>BANG!</>  <yellow>BANG!</>  <b:blue>BANG!</>  <b:red>BANG!</>  <yellow>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>",
            "<b:red>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <red>BANG!</>  <blue>BANG!</>",
            "<b:magenta>BANG!</>  <b:red>BANG!</>  <b:red>BANG!</>  <b:blue>BANG!</>",
            "<b:red>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>",
            "<b:blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <b:magenta>BANG!</>",
            "<b:blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>",
            "<b:blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>",
            "<blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <blue>BANG!</>",
            "<b:yellow>BANG!</>  <b:blue>BANG!</>",
            "<b:blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>",
            "<yellow>BANG!</>  <red>BANG!</>  <red>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>",
            "<blue>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>",
            "<b:red>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <yellow>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>",
            "<b:blue>BANG!</>  <b:red>BANG!</>",
        }
        local counter = 20
        while counter > 0 do
            self.room:send(tostring(self.shortdesc) .. " explodes!")
            self.room:send(bangs[random(1, #bangs)])
            wait(3)
            counter = counter - 1
        end
        wait(1)
        self.room:send(tostring(self.shortdesc) .. " shoots out a few sputtering sparks.")
        world.destroy(self.name)
    end
else
    _return_value = true
end
return _return_value$trig$),
  -- data/triggers/615/615_98_roman_candle_normalizer.lua
  (615, 98, $trig$-- Converted from DG Script #61598: roman candle normalizer
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command location mask 100: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "room") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: ligh
if not (cmd == "ligh") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = true
return _return_value$trig$)
) AS v(zone_id, id, commands)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
