-- Trigger: **UNUSED**
-- Zone: 300, ID: 4
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #30004

-- Converted from DG Script #30004: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: u
if not (cmd == "u") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value