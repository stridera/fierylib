-- Trigger: agressive_attack3
-- Zone: 590, ID: 38
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #59038

-- Converted from DG Script #59038: agressive_attack3
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(8)
local victim = room.actors[random(1, #room.actors)]
if victim.level <100 and victim.id == -1 then
    combat.engage(self, victim.name)
end