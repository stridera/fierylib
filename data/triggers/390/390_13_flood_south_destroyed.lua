-- Trigger: flood_south_destroyed
-- Zone: 390, ID: 13
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #39013

-- Converted from DG Script #39013: flood_south_destroyed
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local south = get_room(390, 187):exit("south")
if south then
    south:set_state({has_door = true, closed = true, description = "The ruins of a decimated settlement lay beyond."})
end