-- Trigger: sulk_and_south
-- Zone: 12, ID: 61
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1261

-- Converted from DG Script #1261: sulk_and_south
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: sulk
if not (cmd == "sulk") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value