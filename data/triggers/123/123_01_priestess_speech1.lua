-- Trigger: priestess_speech1
-- Zone: 123, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12301

-- Converted from DG Script #12301: priestess_speech1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"assist", "assistance", "assist?", "assistance?", "how", "what"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "assist") or string.find(speech, "assistance") or string.find(speech, "assist?") or string.find(speech, "assistance?") or string.find(speech, "how can i help?") or string.find(speech, "how can i assist?") or string.find(speech, "what can i do?") or string.find(speech, "what can i do to assist?") then
    wait(0.2)
    self.room:send(tostring(self.name) .. " says, 'Our coven came to this megalith to perform the <b:white>Great Rite of Invocation</> and summon our faerie goddess The Great Mother, the Lady of the Stars.'")
end