-- Trigger: phase_3_necromancer_bracer
-- Zone: 555, ID: 19
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55519

-- Converted from DG Script #55519: phase_3_necromancer_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for necromancers only
if actor.class == "necromancer" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracelet for the\"")
    actor:send(tostring(self.name) .. " tells you, \"necromancer types but I'll need 3 perfect jades, and a\"")
    actor:send(tostring(self.name) .. " tells you, \"Worn Bracelet. Return these things to me in any order at any\"")
    actor:send(tostring(self.name) .. " tells you, \"time and I will reward you.\"")
else
    actor:send("Sorry this quest is for necromancers only.")
end