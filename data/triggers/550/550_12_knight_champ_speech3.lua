-- Trigger: Knight_Champ_speech3
-- Zone: 550, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55012

-- Converted from DG Script #55012: Knight_Champ_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: victory
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "victory")) then
    return true  -- No matching keywords
end
self:command("nod " .. tostring(actor.name))
self.room:send_except(actor, "The Knight Champion speaks in a low voice to " .. tostring(actor.name) .. ".")
actor:send("The Knight Champion whispers to you 'Yes a victory in battle over a foe of")
actor:send("</>great evil.  Or an army of the darkness.'")