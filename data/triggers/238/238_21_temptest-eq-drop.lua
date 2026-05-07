-- Trigger: tempest-eq-drop
-- Zone: 238, ID: 21
-- Type: MOB, Flags: DEATH
--
-- On death, the Tempest spawns its signature loose icy-blue pants (238:25)
-- in inventory and drops them so the killer can pick them up.
self.room:spawn_object(238, 25)
self:command("drop pants")
return true
