-- Trigger: phase_2_ranger_vambraces
-- Zone: 554, ID: 16
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55416

-- Converted from DG Script #55416: phase_2_ranger_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for rangers only
if actor.class == "ranger" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Sleeves ya ask? Well now I can make a fine set of sleeves for\"")
    actor:send(tostring(self.name) .. " tells you, \"the ranger types but I'll need 3 flawed chrysobeyrls, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Sleeves. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for rangers only.")
end