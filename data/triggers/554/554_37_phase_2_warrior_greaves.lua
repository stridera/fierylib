-- Trigger: phase_2_warrior_greaves
-- Zone: 554, ID: 37
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55437

-- Converted from DG Script #55437: phase_2_warrior_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for warriors only
if actor.class == "warrior" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
    actor:send(tostring(self.name) .. " tells you, \"greaves for the warrior types but I'll need 3 perfect amythests, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Greaves. Return these things\"")
    actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for warriors only.")
end