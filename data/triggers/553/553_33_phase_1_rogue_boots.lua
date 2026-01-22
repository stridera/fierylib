-- Trigger: phase_1_rogue_boots
-- Zone: 553, ID: 33
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55333

-- Converted from DG Script #55333: phase_1_rogue_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Sandals/slippers ya ask?
-- 
-- This is for rogues only
local ROG_SUB = (actor.class == "rogue"  or  actor.class == "assassin"  or  actor.class == "thief"  or  actor.class == "mercenary")
if ROG_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of boots for the\"")
    actor:send(tostring(self.name) .. " tells you, \"rogue types but I'll need 3 crushed pearls, and a set of Rusted\"")
    actor:send(tostring(self.name) .. " tells you, \"Chain Boots. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for rogues only.")
end