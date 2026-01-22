-- Trigger: phase_3_paladin_boots
-- Zone: 555, ID: 23
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55523

-- Converted from DG Script #55523: phase_3_paladin_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for paladins only
if actor.class == "paladin" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"paladin types but I'll need 3 pearls, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Tarnished Plate Boots. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for paladins only.")
end