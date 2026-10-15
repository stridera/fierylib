-- Trigger: angry-gardener_speech
-- Zone: 464, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46407

-- Converted from DG Script #46407: angry-gardener_speech
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"gardener"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.1)
self:say("Those bastards kill them all...")
self:command("grumble")
wait(0.1)
self:say("One day they'll all pay for what they did to my friends.")