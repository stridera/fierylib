-- Trigger: **UNUSED**
-- Zone: 364, ID: 17
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #36417

-- Converted from DG Script #36417: **UNUSED**
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: d di
if not (cmd == "d" or cmd == "di") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value