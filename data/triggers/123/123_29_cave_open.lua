-- Trigger: cave_open
-- Zone: 123, ID: 29
-- Type: WORLD, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12329

-- Converted from DG Script #12329: cave_open
-- Original: WORLD trigger, flags: GLOBAL, RANDOM, probability: 100%
if time.hour > 19 or time.hour < 5 then
    if self.south ~= 12401 then
        get_room(123, 99):exit("south"):set_state({hidden = false})
        self.room:send("Gentle moonlight begins to seep through cracks in the wall of the cave, revealing an exit to the south.")
    end
elseif time.hour > 5 and time.hour < 19 then
    if self.south == 12401 then
        get_room(123, 99):exit("south"):set_state({hidden = true})
        self.room:send("As the sun rises, the exit to the forest beyond the cave fades from view.")
    end
end