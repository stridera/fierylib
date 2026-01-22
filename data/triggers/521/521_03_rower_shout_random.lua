-- Trigger: rower_shout_random
-- Zone: 521, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #52103

-- Converted from DG Script #52103: rower_shout_random
-- Original: MOB trigger, flags: RANDOM, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end
self:shout("Help us!")