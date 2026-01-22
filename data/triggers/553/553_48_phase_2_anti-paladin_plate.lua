-- Trigger: phase_2_anti-paladin_plate
-- Zone: 553, ID: 48
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55348

-- Converted from DG Script #55348: phase_2_anti-paladin_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Plate ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "Anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the anti-paladins but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 emeralds, and a Crushed Plate. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end