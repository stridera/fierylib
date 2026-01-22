-- Trigger: phase_2_necromancer_vambraces
-- Zone: 553, ID: 96
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55396

-- Converted from DG Script #55396: phase_2_necromancer_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for necromancers only
if actor.class == "necromancer" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Sleeves ya ask? Well now I can make a fine set of sleeves for\"")
    actor:send(tostring(self.name) .. " tells you, \"the necromancer types but I'll need 3 ambers, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Burned Sleeves. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for necromancers only.")
end