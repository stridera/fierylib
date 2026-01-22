-- Trigger: lame_beggar_rand2
-- Zone: 61, ID: 19
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6119

-- Converted from DG Script #6119: lame_beggar_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
self:emote("holds his sore ridden hands out to you.")
self:say("Please spare some money, my children are starving.")