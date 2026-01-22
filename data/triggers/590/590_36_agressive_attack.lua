-- Trigger: agressive_attack
-- Zone: 590, ID: 36
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #59036

-- Converted from DG Script #59036: agressive_attack
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.alignment <= -350 and actor.level < 100 and actor.id == -1 then
    wait(4)
    self:say("There is no place for your kind around here.")
    wait(6)
    combat.engage(self, actor.name)
end