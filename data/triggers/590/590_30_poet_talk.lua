-- Trigger: poet_talk
-- Zone: 590, ID: 30
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #59030

-- Converted from DG Script #59030: poet_talk
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:command("daydream")
wait(6)
self:say("My thoughts seem to be my only friend.")