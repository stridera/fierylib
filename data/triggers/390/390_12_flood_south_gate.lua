-- Trigger: flood_south_gate
-- Zone: 390, ID: 12
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #39012

-- Converted from DG Script #39012: flood_south_gate
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
local south = get_room(390, 187):exit("south")
if south then
    south:set_state({has_door = true, closed = true, description = "A sturdy gate holds back the sea."})
end