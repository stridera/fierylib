-- Trigger: phase_3_monk_gauntlets
-- Zone: 555, ID: 5
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55505

-- Converted from DG Script #55505: phase_3_monk_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"fist", "wraps", "fistwraps"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

-- 
-- Gauntlets ya ask?
-- 
-- This is for monks only
if actor.class == "monk" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Gloves? Well now I can make a fine pair of Fistwraps for the\"")
    actor:send(tostring(self.name) .. " tells you, \"monk types but I'll need 3 perfect chrysobeyrls, and a set of Corroded\"")
    actor:send(tostring(self.name) .. " tells you, \"Gloves. Return these things to me in any order at any time and\"")
    actor:send(tostring(self.name) .. " tells you, \"I will reward you.\"")
else
    actor:send("Sorry this quest is for monks only.")
end