-- Trigger: phase_3_diabolist_helm
-- Zone: 554, ID: 74
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55474

-- Converted from DG Script #55474: phase_3_diabolist_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for diabolists only
if actor.class == "diabolist" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Helm ya ask? Well now I can make a nice helm for the diabolist types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 cursed aquamarines, and a Tarnished\"")
    actor:send(tostring(self.name) .. " tells you, \"Helm. Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for diabolists only.")
end