-- Trigger: hatching_dragon
-- Zone: 533, ID: 0
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #53300
--
-- When a player picks up the dragon egg, it hatches into a baby dragon
-- which immediately attacks the player. The egg is destroyed.

actor:send("As you touch the egg it vibrates and cracks open!")
self.room:send_except(actor, "As " .. tostring(actor.name) .. " touches the egg it hatches!")
self.room:spawn_mobile(533, 1)
local dragon = self.room:find_actor("dragon")
if dragon then
    dragon:command("consider " .. tostring(actor.name))
    dragon:command("hit " .. tostring(actor.name))
end
world.destroy(self)
return true
