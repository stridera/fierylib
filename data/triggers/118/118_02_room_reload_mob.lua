-- Trigger: room_reload_mob
-- Zone: 118, ID: 2
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #11802

-- Converted from DG Script #11802: room_reload_mob
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.id == 11800 then
    wait(2)
    world.destroy(self.room:find_actor("ball-mist"))
    self.room:send("The mist begins to reform.")
    self.room:spawn_mobile(118, 0)
end