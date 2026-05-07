-- Trigger: Mystwatch_cycle_semantics_1
-- Zone: 160, ID: 15
-- Type: MOB, Flags: RANDOM, GREET
--
-- 14% chance per random/greet tick: ambient flavor — the (charred skeleton
-- spawn-cycle template) mob steps into the shadows. Sets the brooding tone
-- of the fortress between quest stages.

if not percent_chance(14) then
    return true
end
self.room:send("A silhouette moves across the shadows.")
self:command("hide")
