-- Trigger: phase_3_ranger_helm
-- Zone: 555, ID: 34
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55534

-- Converted from DG Script #55534: phase_3_ranger_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for rangers only
if actor.class == "ranger" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"A cap for ya? Well now I can make a nice cap for the ranger types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 radiant aquamarines, and a Tarnished Coif.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for rangers only.")
end