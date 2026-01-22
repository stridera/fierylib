-- Trigger: phase_2_monk_gauntlets
-- Zone: 553, ID: 85
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55385

-- Converted from DG Script #55385: phase_2_monk_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for monks only
if actor.class == "monk" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gloves? Well now I can make a fine pair of Fistwraps for the\"")
    actor:send(tostring(self.name) .. " tells you, \"monk types but I'll need 3 uncut turquoises, and a set of Burned\"")
    actor:send(tostring(self.name) .. " tells you, \"Gloves. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for monks only.")
end