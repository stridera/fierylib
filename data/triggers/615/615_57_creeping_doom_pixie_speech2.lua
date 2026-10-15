-- Trigger: creeping_doom_pixie_speech2
-- Zone: 615, ID: 57
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61557

-- Converted from DG Script #61557: creeping_doom_pixie_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"vengeance", "revenge", "avenger", "vessel?", "vessel", "abuses?", "abuses", "vengeance?", "revenge?", "avenger?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
self.room:send(tostring(self.name) .. " says, 'Yes, we need a powerful priest of Nature to be our")
self.room:send("</>avenging avatar!'")
wait(0.2)
if string.find(actor.class, "druid") then
    if actor.level > 80 then
        self:say("Will you be our vessel?")
    else
        self:say("Come back after your power has grown some more.")
    end
end