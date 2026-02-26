-- Trigger: **UNUSED**
-- Zone: 30, ID: 124
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3124

-- Converted from DG Script #3124: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: pa
if not (cmd == "pa") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- This trigger makes sure the command "pa" does its normal function
-- instead of triggering the pat trigger.
_return_value = true
return _return_value