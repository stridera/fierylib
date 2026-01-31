-- Trigger: open_door
-- Zone: 16, ID: 85
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #1685

-- Converted from DG Script #1685: open_door
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
get_room(16, 86):exit("north"):set_state({hidden = false})
get_room(16, 86):exit("north"):set_state({description = "A small, hand-dug, exit is carved into the wall."})
wait(2)
self.room:send("A haggard dwarf reveals a hand-dug tunnel to the north.")
get_room(16, 87):at(function()
    self.room:send("A small noise can be heard as a few stones fall away to the south, revealing an exit.")
end)
get_room(16, 87):exit("south"):set_state({hidden = false})
get_room(16, 87):exit("south"):set_state({description = "A small, hand-dug, exit is carved into the wall."})
self.room:find_actor("dwarf"):say("Hurry, we don't have much time!")
self.room:send("A haggard dwarf rushs north.")
world.destroy(self.room:find_actor("dwarf"))
wait(10)
self.room:send("The hole in the wall collapses and is no more!")
get_room(16, 87):at(function()
    self.room:send("The hole in the wall collapses and is no more!")
end)
get_room(16, 86):exit("north"):set_state({hidden = true})
get_room(16, 87):exit("south"):set_state({hidden = true})