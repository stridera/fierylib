-- Trigger: phase_3_diabolist_boots
-- Zone: 554, ID: 73
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55473

-- Converted from DG Script #55473: phase_3_diabolist_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for diabolists only
if actor.class == "diabolist" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"diabolist types but I'll need 3 cursed pearls, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Tarnished Plate Boots. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for diabolists only.")
end