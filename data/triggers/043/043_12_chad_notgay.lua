-- Trigger: chad_notgay
-- Zone: 43, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4312

-- Converted from DG Script #4312: chad_notgay
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"oh", "don't", "worry", "i", "can", "make", "it", "worth", "your", "time.", "time"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.zone_id == 43 and actor.local_id == 2 then
    wait(0.5)
    self:emote("scoots away from his fellow player.")
    wait(3)
    self:say("I just don't know...  I mean, I COULD be...")
    wait(0.5)
    self:emote("is so confused by it all!")
end