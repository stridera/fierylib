-- Trigger: Minithawk_messenger_speech1
-- Zone: 370, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37008

-- Converted from DG Script #37008: Minithawk_messenger_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: killed killed?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "killed") or string.find(string.lower(speech), "killed?")) then
    return true  -- No matching keywords
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Yes, killed...as in dead.  Mesmeriz would have my head if he'")
actor:send(tostring(self.name) .. " says to you, 'knew I were talking to you.  His direct orders were for me to'")
actor:send(tostring(self.name) .. " says to you, 'go to Templace, and deliver this rock.'")