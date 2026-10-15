-- Trigger: Knight_Champ_speech2
-- Zone: 550, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #55011

-- Converted from DG Script #55011: Knight_Champ_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"evil"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("nod")
self.room:send_except(actor, "The Knight Champion speaks in a low voice to " .. tostring(actor.name) .. ".")
-- (empty send to actor)
-- Fragment (possible truncation): The Knight Champion whispers to you, 'Yes there was evil in the kingdom long
actor:send("</>ago two reckless deities warring. The great Snow Leopard saved us all.'")