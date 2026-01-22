-- Trigger: dryad_random
-- Zone: 163, ID: 40
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #16340

-- Converted from DG Script #16340: dryad_random
-- Original: MOB trigger, flags: RANDOM, probability: 8%

-- 8% chance to trigger
if not percent_chance(8) then
    return true
end
self:command("whine")