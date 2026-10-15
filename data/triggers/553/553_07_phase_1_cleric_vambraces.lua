-- Trigger: phase_1_cleric_vambraces
-- Zone: 553, ID: 7
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #55307

-- Converted from DG Script #55307: phase_1_cleric_vambraces
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"vambraces"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

-- 
-- Vambraces ya ask?
-- 
-- This is for clerics only
local CLERIC_SUB = (actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid")
if CLERIC_SUB and actor.level >= 1 and actor:get_quest_stage("phase_armor") >= 1 then
    wait(0.2)
    actor:send(tostring(self.name) .. " tells you, \"Vambraces ya ask? Well now I can make a fine set of vambraces for\"")
    actor:send(tostring(self.name) .. " tells you, \"the cleric types but I'll need 3 quantities of some lapis-lazuli\"")
    actor:send(tostring(self.name) .. " tells you, \"dust, and a set of Rusted Vambraces. Return these things to me in\"")
    actor:send(tostring(self.name) .. " tells you, \"any order at any time and I will reward you.\"")
else
    actor:send("Sorry this quest is for clerics only.")
end