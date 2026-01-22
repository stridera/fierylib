-- Trigger: angry-gardener_rand1
-- Zone: 464, ID: 12
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #46412

-- Converted from DG Script #46412: angry-gardener_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:say("Watch yourself, kiddo.  I've got my eye on you.")