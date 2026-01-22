-- Trigger: **UNUSED**
-- Zone: 188, ID: 41
-- Type: OBJECT, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #18841

-- Converted from DG Script #18841: **UNUSED**
-- Original: OBJECT trigger, flags: GLOBAL, COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: w
if not (cmd == "w") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value