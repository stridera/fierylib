-- Trigger: **UNUSED**
-- Zone: 534, ID: 56
-- Type: WORLD, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53456

-- Converted from DG Script #53456: **UNUSED**
-- Original: WORLD trigger, flags: GLOBAL, COMMAND, probability: 100%

-- Command filter: se
if not (cmd == "se") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- Allow sell and south to work in this room
_return_value = false
return _return_value