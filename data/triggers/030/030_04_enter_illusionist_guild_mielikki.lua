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
get_room(30, 64):exit("south"):set_state({hidden = false})
actor:move("south")
get_room(30, 64):exit("south"):set_state({hidden = true})
return _return_value