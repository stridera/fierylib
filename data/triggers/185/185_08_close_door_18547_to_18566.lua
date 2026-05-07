-- Trigger: close_door_18547_to_18566
-- Zone: 185, ID: 8
-- Type: WORLD, Flags: PREENTRY
--
-- Seals the hidden passage between rooms 185,47 and 185,66 once a player
-- traverses it. Mirror of 185_07 which opens it.
wait(5)

local closeit = false
if string.find(direction, "east") and self.zone_id == 185 and self.local_id == 47 then
    closeit = true
elseif string.find(direction, "west") and self.zone_id == 185 and self.local_id == 66 then
    closeit = true
end

if closeit then
    self.room:send("The walls seem to flow together behind you, sealing the entrance!")
    get_room(185, 47):exit("east"):set_state({hidden = true})
    get_room(185, 66):exit("west"):set_state({hidden = true})
end
