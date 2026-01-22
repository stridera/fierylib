-- Trigger: Knight_Grum
-- Zone: 521, ID: 9
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #52109

-- Converted from DG Script #52109: Knight_Grum
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.alignment < -349 then
    self:command("roar")
    self:command("glance " .. tostring(actor.name))
    self:say("I see you have lowered yourself to the ways of evil")
    wait(2)
    self:say("For this, you shall die a terrible death")
    combat.engage(self, actor.name)
elseif actor.alignment > 349 then
    self:command("bow " .. tostring(actor.name))
    self:say("Finally a good soul has made its way down through this terrible ship")
    self:say("Perhaps you would care to aid me in killing the awful Queen Tira")
end