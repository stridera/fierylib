-- Trigger: dwarven_janitor_rand2
-- Zone: 61, ID: 10
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6110

-- Converted from DG Script #6110: dwarven_janitor_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 30%

-- 30% chance to trigger
if not percent_chance(30) then
    return true
end
self:emote("sweeps around your feet without even noticing you.")