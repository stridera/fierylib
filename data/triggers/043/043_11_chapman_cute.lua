-- Trigger: chapman_cute
-- Zone: 43, ID: 11
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4311

-- Converted from DG Script #4311: chapman_cute
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:emote("beams.")
wait(3)
self:say("I'm just so CUTE!!")
wait(5)
self:say("Don't you think so?")