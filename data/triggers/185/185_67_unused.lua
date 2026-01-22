-- Trigger: **UNUSED**
-- Zone: 185, ID: 67
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18567

-- Converted from DG Script #18567: **UNUSED**
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: k
if not (cmd == "k") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value