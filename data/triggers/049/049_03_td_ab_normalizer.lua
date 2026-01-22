-- Trigger: TD AB Normalizer
-- Zone: 49, ID: 3
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #4903

-- Converted from DG Script #4903: TD AB Normalizer
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: ca
if not (cmd == "ca") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- Team Domination Armband Capture Normalization (Command) Trigger
_return_value = false
return _return_value