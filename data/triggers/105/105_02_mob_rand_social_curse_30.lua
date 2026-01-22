-- Trigger: MOB_RAND_SOCIAL_CURSE_30
-- Zone: 105, ID: 2
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #10502

-- Converted from DG Script #10502: MOB_RAND_SOCIAL_CURSE_30
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:command("curse")