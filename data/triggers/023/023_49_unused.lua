-- Trigger: **UNUSED**
-- Zone: 23, ID: 49
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2349

-- Converted from DG Script #2349: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: li
if not (cmd == "li") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value