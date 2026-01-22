-- Trigger: Tr'ven (Speak fix)
-- Zone: 87, ID: 91
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8791

-- Converted from DG Script #8791: Tr'ven (Speak fix)
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: fix
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "fix")) then
    return true  -- No matching keywords
end
wait(10)
self:say("Yes i can fix just about anything that is broken or outdated.")
wait(5)
self:say("Lots of old Adventures have been bringing me items like ivory weddingbands.")
wait(5)
self:say("or Armor That they have Earned from there guilds and haveing me fix them up.")
wait(5)
self:say("to be as good as the items the would be rewarded with today.")
wait(5)
self:say("just hand me items and I'll get started")