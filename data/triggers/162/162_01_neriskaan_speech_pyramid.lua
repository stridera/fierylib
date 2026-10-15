-- Trigger: neriskaan speech pyramid
-- Zone: 162, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16201

-- Converted from DG Script #16201: neriskaan speech pyramid
-- Original: ROOM trigger, flags: SPEECH, probability: 100%
-- Speaking the name "Neris'kaan" reveals the hidden north passage from room
-- 162/71 leading to the pyramid interior (originally 162/67).

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"neris'kaan"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
get_room(162, 71):exit("n"):set_state({hidden = false})
self.room:send("<b:yellow>Dust fills the air as a wind groans by you flowing to the north.</>")
self.room:send("<yellow>Massive pillars of stone open to form a new passage.</>")