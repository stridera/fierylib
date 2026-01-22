-- Trigger: phase_2_warrior_plate
-- Zone: 554, ID: 38
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55438

-- Converted from DG Script #55438: phase_2_warrior_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for warriors only
if actor.class == "warrior" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the warriors but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 emerald shards, and a Crushed Plate. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for warriors only.")
end