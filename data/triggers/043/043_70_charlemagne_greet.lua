-- Trigger: charlemagne_greet
-- Zone: 43, ID: 70
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #4370

-- Converted from DG Script #4370: charlemagne_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if self.room == 4352 and actor:get_quest_stage("theatre") == 4 then
    wait(2)
    self:emote("breathes a sigh of relief.")
    wait(1)
    self:say("Finally!  I was about to break down the door to escape!")
    wait(1)
    self:command("grumble")
    wait(3)
    self:say("If you have my dressing room key, please hand it over.")
end