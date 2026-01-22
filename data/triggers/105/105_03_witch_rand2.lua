-- Trigger: Witch_rand2
-- Zone: 105, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: pond
--
-- Original DG Script: #10503

-- Converted from DG Script #10503: Witch_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self.room:send("</><green>The </><blue>&9witchwoman</><green> looks around frantically.</>")
self:say("Damn!")
self:command("frown")
self:say("Hey you.")
wait(2)
self:say("Yes you! Got any mushrooms? I need some for this spell I'm doing.")
-- UNCONVERTED: pond
wait(1)
self:say("I'll reward you if you get me one.")
self.room:send("</>She goes back to searching the room.</>")