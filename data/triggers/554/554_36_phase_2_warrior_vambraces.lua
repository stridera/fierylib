-- Trigger: phase_2_warrior_vambraces
-- Zone: 554, ID: 36
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55436

-- Converted from DG Script #55436: phase_2_warrior_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for warriors only
if actor.class == "warrior" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Vambraces ya ask? Well now I can make a fine set of vambraces for\"")
    actor:send(tostring(self.name) .. " tells you, \"the warrior types but I'll need 3 quantities of some diamond dust, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Vambraces. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for warriors only.")
end