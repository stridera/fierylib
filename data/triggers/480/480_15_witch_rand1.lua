-- Trigger: witch_rand1
-- Zone: 480, ID: 15
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48015

-- Converted from DG Script #48015: witch_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
self:command("ponder elder")