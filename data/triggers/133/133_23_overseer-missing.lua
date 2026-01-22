-- Trigger: overseer-missing
-- Zone: 133, ID: 23
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #13323

-- Converted from DG Script #13323: overseer-missing
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
self:command("fume")
self:say("I know I left it in plain sight in the break room!")
self:say("There must be a thief about!")
self:command("glare " .. tostring(actor.name))