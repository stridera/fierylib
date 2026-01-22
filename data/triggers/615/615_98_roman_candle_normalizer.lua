-- Trigger: roman candle normalizer
-- Zone: 615, ID: 98
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61598

-- Converted from DG Script #61598: roman candle normalizer
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: ligh
if not (cmd == "ligh") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
_return_value = false
return _return_value