-- Trigger: elder_rand1
-- Zone: 480, ID: 19
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48019

-- Converted from DG Script #48019: elder_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
self:command("glare barrow-witch")
self:say("Stop trying to peep at the recipe youngster.  If I die, then you can see it.")
self:command("cackle")
wait(1)
self:say("If...")
self:command("glare")