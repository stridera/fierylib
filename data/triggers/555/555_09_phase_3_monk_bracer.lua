-- Trigger: phase_3_monk_bracer
-- Zone: 555, ID: 9
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55509

-- Converted from DG Script #55509: phase_3_monk_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for monks only
if actor.class == "monk" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracer for the\"")
    actor:send(tostring(self.name) .. " tells you, \"monk types but I'll need 3 radiant jades, and a Corroded Wristband.\"")
    actor:send(tostring(self.name) .. " tells you, \"Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for monks only.")
end