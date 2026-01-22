-- Trigger: phase_3_ranger_gauntlets
-- Zone: 555, ID: 35
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55535

-- Converted from DG Script #55535: phase_3_ranger_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for rangers only
if actor.class == "ranger" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gloves? Well now I can make a fine pair of gloves for the\"")
    actor:send(tostring(self.name) .. " tells you, \"ranger types but I'll need 3 tourmalines, and a set of Tarnished\"")
    actor:send(tostring(self.name) .. " tells you, \"Chain Gloves. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for rangers only.")
end