-- Trigger: friend?
-- Zone: 200, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20003

-- Converted from DG Script #20003: friend?
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: friend
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "friend")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    self:say("Then you are not welcome here, you must leave at once!")
    actor.name:move("w")
end