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
-- TODO(parity): room.id ranges below are legacy 5-digit vnums and need to
-- be migrated to room.zone_id/room.local_id checks once the proper room
-- mapping is restored.

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
return true
