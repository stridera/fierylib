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
get_room(62, 4):exit("south"):set_state({hidden = false})
actor:move("south")
get_room(62, 4):exit("south"):set_state({hidden = true})
return _return_value