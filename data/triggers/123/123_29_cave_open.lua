-- Trigger: cave_open
-- Zone: 123, ID: 29
-- Type: WORLD, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12329

-- Converted from DG Script #12329: cave_open
-- Original: WORLD trigger, flags: GLOBAL, RANDOM, probability: 100%
--
-- TODO(parity): the original DG check `if self.south ~= 12401` tested
-- whether the south exit destination matched a specific room. In the
-- new runtime, `self.south` does not exist and the comparison is always
-- false against a legacy 5-digit vnum. Replace the guards below with a
-- query against the exit state itself (e.g. checking the hidden flag on
-- `get_room(123, 99):exit("south")`) so the wecho only fires once per
-- transition, not every random tick within the window.
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