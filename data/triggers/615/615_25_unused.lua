-- Trigger: **UNUSED**
-- Zone: 615, ID: 25
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61525

-- Converted from DG Script #61525: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bo cur
if not (cmd == "bo" or cmd == "cur") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value