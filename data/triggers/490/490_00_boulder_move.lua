-- Trigger: boulder_move
-- Zone: 490, ID: 0
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #49000

-- Converted from DG Script #49000: boulder_move
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("The boulder slowly starts to move back.")
doors.set_state(get_room(490, 42), "s", {action = "room"})
doors.set_state(get_room(490, 84), "n", {action = "purge"})
doors.set_state(get_room(490, 84), "n", {action = "room"})
wait(8)
self.room:send("The boulder seems to be rolling slowly backward - better hurry!")
wait(5)
self.room:send("The boulder rolls back and seals the entrance.")
doors.set_state(get_room(490, 42), "s", {action = "purge"})
doors.set_flags(get_room(490, 84), "n", "abcd")
doors.set_state(get_room(490, 84), "n", {action = "key"})
doors.set_description(get_room(490, 84), "n", "The boulder seems to have been loosened.")
doors.set_name(get_room(490, 84), "n", "boulder")