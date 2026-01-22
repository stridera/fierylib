-- Trigger: reroll_ladder
-- Zone: 490, ID: 12
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #49012

-- Converted from DG Script #49012: reroll_ladder
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if direction == "down" then
    wait(1)
    self.room:send("The rope ladder rolls back up.")
    self.room:spawn_object(490, 41)
    doors.set_state(get_room(491, 49), "down", {action = "purge"})
    doors.set_state(get_room(490, 28), "up", {action = "purge"})
    doors.set_state(get_room(490, 28), "u", {action = "room"})
end