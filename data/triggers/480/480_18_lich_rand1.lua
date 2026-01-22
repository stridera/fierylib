-- Trigger: lich_rand1
-- Zone: 480, ID: 18
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48018

-- Converted from DG Script #48018: lich_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("watches you closely, his hunger for your lifeforce palpable.")