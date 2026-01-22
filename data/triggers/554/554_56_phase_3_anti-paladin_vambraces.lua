-- Trigger: phase_3_anti-paladin_vambraces
-- Zone: 554, ID: 56
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55456

-- Converted from DG Script #55456: phase_3_anti-paladin_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Vambraces ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "Anti") and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Vambraces ya ask? Well now I can make a fine set of vambraces for\"")
    actor:send(tostring(self.name) .. " tells you, \"the anti-paladin types but I'll need 3 perfect aquamarines, and a set of\"")
    actor:send(tostring(self.name) .. " tells you, \"Tarnished Vambraces. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end