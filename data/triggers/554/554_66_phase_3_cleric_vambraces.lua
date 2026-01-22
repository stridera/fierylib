-- Trigger: phase_3_cleric_vambraces
-- Zone: 554, ID: 66
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55466

-- Converted from DG Script #55466: phase_3_cleric_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for clerics only
if (actor.class == "cleric" or actor.class == "priest") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Vambraces ya ask? Well now I can make a fine set of vambraces for\"")
    actor:send(tostring(self.name) .. " tells you, \"the cleric types but I'll need 3 flawed opals, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Tarnished Vambraces. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end