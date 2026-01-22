-- Trigger: **UNUSED**
-- Zone: 1, ID: 17
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #117

-- Converted from DG Script #117: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: b bu
if not (cmd == "b" or cmd == "bu") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value