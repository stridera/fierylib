-- Trigger: phase_3_cleric_helm
-- Zone: 554, ID: 64
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55464

-- Converted from DG Script #55464: phase_3_cleric_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for clerics only
if (actor.class == "cleric" or actor.class == "priest") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Helm ya ask? Well now I can make a nice helm for the cleric types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 handfulls of topazes, and a Tarnished\"")
    actor:send(tostring(self.name) .. " tells you, \"Helm. Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end