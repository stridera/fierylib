-- Trigger: Phase mace dig trigger
-- Zone: 2, ID: 120
-- Type: OBJECT, Flags: COMMAND
--
-- Provided by the grave-spade given out at macestep 2. Lets the wielder
-- `dig` in any of the four pilgrimage burial grounds (the necropolis near
-- Anduin, the Cathedral of Betrayal cemetery, the Gothra pyramid, and the
-- Iron Hills barrow) and harvest a handful of grave dirt. Once all four
-- dirt vars are set, the pilgrimage is marked done.
--
-- The burial grounds are tested on the legacy room numbers (zone * 100 + id) the DG script used:
-- the graveyard 47000-47404, the Cathedral cemetery 8504-8509, the Gothra pyramid 16200-16299
-- and the Iron Hills barrow 48000-48099. Each dig puts the matching dirt (185:22-25) in the pack.

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end
local dg = require("dg")

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
end
local room = actor.room
local here = room and dg.to_vnum(room.zone_id, room.id) or 0
local dig, item, num
if here >= 47000 and here <= 47404 then
    -- Graveyard
    dig, item, num = "yes", 22, 3
elseif here >= 8504 and here <= 8509 then
    -- Cathedral
    dig, item, num = "yes", 23, 4
elseif here >= 16200 and here <= 16299 then
    -- Pyramid
    dig, item, num = "yes", 24, 5
elseif here >= 48000 and here <= 48099 then
    -- Barrow
    dig, item, num = "yes", 25, 6
end
if dig == "yes" then
    actor:send("You dig up a handful of dirt.")
    actor:spawn_object(185, item)
    actor:set_quest_var("phase_mace", "dirt" .. tostring(num), 1)
    if dg.flag(actor:get_quest_var("phase_mace:dirt3")) and dg.flag(actor:get_quest_var("phase_mace:dirt4"))
            and dg.flag(actor:get_quest_var("phase_mace:dirt5")) and dg.flag(actor:get_quest_var("phase_mace:dirt6")) then
        if not actor:get_quest_var("phase_mace:graves") then
            actor:send("<b:yellow>You have completed your pilgrimage.</>")
            actor:set_quest_var("phase_mace", "graves", "done")
        end
    end
else
    actor:send("This isn't the proper place to dig for grave dirt.")
end
return false
