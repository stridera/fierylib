-- Trigger: Ranger responds to hello
-- Zone: 502, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #50211

-- Converted from DG Script #50211: Ranger responds to hello
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hi hello
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello")) then
    return true  -- No matching keywords
end
if actor.id == -1 and actor.level < 100 then
    wait(6)
    self:command("bow " .. tostring(actor.name))
    wait(2)
    self:say("Have a care in these swamps, little one, for evil is afoot.")
end