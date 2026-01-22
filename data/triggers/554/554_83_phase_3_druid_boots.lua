-- Trigger: phase_3_druid_boots
-- Zone: 554, ID: 83
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55483

-- Converted from DG Script #55483: phase_3_druid_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for druids only
if actor.class == "druid" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"druid types but I'll need 3 perfect pearls, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Corroded Boots. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end