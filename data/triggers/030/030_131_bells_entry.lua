-- Trigger: Bells Entry
-- Zone: 30, ID: 131
-- Type: OBJECT, Flags: GIVE
-- Status: CLEAN
--
-- Original DG Script: #3131

-- Converted from DG Script #3131: Bells Entry
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
self.room:send_except(actor, tostring(actor.name) .. " bells ring as she enters the room.")