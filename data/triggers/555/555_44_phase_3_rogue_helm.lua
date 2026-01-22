-- Trigger: phase_3_rogue_helm
-- Zone: 555, ID: 44
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55544

-- Converted from DG Script #55544: phase_3_rogue_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for rogues only
if (actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"A cap for ya? Well now I can make a nice cap for the rogue types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 perfect sapphires, and a Tarnished Coif.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for rogues only.")
end