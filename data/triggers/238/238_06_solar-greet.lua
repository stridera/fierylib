-- Trigger: solar-greet
-- Zone: 238, ID: 6
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #23806

-- Converted from DG Script #23806: solar-greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.alignment < -349 then
    spells.cast(self, "soulshield")
    spells.cast(self, "divine ray", actor.name)
end