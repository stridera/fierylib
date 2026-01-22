-- Trigger: phase_3_druid_vambraces
-- Zone: 554, ID: 86
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55486

-- Converted from DG Script #55486: phase_3_druid_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for druids only
if actor.class == "druid" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Sleeves ya ask? Well now I can make a fine set of sleeves for\"")
    actor:send(tostring(self.name) .. " tells you, \"the druid types but I'll need 3 radiant garnets, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Corroded Vambraces. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end