-- Trigger: Unused trigger
-- Zone: 510, ID: 24
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #51024

-- Converted from DG Script #51024: Unused trigger
-- Original: MOB trigger, flags: GREET, probability: 100%
self:command("ponder " .. tostring(actor.name))
self:say("You are attentive, very impressive.")
actor.name:teleport(get_room(510, 71))