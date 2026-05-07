-- Trigger: room_reload_mob
-- Zone: 117, ID: 102
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #11802

-- Converted from DG Script #11802: room_reload_mob
-- Original: WORLD trigger, flags: DROP, probability: 100%
-- TODO: object.id is the legacy DG vnum (11800). Confirm whether this should
-- compare against composite (zone_id, local_id) instead — likely (117, 100).
if object.id == 11800 then
    wait(2)
    local ball = self.room:find_actor("ball-mist")
    if ball then
        world.destroy(ball)
    end
    self.room:send("The mist begins to reform.")
    self.room:spawn_mobile(117, 100)
end