-- Trigger: **UNUSED**
-- Zone: 615, ID: 40
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61540

-- Converted from DG Script #61540: **UNUSED**
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: down
if not (cmd == "down") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value