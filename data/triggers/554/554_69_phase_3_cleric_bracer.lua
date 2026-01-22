-- Trigger: phase_3_cleric_bracer
-- Zone: 554, ID: 69
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55469

-- Converted from DG Script #55469: phase_3_cleric_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for clerics only
if (actor.class == "cleric" or actor.class == "priest") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"cleric types but I'll need 3 aquamarine shards, and a Tarnished Plate\"")
    actor:send(tostring(self.name) .. " tells you, \"Bracer. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end