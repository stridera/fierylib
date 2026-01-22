-- Trigger: **UNUSED**
-- Zone: 31, ID: 58
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3158

-- Converted from DG Script #3158: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: pra
if not (cmd == "pra") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value