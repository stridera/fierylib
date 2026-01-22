-- Trigger: **UNUSED**
-- Zone: 60, ID: 71
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #6071

-- Converted from DG Script #6071: **UNUSED**
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: ru
if not (cmd == "ru") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value