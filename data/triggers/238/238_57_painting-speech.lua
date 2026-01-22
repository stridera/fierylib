-- Trigger: painting-speech
-- Zone: 238, ID: 57
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23857

-- Converted from DG Script #23857: painting-speech
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hi hello hi? greetings greeting
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "hi?") or string.find(string.lower(speech), "greetings") or string.find(string.lower(speech), "greeting")) then
    return true  -- No matching keywords
end
if actor:has_effect(Effect.Det_Magic) == 1 then
    actor:send("The painting speaks to you. 'Oh, are you here to ask about the quest?'")
    self.room:send_except(actor, "The painting on the ceiling speaks softly in a foreign tongue to " .. tostring(actor.name) .. ".")
else
    actor:send("The painting speaks, but you do not feel that you understand its magical words.")
end