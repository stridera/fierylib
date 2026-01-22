-- Trigger: prince_greet1
-- Zone: 480, ID: 14
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48014

-- Converted from DG Script #48014: prince_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.alignment > 349 then
    self:say("Are you here to help me?")
elseif actor.alignment < -349 then
    self:say("Are you here to challenge me?")
end