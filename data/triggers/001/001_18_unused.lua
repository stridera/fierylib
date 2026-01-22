-- Trigger: **UNUSED**
-- Zone: 1, ID: 18
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #118

-- Converted from DG Script #118: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: s
if not (cmd == "s") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value