-- Trigger: boulder_move
-- Zone: 490, ID: 0
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #49000

-- Converted from DG Script #49000: boulder_move
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("The boulder slowly starts to move back.")
get_room(490, 42):exit("s"):set_state({hidden = false})
get_room(490, 84):exit("n"):set_state({hidden = true})
get_room(490, 84):exit("n"):set_state({hidden = false})
wait(8)
self.room:send("The boulder seems to be rolling slowly backward - better hurry!")
wait(5)
self.room:send("The boulder rolls back and seals the entrance.")
get_room(490, 42):exit("s"):set_state({hidden = true})
get_room(490, 84):exit("n"):set_state({has_door = true, closed = true, locked = true, pickproof = true})
get_room(490, 84):exit("n"):set_state({action = "key"})
get_room(490, 84):exit("n"):set_state({description = "The boulder seems to have been loosened."})
get_room(490, 84):exit("n"):set_state({name = "boulder"})