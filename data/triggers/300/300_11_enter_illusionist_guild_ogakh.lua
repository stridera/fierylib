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
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
_return_value = false
get_room(300, 20):exit("west"):set_state({hidden = false})
actor:move("west")
get_room(300, 20):exit("west"):set_state({hidden = true})
return _return_value