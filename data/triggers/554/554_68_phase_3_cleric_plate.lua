-- Trigger: phase_3_cleric_plate
-- Zone: 554, ID: 68
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55468

-- Converted from DG Script #55468: phase_3_cleric_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for clerics only
if (actor.class == "cleric" or actor.class == "priest") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the clerics but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 perfect rubies, and a Tarnished Plate. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end