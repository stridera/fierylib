-- Trigger: ghost warrior init
-- Zone: 484, ID: 15
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #48415

-- Converted from DG Script #48415: ghost warrior init
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- Teleport to another room so that other undead-captains
-- don't get in the way.
local room = self.room
self:teleport(get_room(11, 0))
self.room:spawn_mobile(484, 4)
self.room:spawn_mobile(484, 4)
self.room:spawn_mobile(484, 4)
self.room:find_actor("ghost-warrior"):follow(self.room:find_actor("undead-captain"))
self.room:find_actor("ghost-warrior"):teleport(find_room_by_name("%room%"))
self.room:find_actor("ghost-warrior"):follow(self.room:find_actor("undead-captain"))
self.room:find_actor("ghost-warrior"):teleport(find_room_by_name("%room%"))
self.room:find_actor("ghost-warrior"):follow(self.room:find_actor("undead-captain"))
self.room:find_actor("ghost-warrior"):teleport(find_room_by_name("%room%"))
self:teleport(get_room(vnum_to_zone(room), vnum_to_local(room)))