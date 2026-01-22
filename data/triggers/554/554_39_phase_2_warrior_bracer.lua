-- Trigger: phase_2_warrior_bracer
-- Zone: 554, ID: 39
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55439

-- Converted from DG Script #55439: phase_2_warrior_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for warriors only
if actor.class == "warrior" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"warrior types but I'll need 3 uncut aquamarines, and a Crushed Plate\"")
    actor:send(tostring(self.name) .. " tells you, \"Bracer. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for warriors only.")
end