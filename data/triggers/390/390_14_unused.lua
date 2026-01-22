-- Trigger: **UNUSED**
-- Zone: 390, ID: 14
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #39014

-- Converted from DG Script #39014: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: d
if not (cmd == "d") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value