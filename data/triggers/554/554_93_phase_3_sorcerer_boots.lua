-- Trigger: phase_3_sorcerer_boots
-- Zone: 554, ID: 93
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55493

-- Converted from DG Script #55493: phase_3_sorcerer_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for sorcerers only
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of slippers for the\"")
    actor:send(tostring(self.name) .. " tells you, \"sorcerer types but I'll need 3 flawed topazes, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Worn Slippers. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end