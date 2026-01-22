-- Trigger: Minithawk_messenger_speech3
-- Zone: 370, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37011

-- Converted from DG Script #37011: Minithawk_messenger_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: town town?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "town") or string.find(string.lower(speech), "town?")) then
    return true  -- No matching keywords
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Yes, I must go to Templace. Which way?'")