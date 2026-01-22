-- Trigger: General Angrugg babbles
-- Zone: 300, ID: 9
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #30009

-- Converted from DG Script #30009: General Angrugg babbles
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:command("mutter")
wait(4)
self:say("What ARE those filthy paladins up to?")
wait(2)
self:command("stomp")
wait(1)
self:say("I would pay handsomely for information as to their activities...")
wait(1)
self:emote("looks at you meaningfully.")