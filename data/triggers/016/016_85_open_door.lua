-- Trigger: open_door
-- Zone: 16, ID: 85
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #1685

-- Converted from DG Script #1685: open_door
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local room_86 = get_room(16, 86)
local room_87 = get_room(16, 87)
local exit_n = room_86:exit("north")
local exit_s = room_87:exit("south")

exit_n:set_state({hidden = false, description = "A small, hand-dug, exit is carved into the wall."})
wait(2)
self.room:send("A haggard dwarf reveals a hand-dug tunnel to the north.")
room_87:at(function()
    room_87:send("A small noise can be heard as a few stones fall away to the south, revealing an exit.")
end)
exit_s:set_state({hidden = false, description = "A small, hand-dug, exit is carved into the wall."})
local dwarf = self.room:find_actor("dwarf")
if dwarf then
    dwarf:say("Hurry, we don't have much time!")
    self.room:send("A haggard dwarf rushs north.")
    world.destroy(dwarf)
end
wait(10)
self.room:send("The hole in the wall collapses and is no more!")
room_87:at(function()
    room_87:send("The hole in the wall collapses and is no more!")
end)
exit_n:set_state({hidden = true})
exit_s:set_state({hidden = true})