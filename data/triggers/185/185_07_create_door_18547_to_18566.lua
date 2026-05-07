-- Trigger: create_door_18547_to_18566
-- Zone: 185, ID: 7
-- Type: WORLD, Flags: PREENTRY
--
-- Opens the hidden passage between rooms 185,47 and 185,66.
-- Probability is 0% because this trigger is only fired manually via
-- run_room_trigger from Silania's exit speech (185_06).

-- only run from silania's trigger 185_06
wait(2)
self.room:send("The walls seem to flow away from an opening.")
get_room(185, 47):exit("east"):set_state({hidden = false})
get_room(185, 66):exit("west"):set_state({hidden = false})