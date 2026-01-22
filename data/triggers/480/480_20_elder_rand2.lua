-- Trigger: elder_rand2
-- Zone: 480, ID: 20
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48020

-- Converted from DG Script #48020: elder_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
self:command("whap barrow-witch")
self:say("Don't mix the eye-of-newt with the toad blood yet idiot!")
self:say("Do you want to kill us all??")