-- Trigger: phase_3_sorcerer_plate
-- Zone: 554, ID: 98
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55498

-- Converted from DG Script #55498: phase_3_sorcerer_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for sorcerers only
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine robe for the sorcerers but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 radiant emeralds, and a Worn Robe. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end