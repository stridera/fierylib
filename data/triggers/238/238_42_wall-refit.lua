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
    doors.set_description(get_room(238, 41), "south", "\"The one who wore purple stood next to the half-elf\".")
    doors.set_flags(get_room(238, 41), "south", "f")
    self.room:send("The wall flares with a pure white light as the broken fragment is joined to the whole.")
    self.room:send("The pentagram is completed.")
    wait(60)
    self.room:send("A piece of the wall slowly dissolves.")
    doors.set_description(get_room(238, 41), "south", "The wall is broken here, interrupting the pentagram carved into it.")
    doors.set_state(get_room(238, 41), "south", {action = "purge"})
end