-- Trigger: hermit_speak2
-- Zone: 490, ID: 38
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49038

-- Converted from DG Script #49038: hermit_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"ladder?", "ladder"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("griffin_quest") > 0 then
    self:say("I do have a slightly used rope ladder, which I will trade with you.")
    wait(0.1)
    self:say("It's magical and will automatically deploy if you drop it in the right area to get down to St. Marvin.")
end