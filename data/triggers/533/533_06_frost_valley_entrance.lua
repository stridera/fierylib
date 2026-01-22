-- Trigger: frost_valley_entrance
-- Zone: 533, ID: 6
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53306

-- Converted from DG Script #53306: frost_valley_entrance
-- Original: WORLD trigger, flags: COMMAND, probability: 75%

-- 75% chance to trigger
if not percent_chance(75) then
    return true
end

-- Command filter: push
if not (cmd == "push") then
    return true  -- Not our command
end
doors.set_state(get_room(533, 2), "west", {action = "room"})
doors.set_description(get_room(533, 2), "west", "The piles of ice slips allowing passage.")
doors.set_name(get_room(533, 2), "west", "ice")
self.room:send_except(actor, tostring(actor.name) .. " pushes some ice out of the way, opening a passage down the western tunnel.")
actor:send("It took some effort, but the wall of ice has been moved from the west, allowing passage.")
get_room(534, 1):at(function()
    self.room:send("The ice falls from the east allowing passage.")
end)
wait_ticks(1)
self.room:send("The ice seems to magically reform blocking the western passage.")
doors.set_state(get_room(533, 2), "west", {action = "purge"})