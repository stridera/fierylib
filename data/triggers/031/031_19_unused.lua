-- Trigger: **UNUSED**
-- Zone: 31, ID: 19
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3119

-- Converted from DG Script #3119: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: pr
if not (cmd == "pr") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- This trigger makes sure the command "pr" does its normal function,
-- instead of triggering the press trigger.
_return_value = false
return _return_value