-- Trigger: phase_3_diabolist_gauntlets
-- Zone: 554, ID: 75
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55475

-- Converted from DG Script #55475: phase_3_diabolist_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- 
-- Gauntlets ya ask?
-- 
-- This is for diabolists only
if actor.class == "diabolist" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(2)
    actor:send(tostring(self.name) .. " tells you, \"Gauntlets? Well now I can make a fine pair of gauntlets for the\"")
    actor:send(tostring(self.name) .. " tells you, \"diabolist types but I'll need 3 perfect tourmalines, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Tarnished Gauntlets. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for diabolists only.")
end