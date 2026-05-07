-- Trigger: room_occupant_count_debug
-- Zone: 18, ID: 37
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #1837

-- Converted from DG Script #1837: new trigger
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
-- Debug echo of room occupancy. The legacy DG used %people.self% which referred
-- to the actor count for the room.
self.room:send("There are " .. tostring(#self.actors) .. " people here")