-- Trigger: Observe_other_room
-- Zone: 188, ID: 2
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18802

-- Converted from DG Script #18802: Observe_other_room
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: observe
if not (cmd == "observe") then
    return true  -- Not our command
end
--
-- Observation trigger
-- Player supplies an argument which evaluates to a room ID.  The player
-- is then shown that room.
--
-- switch on arg
local lookroom
if arg == "inn" then
    lookroom = 54
elseif arg == "board" then
    lookroom = 2
elseif arg == "fountain" then
    lookroom = 9
else
    actor:send("Observe <blue>where</>?")
    return true
end
actor:send("You peer out the window into the world below.")
self.room:send_except(actor, tostring(actor.alias) .. " peers out the window.")
actor:teleport(get_room(30, lookroom))
-- actor looks around
actor:teleport(get_room(188, 2))