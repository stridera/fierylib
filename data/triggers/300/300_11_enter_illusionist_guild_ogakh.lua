-- Trigger: Enter Illusionist Guild Ogakh
-- Zone: 300, ID: 11
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30011

-- Converted from DG Script #30011: Enter Illusionist Guild Ogakh
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: west
if not (cmd == "west") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
doors.set_state(get_room(300, 20), "west", {action = "room"})
actor:move("west")
doors.set_state(get_room(300, 20), "west", {action = "purge"})
return _return_value