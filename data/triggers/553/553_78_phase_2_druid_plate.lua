-- Trigger: phase_2_druid_plate
-- Zone: 553, ID: 78
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55378

-- Converted from DG Script #55378: phase_2_druid_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for druids only
if actor.class == "druid" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine jerkin for the druids but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 diamonds, and a Burned Jerkin. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end