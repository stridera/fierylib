-- Trigger: demon_rand1
-- Zone: 490, ID: 47
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #49047

-- Converted from DG Script #49047: demon_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
self:emote("grinds its beak menacingly and stares around itself.")