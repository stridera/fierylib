-- Trigger: wall-refit
-- Zone: 238, ID: 42
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #23842

-- Converted from DG Script #23842: wall-refit
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.id == 23841 then
    wait(1)
    get_room(238, 41):exit("south"):set_state({description = "\"The one who wore purple stood next to the half-elf\"."})
    get_room(238, 41):exit("south"):set_state({hidden = true})
    self.room:send("The wall flares with a pure white light as the broken fragment is joined to the whole.")
    self.room:send("The pentagram is completed.")
    wait(60)
    self.room:send("A piece of the wall slowly dissolves.")
    get_room(238, 41):exit("south"):set_state({description = "The wall is broken here, interrupting the pentagram carved into it."})
    get_room(238, 41):exit("south"):set_state({hidden = true})
end