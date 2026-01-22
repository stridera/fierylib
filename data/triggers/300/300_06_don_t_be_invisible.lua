-- Trigger: don't be invisible
-- Zone: 300, ID: 6
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #30006

-- Converted from DG Script #30006: don't be invisible
-- Original: MOB trigger, flags: GREET, probability: 100%
if self:has_effect(Effect.Invisible) then
    self:command("vis")
end