-- Trigger: catherine_theo
-- Zone: 43, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4331

-- Converted from DG Script #4331: catherine_theo
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"i", "want", "my", "duck!", "duck"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.zone_id == 43 and actor.local_id == 10 then
    self:say("Theo, I don't have time for this!")
    wait(2)
    self:say("We'll get your duck as soon as I can find my key!")
end