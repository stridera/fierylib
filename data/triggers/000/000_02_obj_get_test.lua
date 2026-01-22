-- Trigger: obj get test
-- Zone: 0, ID: 2
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #2

-- Converted from DG Script #2: obj get test
-- Original: OBJECT trigger, flags: GET, probability: 100%
self.room:send("You hear, 'Please put me down, " .. tostring(actor.name) .. "'")