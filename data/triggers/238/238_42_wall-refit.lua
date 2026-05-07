-- Trigger: wall-refit
-- Zone: 238, ID: 42
-- Type: WORLD, Flags: DROP
--
-- When the wall-fragment object (238:41) is dropped in this room, the broken
-- south exit of room 238:41 is briefly restored: the hidden flag is cleared
-- and its description shows the half-elf-and-purple clue. After 60 ticks the
-- piece dissolves and the exit re-hides with its broken-wall description.
if object.zone_id == 238 and object.local_id == 41 then
    wait(1)
    get_room(238, 41):exit("south"):set_state({hidden = false})
    get_room(238, 41):exit("south"):set_state({description = [["The one who wore purple stood next to the half-elf".]]})
    self.room:send("The wall flares with a pure white light as the broken fragment is joined to the whole.")
    self.room:send("The pentagram is completed.")
    wait(60)
    self.room:send("A piece of the wall slowly dissolves.")
    get_room(238, 41):exit("south"):set_state({description = "The wall is broken here, interrupting the pentagram carved into it."})
    get_room(238, 41):exit("south"):set_state({hidden = true})
end
