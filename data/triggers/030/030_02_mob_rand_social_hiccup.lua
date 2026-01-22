-- Trigger: MOB_RAND_SOCIAL_HICCUP
-- Zone: 30, ID: 2
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #3002

-- Converted from DG Script #3002: MOB_RAND_SOCIAL_HICCUP
-- Original: MOB trigger, flags: RANDOM, probability: 14%

-- 14% chance to trigger
if not percent_chance(14) then
    return true
end
self:command("hic")