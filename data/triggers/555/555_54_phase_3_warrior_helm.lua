-- Trigger: phase_3_warrior_helm
-- Zone: 555, ID: 54
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55554

-- Converted from DG Script #55554: phase_3_warrior_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for warriors only
if actor.class == "warrior" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Helm ya ask? Well now I can make a nice helm for the warrior types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 sapphires, and a Tarnished\"")
    actor:send(tostring(self.name) .. " tells you, \"Helm. Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for warriors only.")
end