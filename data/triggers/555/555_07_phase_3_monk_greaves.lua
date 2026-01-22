-- Trigger: phase_3_monk_greaves
-- Zone: 555, ID: 7
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55507

-- Converted from DG Script #55507: phase_3_monk_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for monks only
if actor.class == "monk" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
    actor:send(tostring(self.name) .. " tells you, \"leggings for the monk types but I'll need 3 cursed opals,\"")
    actor:send(tostring(self.name) .. " tells you, \"and a set of Corroded Pants. Return these things\"")
    actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for monks only.")
end