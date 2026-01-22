-- Trigger: phase_1_sorcerer_boots
-- Zone: 553, ID: 23
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55323

-- Converted from DG Script #55323: phase_1_sorcerer_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Sandals/slippers ya ask?
-- 
-- This is for sorcerers only
local SORC_SUB = (actor.class == "sorcerer"  or  actor.class == "necromancer"  or  actor.class == "conjurer"  or  actor.class == "cryomancer"  or  actor.class == "pyromancer")
if SORC_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Sandals ya ask? Well now I can make a fine pair of sandals for the\"")
    actor:send(tostring(self.name) .. " tells you, \"sorcerer types but I'll need 3 crushed garnets, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Decayed Slippers. Return these things to me in any order at\"")
    actor:send(tostring(self.name) .. " tells you, \"any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end