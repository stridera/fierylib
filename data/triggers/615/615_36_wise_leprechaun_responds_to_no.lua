-- Trigger: Wise leprechaun responds to 'no'
-- Zone: 615, ID: 36
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61536

-- Converted from DG Script #61536: Wise leprechaun responds to 'no'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    if actor.gender == "female" then
        self:say("Well skedaddle off and fetch some then, won't you lass?")
    else
        self:say("Well skedaddle off and fetch some then, won't you laddie?")
    end
end