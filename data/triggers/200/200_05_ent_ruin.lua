-- Trigger: ent_ruin
-- Zone: 200, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20005

-- Converted from DG Script #20005: ent_ruin
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I am an enemy of Ruin Wormheart
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "am") or string.find(string.lower(speech), "an") or string.find(string.lower(speech), "enemy") or string.find(string.lower(speech), "of") or string.find(string.lower(speech), "ruin") or string.find(string.lower(speech), "wormheart")) then
    return true  -- No matching keywords
end
self:command("nod")
self:say("You may enter as an ally of the dark monks.")
self:command("unlock gate")
self:command("open gate")
self:command("bow")