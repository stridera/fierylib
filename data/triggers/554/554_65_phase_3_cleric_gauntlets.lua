-- Trigger: phase_3_cleric_gauntlets
-- Zone: 554, ID: 65
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55465

-- Converted from DG Script #55465: phase_3_cleric_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for clerics only
if (actor.class == "cleric" or actor.class == "priest") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gauntlets? Well now I can make a fine pair of gauntlets for the\"")
    actor:send(tostring(self.name) .. " tells you, \"cleric types but I'll need 3 garnet shards, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Tarnished Gauntlets. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end