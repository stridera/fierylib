-- Trigger: **UNUSED**
-- Zone: 120, ID: 19
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #12019

-- Converted from DG Script #12019: **UNUSED**
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: pu
if not (cmd == "pu") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value