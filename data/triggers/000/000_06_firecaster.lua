-- Trigger: firecaster
-- Zone: 0, ID: 6
-- Type: OBJECT, Flags: GET, WEAR
-- Status: CLEAN
--
-- Original DG Script: #6

-- Converted from DG Script #6: firecaster
-- Original: OBJECT trigger, flags: GET, WEAR, probability: 100%
local _return_value = true  -- Default: allow action
self.room:send("A <red>Flame</> snakes up and down the blade of " .. tostring(self.shortdesc))
_return_value = true
return _return_value