-- Trigger: earth elemental init
-- Zone: 484, ID: 14
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #48414

-- Converted from DG Script #48414: earth elemental init
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- Teleport to another room so that other earth-elemental-leaders
-- don't get in the way.
local room = self.room
self:teleport(get_room(11, 0))
self.room:spawn_mobile(484, 0)
self.room:spawn_mobile(484, 0)
self.room:spawn_mobile(484, 0)
self.room:find_actor("earth-elemental-follower"):follow(self.room:find_actor("earth-elemental-leader"))
self.room:find_actor("earth-elemental-follower"):teleport(find_room_by_name("%room%"))
self.room:find_actor("earth-elemental-follower"):follow(self.room:find_actor("earth-elemental-leader"))
self.room:find_actor("earth-elemental-follower"):teleport(find_room_by_name("%room%"))
self.room:find_actor("earth-elemental-follower"):follow(self.room:find_actor("earth-elemental-leader"))
self.room:find_actor("earth-elemental-follower"):teleport(find_room_by_name("%room%"))
self:teleport(get_room(vnum_to_zone(room), vnum_to_local(room)))