-- Trigger: glabrezu-exits
-- Zone: 22, ID: 17
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2217

-- Converted from DG Script #2217: glabrezu-exits
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(2)
self.room:send("<b:white>The white-hot<yellow> fires begin <red>to recede and </><red>a path down is revealed.</>")
doors.set_state(get_room(22, 13), "down", {action = "room"})
doors.set_description(get_room(22, 13), "down", "&1A red staircase leads down.&0")