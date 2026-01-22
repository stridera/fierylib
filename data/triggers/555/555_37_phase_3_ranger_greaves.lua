-- Trigger: phase_3_ranger_greaves
-- Zone: 555, ID: 37
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55537

-- Converted from DG Script #55537: phase_3_ranger_greaves
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Greaves ya ask?
-- 
-- This is for rangers only
if actor.class == "ranger" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Ah, protection for yer legs? Well now I can make a fine set of\"")
    actor:send(tostring(self.name) .. " tells you, \"pants for the ranger types but I'll need 3 radiant sapphires,\"")
    actor:send(tostring(self.name) .. " tells you, \"and a set of Tarnished Leggings. Return these things\"")
    actor:send(tostring(self.name) .. " tells you, \"to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for rangers only.")
end