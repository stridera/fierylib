-- Trigger: Knight_Champ_speech2
-- Zone: 550, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55011

-- Converted from DG Script #55011: Knight_Champ_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: evil
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "evil")) then
    return true  -- No matching keywords
end
self:command("nod")
self.room:send_except(actor, "The Knight Champion speaks in a low voice to " .. tostring(actor.name) .. ".")
-- (empty send to actor)
-- Fragment (possible truncation): The Knight Champion whispers to you, 'Yes there was evil in the kingdom long
actor:send("</>ago two reckless deities warring. The great Snow Leopard saved us all.'")