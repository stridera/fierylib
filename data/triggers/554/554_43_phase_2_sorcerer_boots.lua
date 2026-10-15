-- Trigger: phase_2_sorcerer_boots
-- Zone: 554, ID: 43
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55443

-- Converted from DG Script #55443: phase_2_sorcerer_boots
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"slippers"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

-- 
-- Boots ya ask?
-- 
-- This is for sorcerers only
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Boots ya ask? Well now I can make a fine pair of slippers for the\"")
    actor:send(tostring(self.name) .. " tells you, \"sorcerer types but I'll need 3 uncut sapphires, and\"")
    actor:send(tostring(self.name) .. " tells you, \"a set of Burned Slippers. Return these things to me in any\"")
    actor:send(tostring(self.name) .. " tells you, \"order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for sorcerers only.")
end