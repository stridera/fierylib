-- Trigger: seer_rand1
-- Zone: 85, ID: 14
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #8514

-- Converted from DG Script #8514: seer_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
self:emote("starts chanting a strange mantra.")