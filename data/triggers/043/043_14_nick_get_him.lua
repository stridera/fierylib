-- Trigger: nick_get_him
-- Zone: 43, ID: 14
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4314

-- Converted from DG Script #4314: nick_get_him
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("slinks up to his fellow player and tosses his arms around him.")
wait(2)
self:emote("plasters a sultry smile across his face.")
wait(3)
self:command("grope chad")
wait(3)
self:say("Oh don't worry, I can make it worth your time.")
wait(4)
self:command("wink")