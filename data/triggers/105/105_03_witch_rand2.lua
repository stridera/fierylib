-- Trigger: Witch_rand2
-- Zone: 105, ID: 3
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #10503
-- Witchwoman asks the player for a mushroom (paired with #10504 receive trigger).
-- The legacy DG script contained a stray `pond` line that was never a valid
-- command; it has been dropped in this conversion.

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
wait(1)
self:say("I'll reward you if you get me one.")
self.room:send("</>She goes back to searching the room.</>")