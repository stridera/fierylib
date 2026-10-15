-- Trigger: supernova_phayla_speech2
-- Zone: 62, ID: 11
-- Type: MOB, Flags: SPEECH
--
-- Easter-egg: if anyone actually asks Phayla "how are you?" or "How's your day
-- going?" she gives them a cookie (238, 87) instead of brushing them off.
--
-- Original DG Script: #6211

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"how"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if string.find(speech, "how are you?") or string.find(speech, "how's your day going?") then
    wait(0.2)
    self:say("Wonderful, thank you for asking!")
    self.room:spawn_object(238, 87)
    self:command("give cookie " .. tostring(actor.name))
end