-- Trigger: phase_3_ranger_plate
-- Zone: 555, ID: 38
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55538

-- Converted from DG Script #55538: phase_3_ranger_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for rangers only
if actor.class == "ranger" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine jerkin for the rangers but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 enchanted rubies, and a Tarnished Tunic. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for rangers only.")
end