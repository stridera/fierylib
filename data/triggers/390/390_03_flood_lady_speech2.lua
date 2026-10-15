-- Trigger: flood_lady_speech2
-- Zone: 390, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39003
--
-- The Lady deflects questions about what was stolen from her. Rude.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"what", "stolen?", "stolen", "take?", "take"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

self.room:send(self.name .. " says, 'What they took matters not!  They have stolen from")
self.room:send("</>the sea and must either return what they stole or be destroyed.'")