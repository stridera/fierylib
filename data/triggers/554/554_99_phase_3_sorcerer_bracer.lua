-- Trigger: phase_3_sorcerer_bracer
-- Zone: 554, ID: 99
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55499

-- Converted from DG Script #55499: phase_3_sorcerer_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for sorcerers only
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracelet for the\"")
    actor:send(tostring(self.name) .. " tells you, \"sorcerer types but I'll need 3 flawed aquamarines, and a\"")
    actor:send(tostring(self.name) .. " tells you, \"Worn Bracelet. Return these things to me in any order at any\"")
    actor:send(tostring(self.name) .. " tells you, \"time and I will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end