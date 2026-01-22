-- Trigger: sorcha_fight
-- Zone: 533, ID: 5
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #53305

-- Converted from DG Script #53305: sorcha_fight
-- Original: MOB trigger, flags: FIGHT, probability: 33%

-- 33% chance to trigger
if not percent_chance(33) then
    return true
end
wait(1)
spells.cast(self, "unholy word")