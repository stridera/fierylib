-- Trigger: abbot_rand2
-- Zone: 185, ID: 12
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #18512

-- Converted from DG Script #18512: abbot_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("mutters about the tribulations of monastic life.")
self:command("sigh")