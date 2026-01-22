-- Trigger: **UNUSED**
-- Zone: 52, ID: 12
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #5212

-- Converted from DG Script #5212: **UNUSED**
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: se
if not (cmd == "se") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value