-- Trigger: **UNUSED**
-- Zone: 123, ID: 98
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12398

-- Converted from DG Script #12398: **UNUSED**
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: kn kne knee
if not (cmd == "kn" or cmd == "kne" or cmd == "knee") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value