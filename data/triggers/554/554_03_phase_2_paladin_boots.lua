-- Trigger: phase_2_paladin_boots
-- Zone: 554, ID: 3
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55403

-- Converted from DG Script #55403: phase_2_paladin_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for paladins only
if actor.class == "paladin" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"paladin types but I'll need 3 jade shards, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Crushed Plate Boots. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for paladins only.")
end