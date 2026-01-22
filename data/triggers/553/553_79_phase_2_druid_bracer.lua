-- Trigger: phase_2_druid_bracer
-- Zone: 553, ID: 79
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55379

-- Converted from DG Script #55379: phase_2_druid_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for druids only
if actor.class == "druid" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"druid types but I'll need 3 flawed ambers, and a Burned Wristband.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end