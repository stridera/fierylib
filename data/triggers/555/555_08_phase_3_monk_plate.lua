-- Trigger: phase_3_monk_plate
-- Zone: 555, ID: 8
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55508

-- Converted from DG Script #55508: phase_3_monk_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for monks only
if actor.class == "monk" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine tunic for the monks but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 cursed rubies, and a Corroded Jerkin. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for monks only.")
end