-- Trigger: hoard-door
-- Zone: 520, ID: 54
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52054

-- Converted from DG Script #52054: hoard-door
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
get_room(520, 93):exit("east"):set_state({has_door = true, closed = true, locked = true, hidden = true})
get_room(520, 93):exit("east"):set_state({hidden = false})
get_room(520, 93):exit("east"):set_state({name = "panel massive"})
get_room(520, 93):exit("east"):set_state({action = "key"})
get_room(520, 94):exit("west"):set_state({has_door = true, closed = true, locked = true})
get_room(520, 94):exit("west"):set_state({hidden = false})
get_room(520, 94):exit("west"):set_state({name = "panel massive"})
get_room(520, 94):exit("west"):set_state({action = "key"})