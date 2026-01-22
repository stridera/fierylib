-- Trigger: find_blood_ret_S
-- Zone: 590, ID: 41
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #59041

-- Converted from DG Script #59041: find_blood_ret_S
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: s
if not (cmd == "s") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value