-- Trigger: Tr'ven(greet)
-- Zone: 87, ID: 95
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8795

-- Converted from DG Script #8795: Tr'ven(greet)
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
if actor.id == -1 then
    self:say("Welcome to my shop. Is there something I can fix for you?")
end