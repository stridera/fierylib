-- Trigger: phase_2_druid_gauntlets
-- Zone: 553, ID: 75
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55375

-- Converted from DG Script #55375: phase_2_druid_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for druids only
if actor.class == "druid" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gloves? Well now I can make a fine pair of gloves for the\"")
    actor:send(tostring(self.name) .. " tells you, \"druid types but I'll need 3 uncut ambers, and a set of Burned\"")
    actor:send(tostring(self.name) .. " tells you, \"Gloves. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end