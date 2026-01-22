-- Trigger: velocity init
-- Zone: 489, ID: 20
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #48920

-- Converted from DG Script #48920: velocity init
-- Original: MOB trigger, flags: LOAD, probability: 100%
get_room(11, 0):at(function()
    self:command("rem all")
end)
get_room(11, 0):at(function()
    self:command("wear vest")
end)
self:command("get indigo-blade")
self:command("get indigo-blade")
self:destroy_item("indigo-blade")
self:destroy_item("indigo-blade")
self.room:spawn_object(480, 3)
self.room:spawn_object(480, 3)
self.room:spawn_object(238, 26)
self.room:spawn_object(238, 26)
get_room(11, 0):at(function()
    self:command("recite bright-red-scroll 1.indigo-blade")
end)
get_room(11, 0):at(function()
    self:command("recite bright-red-scroll 2.indigo-blade")
end)
self:command("wield indigo-blade")
self:command("wield indigo-blade")