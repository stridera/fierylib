-- Trigger: 11765_to_11766_south_exit
-- Zone: 117, ID: 0
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #11700

-- Converted from DG Script #11700: 11765_to_11766_south_exit
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: wave fog
if not (cmd == "wave" or cmd == "fog") then
    return true  -- Not our command
end
doors.set_state(get_room(117, 65), "south", {action = "room"})
doors.set_description(get_room(117, 65), "south", "A wall of fog is parted to the south, allowing passage.")
doors.set_name(get_room(117, 65), "south", "mistwall mistdoor")
self.room:send_except(actor, tostring(actor.name) .. " waves " .. tostring(actor.possessive) .. " hands around causing the fog south to dissipate allowing passage.")
actor:send("By moving your hands you clear a passage through the fog to the south.")
get_room(117, 66):at(function()
    self.room:send("The fog to the north clears a little.")
end)
wait_ticks(1)
self.room:send("The fog slowly closes back around the exit to the south.")
doors.set_state(get_room(117, 65), "south", {action = "purge"})