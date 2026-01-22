-- Trigger: TD PY Normalize
-- Zone: 49, ID: 6
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4906

-- Converted from DG Script #4906: TD PY Normalize
-- Original: OBJECT trigger, flags: COMMAND, probability: 4%

-- 4% chance to trigger
if not percent_chance(4) then
    return true
end

-- Command filter: xcaptur
if not (cmd == "xcaptur") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value