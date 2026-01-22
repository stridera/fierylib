-- Trigger: instant reboot
-- Zone: 0, ID: 25
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #25

-- Converted from DG Script #25: instant reboot
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: reboot now
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "reboot") or string.find(string.lower(speech), "now")) then
    return true  -- No matching keywords
end
self.room:send(tostring(people.3054))
self.room:send(tostring(people.51036))