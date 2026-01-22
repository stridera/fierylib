-- Trigger: phase_3_druid_gauntlets
-- Zone: 554, ID: 85
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55485

-- Converted from DG Script #55485: phase_3_druid_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for druids only
if actor.class == "druid" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gloves? Well now I can make a fine pair of gloves for the\"")
    actor:send(tostring(self.name) .. " tells you, \"druid types but I'll need 3 handfulls of tourmalines, and a\"")
    actor:send(tostring(self.name) .. " tells you, \"set of Corroded Gloves. Return these things to me in any order\"")
    actor:send(tostring(self.name) .. " tells you, \"at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end