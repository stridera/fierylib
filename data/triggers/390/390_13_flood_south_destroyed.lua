-- Trigger: flood_south_destroyed
-- Zone: 390, ID: 13
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #39013

-- Converted from DG Script #39013: flood_south_destroyed
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
doors.set_flags(get_room(391, 87), "south", "f")
doors.set_description(get_room(391, 87), "south", "The ruins of a decimated settlement lay beyond.")