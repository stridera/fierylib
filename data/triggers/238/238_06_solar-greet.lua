-- Trigger: solar-greet
-- Zone: 238, ID: 6
-- Type: MOB, Flags: GREET
--
-- The solar smites evil-aligned entrants on sight: shields itself, then
-- hits the actor with divine ray.
if actor.alignment < -349 then
    spells.cast(self, "soulshield")
    spells.cast(self, "divine ray", actor)
end
