-- Trigger: flood_frozen_fight
-- Zone: 390, ID: 15
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #39015

-- Converted from DG Script #39015: flood_frozen_fight
-- Original: MOB trigger, flags: FIGHT, probability: 33%

-- 33% chance to trigger
if not percent_chance(33) then
    return true
end
wait(1)
local cast = random(1, 3)
if cast == 1 then
    spells.cast(self, "iceball", actor)
elseif cast == 2 then
    spells.cast(self, "chain lightning")
elseif cast == 3 then
    spells.cast(self, "freeze", actor)
end