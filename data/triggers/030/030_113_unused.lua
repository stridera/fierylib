-- Trigger: **UNUSED**
-- Zone: 30, ID: 113
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3113

-- Converted from DG Script #3113: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: whis
if not (cmd == "whis") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = true
-- This trigger forces the default action for "whis" instead of activating the
-- whistle trigger.
return _return_value