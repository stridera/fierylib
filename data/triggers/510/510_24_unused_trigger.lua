-- Trigger: Unused trigger
-- Zone: 510, ID: 24
-- Type: MOB, Flags: GREET
--
-- Original DG Script: #51024
-- Marked "Unused trigger" upstream. On greet, ponders the actor,
-- compliments their attentiveness, then teleports them to (510, 71)
-- (the maze entrance). Kept as parity but not currently attached to
-- any production mob.
self:command("ponder " .. tostring(actor.name))
self:say("You are attentive, very impressive.")
actor:teleport(get_room(510, 71))
