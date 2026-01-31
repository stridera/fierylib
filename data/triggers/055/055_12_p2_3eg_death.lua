-- Trigger: p2_3eg_death
-- Zone: 55, ID: 12
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #5512

-- Converted from DG Script #5512: p2_3eg_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:spawn_object(172, 10)
self:command("recite all.scroll")
self.room:send(tostring(self.name) .. "'s gear is destroyed in the battle!")
self:destroy_item("all.eldoria-reward")
self:destroy_item("all.scroll")
-- Trophy zone/local pairs: 5508, 5510, 5512, 5514 -> zone 55, locals 8, 10, 12, 14
local trophy1_zone, trophy1_local = 55, 8
local trophy2_zone, trophy2_local = 55, 10
local trophy3_zone, trophy3_local = 55, 12
local trophy4_zone, trophy4_local = 55, 14
--
-- Death trigger for random trophy drops
--
-- set a random number to determine if a drop will
-- happen.
--
local will_drop = random(1, 100)
--
if will_drop <= 10 then
    -- drop nothing and bail
    return _return_value
end
if will_drop <= 50 then
    self.room:spawn_object(trophy1_zone, trophy1_local)
elseif will_drop >= 51 and will_drop <= 70 then
    self.room:spawn_object(trophy2_zone, trophy2_local)
elseif will_drop >= 71 and will_drop <= 90 then
    self.room:spawn_object(trophy3_zone, trophy3_local)
else
    self.room:spawn_object(trophy4_zone, trophy4_local)
end