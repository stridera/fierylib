-- Trigger: phase_2_rogue_boots
-- Zone: 554, ID: 23
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55423

-- Converted from DG Script #55423: phase_2_rogue_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for rogues only
if (actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"rogue types but I'll need 3 uncut topazes, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Crushed Chain Boots. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for rogues only.")
end