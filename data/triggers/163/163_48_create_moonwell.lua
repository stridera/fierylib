-- Trigger: create_moonwell
-- Zone: 163, ID: 48
-- Type: WORLD, Flags: GLOBAL
--
-- Original DG Script: #16348
-- Probability: 0% — invoked manually via run_room_trigger(163, 48) from
-- 16363 at the climax of the moonwell ceremony.
--
-- Spawns the moonwell object (vnum 33 in legacy zone 0) into self.room.

self.room:spawn_object(0, 33)
