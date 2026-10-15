-- Trigger: Ranger responds to hello
-- Zone: 502, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #50211

-- Converted from DG Script #50211: Ranger responds to hello
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hi", "hello"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player and actor.level < 100 then
    wait(0.6)
    self:command("bow " .. tostring(actor.name))
    wait(2)
    self:say("Have a care in these swamps, little one, for evil is afoot.")
end