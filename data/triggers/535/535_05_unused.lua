-- Trigger: **UNUSED**
-- Zone: 535, ID: 5
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #53505

-- Converted from DG Script #53505: **UNUSED**
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: u
if not (cmd == "u") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value