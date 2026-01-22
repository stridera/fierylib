-- Trigger: **UNUSED**
-- Zone: 1, ID: 29
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #129

-- Converted from DG Script #129: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: hi
if not (cmd == "hi") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value