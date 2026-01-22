-- Trigger: phase_3_diabolist_plate
-- Zone: 554, ID: 78
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55478

-- Converted from DG Script #55478: phase_3_diabolist_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for diabolists only
if actor.class == "diabolist" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine chestguard for the diabolists but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 cursed diamonds, and a Tarnished Plate. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for diabolists only.")
end