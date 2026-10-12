-- Trigger: hermit_speak4
-- Zone: 490, ID: 49
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49049

-- Converted from DG Script #49049: hermit_speak4
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"where", "where?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
self:say("I believe the St. Marvin wrecked near the cliffs on the western shores.")