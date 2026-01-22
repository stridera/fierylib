-- Trigger: **UNUSED**
-- Zone: 300, ID: 2
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30002

-- Converted from DG Script #30002: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: re
if not (cmd == "re") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value