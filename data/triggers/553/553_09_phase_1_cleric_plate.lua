-- Trigger: phase_1_cleric_plate
-- Zone: 553, ID: 9
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55309

-- Converted from DG Script #55309: phase_1_cleric_plate
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
-- This is for clerics only
local CLERIC_SUB = (actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid")
if CLERIC_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Body armor? Well now I can make a fine plate for the clerics but\"")
    actor:send(tostring(self.name) .. " tells you, \"I'll need 3 crushed rubies, and a Rusted Plate. Return these\"")
    actor:send(tostring(self.name) .. " tells you, \"things to me in any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end