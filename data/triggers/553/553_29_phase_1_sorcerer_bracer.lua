-- Trigger: phase_1_sorcerer_bracer
-- Zone: 553, ID: 29
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55329

-- Converted from DG Script #55329: phase_1_sorcerer_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for sorcerers only
local SORC_SUB = (actor.class == "sorcerer"  or  actor.class == "necromancer"  or  actor.class == "conjurer"  or  actor.class == "cryomancer"  or  actor.class == "pyromancer")
if SORC_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracelet ya ask? Well now I can make a protective bracelet for the\"")
    actor:send(tostring(self.name) .. " tells you, \"sorcerer types but I'll need 3 crushed chrysoberyls, and a Decayed\"")
    actor:send(tostring(self.name) .. " tells you, \"Bracelet. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end