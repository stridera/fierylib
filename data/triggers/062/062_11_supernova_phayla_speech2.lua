-- Trigger: supernova_phayla_speech2
-- Zone: 62, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6211

-- Converted from DG Script #6211: supernova_phayla_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: how
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "how")) then
    return true  -- No matching keywords
end
if string.find(speech, "how are you%?") or string.find(speech, "How's your day going%?") then
    wait(2)
    self:say("Wonderful, thank you for asking!")
    self.room:spawn_object(238, 87)
    self:command("give cookie " .. tostring(actor.name))
end