-- Trigger: fish-death
-- Zone: 103, ID: 1
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #10301
-- On the fish mob's death, drop a fish-corpse object (103,11) in
-- the room. Used to seed the resort_cooking stage 3 ingredient.

self.room:spawn_object(103, 11)
