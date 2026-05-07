-- Trigger: close_wall_arreroom_entry
-- Zone: 51, ID: 16
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #5116

-- Converted from DG Script #5116: close_wall_arreroom_entry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
--
-- After someone enters the monk-quest entry room, wait a beat and slam
-- the secret door east into 580/25 closed. Echo the slam in both rooms.
wait(5)
self.room:send("The stone door slides shut!")
local arre_chamber = get_room(580, 25)
arre_chamber:exit("east"):set_state({hidden = true})
arre_chamber:send("The stone door slides shut!")