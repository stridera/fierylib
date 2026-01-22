-- Trigger: **UNUSED**
-- Zone: 31, ID: 17
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3117

-- Converted from DG Script #3117: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: s
if not (cmd == "s") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- This trigger makes sure the command "s" does its normal function,
-- instead of triggering the squeeze trigger.
_return_value = false
return _return_value