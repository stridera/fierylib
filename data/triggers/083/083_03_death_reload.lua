-- Trigger: Death_reload
-- Zone: 83, ID: 3
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- On this mob's death, respawn replacement mob (83, 9) in room (83, 123).
--
-- Original DG Script: #8303
get_room(83, 123):spawn_mobile(83, 9)