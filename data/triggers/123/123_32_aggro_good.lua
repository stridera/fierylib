-- Trigger: aggro_good
-- Zone: 123, ID: 32
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #12332

-- Converted from DG Script #12332: aggro_good
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.alignment >= 350 and actor.level < 100 and actor.id == -1 then
    wait(4)
    combat.engage(self, actor.name)
end