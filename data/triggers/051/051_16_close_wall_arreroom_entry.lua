-- Trigger: close_wall_arreroom_entry
-- Zone: 51, ID: 16
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #5116

-- Converted from DG Script #5116: close_wall_arreroom_entry
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(5)
self.room:send("The stone door slides shut!")
get_room(580, 25):exit("east"):set_state({hidden = true})
get_room(580, 25):at(function()
    self.room:send("The stone door slides shut!")
end)