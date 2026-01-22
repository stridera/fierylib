-- Trigger: **UNUSED**
-- Zone: 484, ID: 16
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48416

-- Converted from DG Script #48416: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: th
if not (cmd == "th") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value