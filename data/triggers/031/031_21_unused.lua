-- Trigger: **UNUSED**
-- Zone: 31, ID: 21
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3121

-- Converted from DG Script #3121: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: pi
if not (cmd == "pi") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- This trigger makes sure the command "pi" does its normal function
-- instead of triggering the pinch trigger.
_return_value = false
return _return_value