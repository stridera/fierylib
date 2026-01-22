-- Trigger: lewis_greet
-- Zone: 43, ID: 67
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #4367

-- Converted from DG Script #4367: lewis_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if self.room == 4345 and actor:get_quest_stage("theatre") == 2 then
    wait(2)
    self:say("You mean I can leave now?  Oh thank heaven!")
    self:command("bounce")
    wait(2)
    self:say("I'm positively famished!")
    wait(1)
    self:say("May I please have my dressing room key back now?")
end