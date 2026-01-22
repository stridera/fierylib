-- Trigger: seer_rand2
-- Zone: 85, ID: 15
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #8515

-- Converted from DG Script #8515: seer_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
self:emote("grumbles about the lack of observation skills and such.")