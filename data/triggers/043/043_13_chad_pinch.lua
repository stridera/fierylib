-- Trigger: chad_pinch
-- Zone: 43, ID: 13
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4313

-- Converted from DG Script #4313: chad_pinch
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("pinches a player on the behind!")
wait(4)
self:command("whistle")
wait(3)
self:say("Wasn't me.  I like girls.")