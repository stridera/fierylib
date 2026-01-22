-- Trigger: phase_2_rogue_gauntlets
-- Zone: 554, ID: 25
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55425

-- Converted from DG Script #55425: phase_2_rogue_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for rogues only
if (actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gloves? Well now I can make a fine pair of gloves for the\"")
    actor:send(tostring(self.name) .. " tells you, \"rogue types but I'll need 3 uncut jades, and a set of Crushed\"")
    actor:send(tostring(self.name) .. " tells you, \"Chain Gloves. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for rogues only.")
end