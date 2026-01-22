-- Trigger: dwarven_janitor_rand1
-- Zone: 61, ID: 9
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6109

-- Converted from DG Script #6109: dwarven_janitor_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("mutters about pay and conditions these days.")