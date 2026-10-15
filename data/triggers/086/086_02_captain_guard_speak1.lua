-- Trigger: captain_guard_speak1
-- Zone: 86, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8602

-- Converted from DG Script #8602: captain_guard_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"foe", "foe?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("That is unacceptable!")
wait(0.1)
-- TODO: combat.engage expects an entity (target), not a name string; verify actor is the correct target
combat.engage(actor)