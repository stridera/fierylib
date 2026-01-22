-- Trigger: infidel_speak2
-- Zone: 480, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48022

-- Converted from DG Script #48022: infidel_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: challenge?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "challenge?")) then
    return true  -- No matching keywords
end
self:say("Yes, challenge.  I presume you have been sent by that young upstart.")
self:command("spit")
wait(1)
self:say("If you haven't, then you had better leave before my patience wears thin.")
self:command("ponder")
wait(1)
self:say("And if you have, then you'd better leave before I kill you.")
self:command("pat " .. tostring(actor.name))
self:say("Run along now little one.")