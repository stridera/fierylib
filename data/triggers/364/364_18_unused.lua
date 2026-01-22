-- Trigger: **UNUSED**
-- Zone: 364, ID: 18
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #36418

-- Converted from DG Script #36418: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: h ho how
if not (cmd == "h" or cmd == "ho" or cmd == "how") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value