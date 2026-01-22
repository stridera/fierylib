-- Trigger: phase_2_warrior_boots
-- Zone: 554, ID: 33
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55433

-- Converted from DG Script #55433: phase_2_warrior_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for warriors only
if actor.class == "Warrior" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"warrior types but I'll need 3 quantities of some opal dust, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Plate Boots. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for warriors only.")
end