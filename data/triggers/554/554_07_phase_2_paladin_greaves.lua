-- Trigger: phase_2_paladin_greaves
-- Zone: 554, ID: 7
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55407

-- Converted from DG Script #55407: phase_2_paladin_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for paladins only
if actor.class == "paladin" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
    actor:send(tostring(self.name) .. " tells you, \"greaves for the paladin types but I'll need 3 radiant amythests, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Greaves. Return these things\"")
    actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for paladins only.")
end