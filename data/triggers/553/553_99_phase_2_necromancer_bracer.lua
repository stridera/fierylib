-- Trigger: phase_2_necromancer_bracer
-- Zone: 553, ID: 99
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55399

-- Converted from DG Script #55399: phase_2_necromancer_bracer
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Bracer ya ask?
-- 
-- This is for necromancers only
if actor.class == "necromancer" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Bracer ya ask? Well now I can make a protective bracelet for the\"")
    actor:send(tostring(self.name) .. " tells you, \"necromancer types but I'll need 3 flawed lapis-lazulis, and a\"")
    actor:send(tostring(self.name) .. " tells you, \"Burned Bracelet. Return these things to me in any order at any\"")
    actor:send(tostring(self.name) .. " tells you, \"time and I will reward you.\"")
else
    actor:send("Sorry this quest is for necromancers only.")
end