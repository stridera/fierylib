-- Trigger: **UNUSED**
-- Zone: 30, ID: 157
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3157

-- Converted from DG Script #3157: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: l le
if not (cmd == "l" or cmd == "le") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value