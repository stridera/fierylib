-- Trigger: **UNUSED**
-- Zone: 580, ID: 11
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #58011

-- Converted from DG Script #58011: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: p
if not (cmd == "p") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value