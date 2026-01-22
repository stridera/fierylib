-- Trigger: Kerristone_north_thing_rand
-- Zone: 324, ID: 12
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #32412

-- Converted from DG Script #32412: Kerristone_north_thing_rand
-- Original: MOB trigger, flags: RANDOM, probability: 49%

-- 49% chance to trigger
if not percent_chance(49) then
    return true
end
-- This was a prog that mppurged on the
-- random check, no idea why... If it
-- becomes obvious someone add the purge
-- below after commenting the plan.
self:command("grin")