-- Trigger: phase_3_druid_helm
-- Zone: 554, ID: 84
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55484

-- Converted from DG Script #55484: phase_3_druid_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for druids only
if actor.class == "druid" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"A cap for ya? Well now I can make a nice cap for the druid types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 enchanted topazs, and a Corroded Cap.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end