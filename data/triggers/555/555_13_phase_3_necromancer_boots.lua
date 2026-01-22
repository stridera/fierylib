-- Trigger: phase_3_necromancer_boots
-- Zone: 555, ID: 13
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55513

-- Converted from DG Script #55513: phase_3_necromancer_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Boots ya ask?
-- 
-- This is for necromancers only
if actor.class == "necromancer" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of slippers for the\"")
    actor:send(tostring(self.name) .. " tells you, \"necromancer types but I'll need 3 radiant citrines, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Worn Slippers. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for necromancers only.")
end