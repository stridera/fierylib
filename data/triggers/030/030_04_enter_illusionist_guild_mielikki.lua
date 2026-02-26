-- Trigger: Enter Illusionist Guild Mielikki
-- Zone: 30, ID: 4
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3004

-- Converted from DG Script #3004: Enter Illusionist Guild Mielikki
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: south
if not (cmd == "south") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
doors.set_state(get_room(30, 64), "south", {action = "room"})
actor:move("south")
doors.set_state(get_room(30, 64), "south", {action = "purge"})
return _return_value