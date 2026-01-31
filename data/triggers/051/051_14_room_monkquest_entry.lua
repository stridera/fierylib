-- Trigger: room_monkquest_entry
-- Zone: 51, ID: 14
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5114

-- Converted from DG Script #5114: room_monkquest_entry
-- Original: WORLD trigger, flags: COMMAND, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Command filter: bow priest
if not (cmd == "bow" or cmd == "priest") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "b" or cmd == "bo" then
    _return_value = false
    return _return_value
end
actor:command("bow")
self.room:find_actor("monk_quest_priest"):emote("smiles broadly, pressing in a crack in the wall.")
get_room(580, 25):exit("east"):set_state({has_door = true})
get_room(580, 25):exit("east"):set_state({hidden = false})
get_room(580, 25):exit("east"):set_state({name = "heavy stone door"})
-- REMOVED: doors.set_key (not supported): -- REMOVED: doors.set_key (not supported): doors.set_key(get_room(580, 25), "east", -1)
get_room(580, 25):exit("east"):set_state({description = "A heavy slab of stone sits in your way."})
wait(3)
self.room:send(tostring(mobiles.template(51, 31).name) .. " presses a little harder, fully opening the stone door.")
self.room:send_except(actor, mobiles.template(51, 31).shortdesc .. " points to the east and nudges " .. actor.name .. " forward.")
actor:send(tostring(mobiles.template(51, 31).name) .. " points to the east and nudges you forward.")
return _return_value