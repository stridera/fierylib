-- Trigger: agressive_attack2
-- Zone: 590, ID: 37
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #59037

-- Converted from DG Script #59037: agressive_attack2
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.alignment <= -350 and actor.level < 100 and actor.id == -1 then
    wait(4)
    combat.engage(self, actor.name)
end