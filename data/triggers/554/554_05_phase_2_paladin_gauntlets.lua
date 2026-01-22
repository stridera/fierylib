-- Trigger: phase_2_paladin_gauntlets
-- Zone: 554, ID: 5
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55405

-- Converted from DG Script #55405: phase_2_paladin_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for paladins only
if actor.class == "paladin" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gauntlets? Well now I can make a fine pair of gauntlets for the\"")
    actor:send(tostring(self.name) .. " tells you, \"paladin types but I'll need 3 uncut chrysobeyrls, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Gauntlets. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for paladins only.")
end