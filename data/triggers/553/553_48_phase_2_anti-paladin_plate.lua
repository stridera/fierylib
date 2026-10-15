-- Trigger: phase_2_anti-paladin_plate
-- Zone: 553, ID: 48
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55348

-- Converted from DG Script #55348: phase_2_anti-paladin_plate
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"plate"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

-- 
-- Plate ya ask?
-- 
-- This is for anti-paladins only
if string.find(actor.class, "anti") and actor.level >= 21 and actor:get_quest_stage("phase_armor") >= 2 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the anti-paladins but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 emeralds, and a Crushed Plate. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for anti-paladins only.")
end