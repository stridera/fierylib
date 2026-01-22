-- Trigger: phase_1_sorcerer_helm
-- Zone: 553, ID: 24
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55324

-- Converted from DG Script #55324: phase_1_sorcerer_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for sorcerers only
local SORC_SUB = (actor.class == "sorcerer"  or  actor.class == "necromancer"  or  actor.class == "conjurer"  or  actor.class == "cryomancer"  or  actor.class == "pyromancer")
if SORC_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Turban ya ask? Well now I can make a nice turban for the sorcerer types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 quantities of some tourmaline dust, and a Decayed\"")
    actor:send(tostring(self.name) .. " tells you, \"Turban. Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end