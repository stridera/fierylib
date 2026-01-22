-- Trigger: phase_3_anti-paladin_boots
-- Zone: 554, ID: 53
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55453

-- Converted from DG Script #55453: phase_3_anti-paladin_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "Anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"anti-paladin types but I'll need 3 handfulls of pearls, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Tarnished Plate Boots. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end