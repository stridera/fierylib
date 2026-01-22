-- Trigger: phase_3_paladin_bracer
-- Zone: 555, ID: 29
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55529

-- Converted from DG Script #55529: phase_3_paladin_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for paladins only
if actor.class == "paladin" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"paladin types but I'll need 3 citrines, and a Tarnished Plate\"")
    actor:send(tostring(self.name) .. " tells you, \"Bracer. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for paladins only.")
end