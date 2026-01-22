-- Trigger: Cirion_speech2
-- Zone: 370, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #37006

-- Converted from DG Script #37006: Cirion_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: summon summoned
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "summon") or string.find(string.lower(speech), "summoned")) then
    return true  -- No matching keywords
end
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Don't think you came here on your own free will.'")
actor:send(tostring(self.name) .. " says to you, 'If you do then you are only deceiving yourself even more.'")
actor:send(tostring(self.name) .. " says to you, 'Mesmeriz brought you here.'")