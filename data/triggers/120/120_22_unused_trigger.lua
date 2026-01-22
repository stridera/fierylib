-- Trigger: unused trigger
-- Zone: 120, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12022

-- Converted from DG Script #12022: unused trigger
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: Please take this.
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "please") or string.find(string.lower(speech), "take") or string.find(string.lower(speech), "this.")) then
    return true  -- No matching keywords
end
self.room:send("OOO - avnum=" .. tostring(actor.id) .. " -- give all " .. tostring(rescuer))
wait(8)
if actor.id == 12019 then
    self:command("give all " .. tostring(rescuer))
end