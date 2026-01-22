-- Trigger: angry-gardener_rand2
-- Zone: 464, ID: 13
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #46413

-- Converted from DG Script #46413: angry-gardener_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self:command("mutter")