-- Trigger: close_door_18547_to_18566
-- Zone: 185, ID: 8
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #18508

-- Converted from DG Script #18508: close_door_18547_to_18566
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
wait(5)
local closeit = 0
if string.find(direction, "east") then
    if self.id == 18547 then
        local closeit = 1
    end
end
if string.find(direction, "west") then
    if self.id == 18566 then
        local closeit = 1
    end
end
if closeit == 1 then
    self.room:send("The walls seem to flow together behind you, sealing the entrance!")
    get_room(185, 47):exit("east"):set_state({hidden = true})
    get_room(185, 66):exit("west"):set_state({hidden = true})
end