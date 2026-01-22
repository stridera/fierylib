-- Trigger: phase_2_necromancer_plate
-- Zone: 553, ID: 98
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55398

-- Converted from DG Script #55398: phase_2_necromancer_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for necromancers only
if actor.class == "necromancer" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine robe for the necromancers but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 handfulls of emeralds, and a Burned Robe. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for necromancers only.")
end