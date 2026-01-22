-- Trigger: phase_3_sorcerer_helm
-- Zone: 554, ID: 94
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55494

-- Converted from DG Script #55494: phase_3_sorcerer_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for sorcerers only
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"A skullcap for ya? Well now I can make a nice coif for the sorcerer types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 handfulls of aquamarines, and a Worn Turban.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end