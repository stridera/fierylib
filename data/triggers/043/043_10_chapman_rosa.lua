-- Trigger: chapman_rosa
-- Zone: 43, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4310

-- Converted from DG Script #4310: chapman_rosa
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: You best step off!
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "you") or string.find(string.lower(speech), "best") or string.find(string.lower(speech), "step") or string.find(string.lower(speech), "off!")) then
    return true  -- No matching keywords
end
if actor.id == 4305 then
    self:emote("puts his hand up in a player's face.")
    wait(3)
    self:say("Oh yes I di' Rosa!")
    wait(3)
    self:say("You don' get ta tell me what ta do!")
    self:emote("puts one hand on his hip and flails the other hand around.")
end