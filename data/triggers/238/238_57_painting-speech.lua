-- Trigger: painting-speech
-- Zone: 238, ID: 57
-- Type: WORLD, Flags: SPEECH
--
-- The ceiling painting acknowledges greetings only if the speaker has detect
-- magic active; otherwise the painting's reply is unintelligible.

-- Speech keywords: hi hello hi? greetings greeting
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "hi") or string.find(speech_lower, "hello") or string.find(speech_lower, "greeting")) then
    return true  -- No matching keywords
end
if actor:has_effect(Effect.DetectMagic) then
    actor:send("The painting speaks to you. 'Oh, are you here to ask about the quest?'")
    self.room:send_except(actor, "The painting on the ceiling speaks softly in a foreign tongue to " .. tostring(actor.name) .. ".")
else
    actor:send("The painting speaks, but you do not feel that you understand its magical words.")
end
