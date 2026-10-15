-- Trigger: Chajin_speech
-- Zone: 580, ID: 106
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- The tea master Chajin, confronted about the conspiracy, accepts his
-- karma and readies for combat.

-- ceremony

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"conspiracy", "conspiracy?", "key", "key?", "bowl", "bowl?", "kannon", "kannon?", "plot", "plot?", "yajiro", "yajiro?", "ceremony", "ceremony?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
self:emote("sighs with the heavy weight of his burden.")
wait(6)
self:say("So the day has come.")
self:say("Surely I will be punished for this karma in my next life.")
self:say("I shall atone through my blood.")
wait(4)
self:emote("readies himself for combat.")