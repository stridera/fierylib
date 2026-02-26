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
    doors.set_flags(get_room(125, 33), "east", "abcde")
    doors.set_flags(get_room(125, 34), "west", "abcd")
end