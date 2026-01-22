-- Trigger: **UNUSED**
-- Zone: 31, ID: 53
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3153

-- Converted from DG Script #3153: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: tra
if not (cmd == "tra") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value