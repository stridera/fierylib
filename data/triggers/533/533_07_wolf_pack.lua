-- Trigger: wolf pack
-- Zone: 533, ID: 7
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #53307

-- Converted from DG Script #53307: wolf pack
-- Original: MOB trigger, flags: LOAD, probability: 100%
local room = self.room
self:teleport(get_room(11, 0))
self.room:spawn_mobile(533, 15)
self.room:find_actor("wolf"):follow(self.room:find_actor("2.wolf"))
self.room:find_actor("wolf"):teleport(find_room_by_name("%room%"))
self.room:spawn_mobile(533, 15)
self.room:find_actor("wolf"):follow(self.room:find_actor("2.wolf"))
self.room:find_actor("wolf"):teleport(find_room_by_name("%room%"))
self.room:spawn_mobile(533, 15)
self.room:find_actor("wolf"):follow(self.room:find_actor("2.wolf"))
self.room:find_actor("wolf"):teleport(find_room_by_name("%room%"))
self:teleport(get_room(vnum_to_zone(room), vnum_to_local(room)))