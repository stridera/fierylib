-- Trigger: phase_2_monk_plate
-- Zone: 553, ID: 88
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55388

-- Converted from DG Script #55388: phase_2_monk_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for monks only
if actor.class == "monk" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine tunic for the monks but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 handful of rubies, and a Burned Jerkin. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for monks only.")
end