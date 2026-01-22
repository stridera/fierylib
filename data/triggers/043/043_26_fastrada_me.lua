-- Trigger: fastrada_me
-- Zone: 43, ID: 26
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4326

-- Converted from DG Script #4326: fastrada_me
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("adjusts her crown.")
wait(3)
self:command("sigh")
wait(2)
self:say("It's good to be me.")
wait(4)
self:command("cackle")