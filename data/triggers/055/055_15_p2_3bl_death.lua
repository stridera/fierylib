-- Trigger: p2_3bl_death
-- Zone: 55, ID: 15
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #5515

-- Converted from DG Script #5515: p2_3bl_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:spawn_object(172, 10)
self:command("recite all.scroll")
self.room:send(tostring(self.name) .. "'s gear is destroyed in the battle!")
self:destroy_item("all.eldoria-reward")
self:destroy_item("all.scroll")
local vnum_trophy1 = 7
local vnum_trophy2 = 9
local vnum_trophy3 = 11
local vnum_trophy4 = 13
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
    self.room:spawn_object(55, vnum_trophy1)
elseif will_drop >= 51 and will_drop <= 70 then
    self.room:spawn_object(55, vnum_trophy2)
elseif will_drop >= 71 and will_drop <= 90 then
    self.room:spawn_object(55, vnum_trophy3)
else
    self.room:spawn_object(55, vnum_trophy4)
end