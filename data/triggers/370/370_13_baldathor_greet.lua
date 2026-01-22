-- Trigger: baldathor_greet
-- Zone: 370, ID: 13
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #37013

-- Converted from DG Script #37013: baldathor_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
actor:send("The warrior's eyes begin to glow <b:red>red</> as he looks straight at you!")
wait(1)
self:command("snarl " .. tostring(actor))