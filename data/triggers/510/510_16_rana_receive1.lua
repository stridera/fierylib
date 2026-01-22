-- Trigger: rana_receive1
-- Zone: 510, ID: 16
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #51016

-- Converted from DG Script #51016: rana_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
self:emote("examines her new prize briefly.")
self:say("So...this is it eh?  The legendary protection spell!")
self:command("remove page")
self:command("drop page")
self:command("hold magic")
self:follow(actor.name)
self:say("Take me to Luchiaans now - I am ready to terminate his sorry existence!")