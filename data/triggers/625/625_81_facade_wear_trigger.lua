-- Trigger: facade wear trigger
-- Zone: 625, ID: 81
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #62581

-- Converted from DG Script #62581: facade wear trigger
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
wait(1)
actor:send("&9<blue>Your skin hardens and turns to stone!</>")
self.room:send_except(actor, "&9<blue>" .. tostring(actor.name) .. "'s skin hardens and turns to stone!")