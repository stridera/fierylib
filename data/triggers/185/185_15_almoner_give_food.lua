-- Trigger: almoner_give_food
-- Zone: 185, ID: 15
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #18515

-- Converted from DG Script #18515: almoner_give_food
-- Original: MOB trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
local victim = room.actors[random(1, #room.actors)]
if (victim.id == -1) and (victim.level < 25) and (victim.can_be_seen) then
    self:command("smile " .. tostring(victim.name))
    self:say("Hello there, young one.  You look like you could use a bite to eat.")
    self:destroy_item("waybread")
    self.room:spawn_object(185, 8)
    self:command("give waybread " .. tostring(victim.name))
end