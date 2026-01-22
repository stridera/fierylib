-- Trigger: prior_see_abbot
-- Zone: 200, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #20020

-- Converted from DG Script #20020: prior_see_abbot
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: i must see the abbot
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "must") or string.find(string.lower(speech), "see") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "abbot")) then
    return true  -- No matching keywords
end
self:command("nod")
self:say("You may see him at once!")
self:command("unlock door w")
self:command("open door w")