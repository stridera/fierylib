-- Trigger: painting-speech
-- Zone: 238, ID: 57
-- Type: WORLD, Flags: SPEECH
--
-- The ceiling painting acknowledges greetings only if the speaker has detect
-- magic active; otherwise the painting's reply is unintelligible.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hi", "hello", "hi?", "greetings", "greeting"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:has_effect(Effect.DetectMagic) then
    actor:send("The painting speaks to you. 'Oh, are you here to ask about the quest?'")
    self.room:send_except(actor, "The painting on the ceiling speaks softly in a foreign tongue to " .. tostring(actor.name) .. ".")
else
    actor:send("The painting speaks, but you do not feel that you understand its magical words.")
end
