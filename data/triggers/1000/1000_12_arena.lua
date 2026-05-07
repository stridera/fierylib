-- Trigger: arena
-- Zone: 0, ID: 12
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #12
-- Self-heal during combat (arena combatant heals itself).

spells.cast(self, "heal", self)
wait(15)
