-- Trigger: phase_1_cleric_gauntlets
-- Zone: 553, ID: 6
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55306

-- Converted from DG Script #55306: phase_1_cleric_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for clerics only
local CLERIC_SUB = (actor.class == cleric  or  actor.class == priest  or  actor.class == diabolist  or  actor.class == druid)
if CLERIC_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gauntlets? Well now I can make a fine pair of gauntlets for the\"")
    actor:send(tostring(self.name) .. " tells you, \"cleric types but I'll need 3 crushed ambers, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Rusted Gauntlets. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end