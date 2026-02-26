-- Trigger: Nukreth Spire beastmaster load
-- Zone: 462, ID: 31
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #46231

-- Converted from DG Script #46231: Nukreth Spire beastmaster load
-- Original: MOB trigger, flags: LOAD, probability: 100%
local room = self.room
self:teleport(get_room(11, 0))
self.room:spawn_mobile(462, 13)
self.room:find_actor("hyena"):follow(self.room:find_actor("beastmaster"))
self.room:find_actor("hyena"):teleport(find_room_by_name("%room%"))
self.room:spawn_mobile(462, 13)
self.room:find_actor("hyena"):follow(self.room:find_actor("beastmaster"))
self.room:find_actor("hyena"):teleport(find_room_by_name("%room%"))
self.room:spawn_mobile(462, 15)
self.room:find_actor("hyena"):follow(self.room:find_actor("beastmaster"))
self.room:find_actor("hyena"):teleport(find_room_by_name("%room%"))
self:teleport(get_room(vnum_to_zone(room), vnum_to_local(room)))