-- Trigger: shaman_greet1
-- Zone: 481, ID: 35
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48135

-- Converted from DG Script #48135: shaman_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.id == -1 then
    self:say("Welcome, adventurer, have you come to help us in our time of need?")
end