-- Trigger: Slam_door_trigger
-- Zone: 125, ID: 2
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #12502

-- Converted from DG Script #12502: Slam_door_trigger
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor.id == -1 then
    wait(2)
    self.room:send("The door slams shut with a loud click!")
    get_room(125, 33):exit("east"):set_state({has_door = true, closed = true, locked = true, pickproof = true, hidden = true})
    get_room(125, 34):exit("west"):set_state({has_door = true, closed = true, locked = true, pickproof = true})
end