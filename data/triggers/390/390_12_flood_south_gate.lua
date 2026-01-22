-- Trigger: flood_south_gate
-- Zone: 390, ID: 12
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #39012

-- Converted from DG Script #39012: flood_south_gate
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
doors.set_flags(get_room(391, 87), "south", "f")
doors.set_description(get_room(391, 87), "south", "A sturdy gate holds back the sea.")