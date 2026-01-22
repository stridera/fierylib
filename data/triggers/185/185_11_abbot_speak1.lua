-- Trigger: abbot_speak1
-- Zone: 185, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #18511

-- Converted from DG Script #18511: abbot_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: prior prior?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "prior") or string.find(string.lower(speech), "prior?")) then
    return true  -- No matching keywords
end
self:command("peer " .. tostring(actor.name))
self:say("Anything you heard about Berack is pure hearsay.")
self:command("sigh")
self:say("That young man has enough to worry about without people bringing up his family all the time.")