-- Trigger: phase_2_ranger_bracer
-- Zone: 554, ID: 19
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55419

-- Converted from DG Script #55419: phase_2_ranger_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for rangers only
if actor.class == "ranger" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"ranger types but I'll need 3 lapis-lazuli shards, and a Crushed Chain\"")
    actor:send(tostring(self.name) .. " tells you, \"Bracer. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for rangers only.")
end