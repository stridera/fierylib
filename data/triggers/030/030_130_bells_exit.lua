-- Trigger: Bells Exit
-- Zone: 30, ID: 130
-- Type: OBJECT, Flags: LEAVE
-- Status: CLEAN
--
-- Original DG Script: #3130

-- Converted from DG Script #3130: Bells Exit
-- Original: OBJECT trigger, flags: LEAVE, probability: 100%
self.room:send_except(actor, tostring(actor.name) .. " bells ring as she leaves the room.")
actor:send("The bells on your hat ring as you walk.")