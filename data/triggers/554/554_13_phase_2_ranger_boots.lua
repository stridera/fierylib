-- Trigger: phase_2_ranger_boots
-- Zone: 554, ID: 13
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55413

-- Converted from DG Script #55413: phase_2_ranger_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for rangers only
if actor.class == "ranger" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"ranger types but I'll need 3 flawed tourmalines, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Chain Boots. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for rangers only.")
end