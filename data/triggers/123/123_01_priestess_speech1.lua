-- Trigger: priestess_speech1
-- Zone: 123, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12301

-- Converted from DG Script #12301: priestess_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: assist assistance assist? assistance? how what
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "assist") or string.find(string.lower(speech), "assistance") or string.find(string.lower(speech), "assist?") or string.find(string.lower(speech), "assistance?") or string.find(string.lower(speech), "how") or string.find(string.lower(speech), "what")) then
    return true  -- No matching keywords
end
if string.find(speech, "assist") or string.find(speech, "assistance") or string.find(speech, "assist")? or string.find(speech, "assistance")? or string.find(speech, "how") can I help? or string.find(speech, "how") can I assist? or string.find(speech, "what") can I do? or string.find(speech, "what") can I do to assist? then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Our coven came to this megalith to perform the <b:white>Great Rite of Invocation</> and summon our faerie goddess The Great Mother, the Lady of the Stars.'")
end