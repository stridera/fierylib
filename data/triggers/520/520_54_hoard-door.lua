-- Trigger: hoard-door
-- Zone: 520, ID: 54
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52054

-- Converted from DG Script #52054: hoard-door
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
doors.set_flags(get_room(520, 93), "east", "abce")
doors.set_state(get_room(520, 93), "east", {action = "room"})
doors.set_name(get_room(520, 93), "east", "panel massive")
doors.set_state(get_room(520, 93), "east", {action = "key"})
doors.set_flags(get_room(520, 94), "west", "abc")
doors.set_state(get_room(520, 94), "west", {action = "room"})
doors.set_name(get_room(520, 94), "west", "panel massive")
doors.set_state(get_room(520, 94), "west", {action = "key"})