-- Trigger: phase_3_druid_bracer
-- Zone: 554, ID: 89
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55489

-- Converted from DG Script #55489: phase_3_druid_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for druids only
if actor.class == "druid" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"druid types but I'll need 3 perfect citrines, and a Corroded Wristband.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end