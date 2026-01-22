-- Trigger: phase_1_sorcerer_greaves
-- Zone: 553, ID: 27
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55327

-- Converted from DG Script #55327: phase_1_sorcerer_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for sorcerers only
local SORC_SUB = (actor.class == "sorcerer"  or  actor.class == "necromancer"  or  actor.class == "conjurer"  or  actor.class == "cryomancer"  or  actor.class == "pyromancer")
if SORC_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
    actor:send(tostring(self.name) .. " tells you, \"pants for the sorcerer types but I'll need 3 quantities of some\"")
    actor:send(tostring(self.name) .. " tells you, \"pearl dust, and a set of Decayed Leggings. Return these things\"")
    actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end