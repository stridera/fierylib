-- Trigger: Knight_Champ_speech4
-- Zone: 550, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55013

-- Converted from DG Script #55013: Knight_Champ_speech4
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: worth worthy
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "worth") or string.find(string.lower(speech), "worthy")) then
    return true  -- No matching keywords
end
self:command("trip " .. tostring(actor.name))
self.room:send(tostring(self.name) .. " says, 'You are unworthy!  Standing here like a helpless")
self.room:send("</>pig!'")
self:command("growl")