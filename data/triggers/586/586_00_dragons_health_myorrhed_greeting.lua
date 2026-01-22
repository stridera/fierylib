-- Trigger: dragons_health_myorrhed_greeting
-- Zone: 586, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #58600

-- Converted from DG Script #58600: dragons_health_myorrhed_greeting
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor:get_quest_stage("dragons_health") > 0 then
    self:command("wave " .. tostring(actor.name))
    self:say("Welcome back!")
elseif actor.id == -1 then
    self:command("growl " .. tostring(actor.name))
    self:say("Stay back!  I will not allow you to harm this egg!")
end