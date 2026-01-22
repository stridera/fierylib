-- Trigger: captain_guard_speak2
-- Zone: 86, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8603

-- Converted from DG Script #8603: captain_guard_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: friend friend?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "friend") or string.find(string.lower(speech), "friend?")) then
    return true  -- No matching keywords
end
self:say("Very good!")
self:command("unlock trellis")
self:command("open trellis")
self:say("Welcome to the Kingdom of the Meer Cats.")
self:command("bow " .. tostring(actor.name))