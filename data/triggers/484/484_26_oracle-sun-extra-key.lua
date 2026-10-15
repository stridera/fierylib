-- Trigger: oracle-sun-extra-key
-- Zone: 484, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48426

-- Converted from DG Script #48426: oracle-sun-extra-key
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"key"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_has_completed("doom_entrance") then
    self.room:spawn_object(484, 21)
    self:command("give key " .. tostring(actor.name))
    self:say("Of course, " .. tostring(actor.name) .. ".")
    wait(1)
    self:say("Good luck against Lokari!")
end