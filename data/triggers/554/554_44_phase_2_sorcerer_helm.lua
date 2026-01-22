-- Trigger: phase_2_sorcerer_helm
-- Zone: 554, ID: 44
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55444

-- Converted from DG Script #55444: phase_2_sorcerer_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for sorcerers only
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"A skullcap for ya? Well now I can make a nice coif for the sorcerer types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 enchanted amythests, and a Burned Turban.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end