-- Trigger: phase_3_sorcerer_vambraces
-- Zone: 554, ID: 96
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55496

-- Converted from DG Script #55496: phase_3_sorcerer_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for sorcerers only
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Sleeves ya ask? Well now I can make a fine set of sleeves for\"")
    actor:send(tostring(self.name) .. " tells you, \"the sorcerer types but I'll need 3 topazes, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Worn Sleeves. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end