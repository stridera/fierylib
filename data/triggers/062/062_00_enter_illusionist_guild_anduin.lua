-- Trigger: Enter Illusionist Guild Anduin
-- Zone: 62, ID: 0
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6200

-- Converted from DG Script #6200: Enter Illusionist Guild Anduin
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
doors.set_state(get_room(62, 4), "south", {action = "room"})
actor:move("south")
doors.set_state(get_room(62, 4), "south", {action = "purge"})
return _return_value