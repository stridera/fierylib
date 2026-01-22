-- Trigger: seer_speak3
-- Zone: 85, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8518

-- Converted from DG Script #8518: seer_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: worthy?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "worthy?")) then
    return true  -- No matching keywords
end
self:say("Only the sharpest of minds can answer the riddle my master dictated to me.")
self:command("sigh")
wait(1)
self:say("You, I fear, are not of sharp mind.")
self:emote("casts his hollow eye sockets upon you.")
self:say("Or body.")
self:command("smile seer")