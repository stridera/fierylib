-- Trigger: phase_1_rogue_bracer
-- Zone: 553, ID: 39
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55339

-- Converted from DG Script #55339: phase_1_rogue_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for rogues only
local ROG_SUB = (actor.class == "rogue"  or  actor.class == "assassin"  or  actor.class == "thief"  or  actor.class == "mercenary")
if ROG_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective wristgard for the\"")
    actor:send(tostring(self.name) .. " tells you, \"rogue types but I'll need 3 crushed tourmalines, and a Rusted\"")
    actor:send(tostring(self.name) .. " tells you, \"Chain Bracer. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for rogues only.")
end