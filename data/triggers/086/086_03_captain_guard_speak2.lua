-- Trigger: captain_guard_speak2
-- Zone: 86, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8603

-- Converted from DG Script #8603: captain_guard_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"friend", "friend?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Very good!")
self:command("unlock trellis")
self:command("open trellis")
self:say("Welcome to the Kingdom of the Meer Cats.")
self:command("bow " .. tostring(actor.name))