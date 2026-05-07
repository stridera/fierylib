-- Trigger: almoner_give_food
-- Zone: 185, ID: 15
-- Type: MOB, Flags: RANDOM
--
-- 25% chance: Almoner gives waybread (185,8) to a random visible
-- low-level player in the room.
if not percent_chance(25) then
    return true
end
local victim = room.actors[random(1, #room.actors)]
if (victim.is_player) and (victim.level < 25) and (victim.can_be_seen) then
    self:command("smile " .. tostring(victim.name))
    self:say("Hello there, young one.  You look like you could use a bite to eat.")
    self:destroy_item("waybread")
    self.room:spawn_object(185, 8)
    self:command("give waybread " .. tostring(victim.name))
end