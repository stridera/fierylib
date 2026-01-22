-- Trigger: Firework being dropped
-- Zone: 615, ID: 96
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #61596

-- Converted from DG Script #61596: Firework being dropped
-- Original: OBJECT trigger, flags: DROP, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = true
local on_ground = 1
globals.on_ground = globals.on_ground or true
return _return_value