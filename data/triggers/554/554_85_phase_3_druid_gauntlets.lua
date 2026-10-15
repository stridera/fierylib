-- Trigger: phase_3_druid_gauntlets
-- Zone: 554, ID: 85
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55485

-- Converted from DG Script #55485: phase_3_druid_gauntlets
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"glove", "gloves"}) do
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
-- This is for druids only
if actor.class == "druid" and actor.level >= 41 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Gloves? Well now I can make a fine pair of gloves for the\"")
    actor:send(tostring(self.name) .. " tells you, \"druid types but I'll need 3 handfulls of tourmalines, and a\"")
    actor:send(tostring(self.name) .. " tells you, \"set of Corroded Gloves. Return these things to me in any order\"")
    actor:send(tostring(self.name) .. " tells you, \"at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for druids only.")
end