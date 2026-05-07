-- Trigger: flood_frozen_fight
-- Zone: 390, ID: 15
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #39015
--
-- Frozen Lake spirit's combat behavior: 33% per round, casts one of
-- iceball, chain lightning, or freeze.

if not percent_chance(33) then
    return true
end

wait(1)
local cast = random(1, 3)
if cast == 1 then
    spells.cast(self, "iceball", actor)
elseif cast == 2 then
    spells.cast(self, "chain lightning")
else
    spells.cast(self, "freeze", actor)
end