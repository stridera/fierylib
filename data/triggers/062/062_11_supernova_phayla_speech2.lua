-- Trigger: supernova_phayla_speech2
-- Zone: 62, ID: 11
-- Type: MOB, Flags: SPEECH
--
-- Easter-egg: if anyone actually asks Phayla "how are you?" or "How's your day
-- going?" she gives them a cookie (238, 87) instead of brushing them off.
--
-- Original DG Script: #6211

if not string.find(string.lower(speech), "how") then
    return true
end
if string.find(speech, "how are you?") or string.find(speech, "How's your day going?") then
    wait(2)
    self:say("Wonderful, thank you for asking!")
    self.room:spawn_object(238, 87)
    self:command("give cookie " .. tostring(actor.name))
end