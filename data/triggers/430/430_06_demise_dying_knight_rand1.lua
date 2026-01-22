-- Trigger: Demise_dying_knight_rand1
-- Zone: 430, ID: 6
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #43006

-- Converted from DG Script #43006: Demise_dying_knight_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self.room:send(tostring(self.name) .. " is mortally wounded and will die soon.")