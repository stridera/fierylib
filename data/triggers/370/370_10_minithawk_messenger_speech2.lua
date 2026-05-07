-- Trigger: Minithawk_messenger_speech2
-- Zone: 370, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37010

-- Converted from DG Script #37010: Minithawk_messenger_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: north, east, south, west
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "north") or string.find(speech_lower, "east") or string.find(speech_lower, "south") or string.find(speech_lower, "west")) then
    return true  -- No matching keywords
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you 'Thank you very much!  Now if I could just find a way out of this mine!'")