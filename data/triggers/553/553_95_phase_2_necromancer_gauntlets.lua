-- Trigger: phase_2_necromancer_gauntlets
-- Zone: 553, ID: 95
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55395

-- Converted from DG Script #55395: phase_2_necromancer_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for necromancers only
if actor.class == "necromancer" and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gloves? Well now I can make a fine pair of gloves for the\"")
    actor:send(tostring(self.name) .. " tells you, \"necromancer types but I'll need 3 uncut lapis-lazulis, and a set\"")
    actor:send(tostring(self.name) .. " tells you, \"of Burned Mittens. Return these things to me in any order at any\"")
    actor:send(tostring(self.name) .. " tells you, \"time and I will reward you.\"")
else
    actor:send("Sorry this quest is for necromancers only.")
end