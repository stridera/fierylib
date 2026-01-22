-- Trigger: solar-battle
-- Zone: 238, ID: 7
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #23807

-- Converted from DG Script #23807: solar-battle
-- Original: MOB trigger, flags: FIGHT, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
if random(1, 10) < 5 then
    spells.cast(self, "divine ray")
end