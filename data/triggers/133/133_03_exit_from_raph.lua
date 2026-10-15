-- Trigger: exit_from_raph
-- Zone: 133, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #13303

-- Converted from DG Script #13303: exit_from_raph
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exit", "exit?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Note: hardcoded teleport room (133, 1) — making this generic for other
-- mobs would need a per-mob exit room mapping.
self:command("growl")
self:say("You are too cruel!")
actor:send("Raph taps his wrists together and you are covered in smoke!")
self.room:send_except(actor, "Raph glares at " .. tostring(actor.name) .. " and sends him elsewhere!")
actor:teleport(get_room(133, 1))