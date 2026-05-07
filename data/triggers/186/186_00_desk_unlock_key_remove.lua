-- Trigger: Desk_unlock_key_remove
-- Zone: 186, ID: 0
-- Type: OBJECT, Flags: REMOVE
-- Status: CLEAN
--
-- Original DG Script: #18600

-- Converted from DG Script #18600: Desk_unlock_key_remove
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
-- Legacy room 18630 = zone 186, local 30
local actor_room = actor.room
if actor_room and actor_room.zone_id == 186 and actor_room.local_id == 30 then
    self.room:spawn_object(186, 7)
    actor:command("get script_key")
    actor:command("unlock oblong")
    world.destroy(self.room:find_object("script_key"))
end