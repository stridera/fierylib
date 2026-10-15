-- Trigger: facade wear trigger
-- Zone: 625, ID: 81
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #62581

-- Converted from DG Script #62581: facade wear trigger
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
wait(0.1)
actor:send("<b:black>Your skin hardens and turns to stone!</>")
self.room:send_except(actor, "<b:black>" .. tostring(actor.name) .. "'s skin hardens and turns to stone!")