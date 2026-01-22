-- Trigger: lame_beggar_rand1
-- Zone: 61, ID: 18
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6118

-- Converted from DG Script #6118: lame_beggar_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("mutters to himself.")
self:say("Being a beggar just isn't such a good calling these days.")
self:emote("scratches at a sore.")