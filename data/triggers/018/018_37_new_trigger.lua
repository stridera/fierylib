-- Trigger: new trigger
-- Zone: 18, ID: 37
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #1837

-- Converted from DG Script #1837: new trigger
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
self.room:send("There are " .. tostring(people.self) .. " people here")