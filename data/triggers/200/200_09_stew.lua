-- Trigger: stew
-- Zone: 200, ID: 9
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #20009

-- Converted from DG Script #20009: stew
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    self:say("Would you like some stew?")
end