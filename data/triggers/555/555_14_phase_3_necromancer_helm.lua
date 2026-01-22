-- Trigger: phase_3_necromancer_helm
-- Zone: 555, ID: 14
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55514

-- Converted from DG Script #55514: phase_3_necromancer_helm
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- helm ya ask?
-- 
-- This is for necromancers only
if actor.class == "necromancer" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"A skullcap for ya? Well now I can make a nice cap for the necromancer types\"")
    actor:send(tostring(self.name) .. " tells you, \"but I'll need 3 enchanted aquamarines, and a Worn Turban.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and I\"")
    actor:send(tostring(self.name) .. " tells you, \"will reward you.\"")
else
    actor:send("Sorry this quest is for necromancers only.")
end