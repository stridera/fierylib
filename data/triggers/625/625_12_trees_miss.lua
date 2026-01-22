-- Trigger: trees miss
-- Zone: 625, ID: 12
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #62512

-- Converted from DG Script #62512: trees miss
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local _return_value = true  -- Default: allow action
local smash = random(1, 100)
if smash < 30 then
    self.room:send("A branch from " .. tostring(self.name) .. " smashes the ground!")
    _return_value = true
    return _return_value
else
    _return_value = false
end
return _return_value