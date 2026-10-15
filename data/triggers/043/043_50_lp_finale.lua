-- Trigger: LP_finale
-- Zone: 43, ID: 50
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4350

-- Converted from DG Script #4350: LP_finale
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"join?", "join"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Watch our performance!  Come and waste an hour or two.")
self:emote("closes his eyes and smiles a seductively evil smile.")
wait(3)
self:say("All the preparations are set for the only perfect act in our repertoire.")