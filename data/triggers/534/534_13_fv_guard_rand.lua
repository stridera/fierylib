-- Trigger: fv_guard_rand
-- Zone: 534, ID: 13
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #53413

-- Converted from DG Script #53413: fv_guard_rand
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:emote("mutters to himself about his crappy posting to this forsaken corner of the world.")