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

-- Speech keyword: neris'kaan (case-insensitive)
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "neris'kaan", 1, true) then
    return true  -- No matching keyword
end
get_room(162, 71):exit("n"):set_state({hidden = false})
self.room:send("<b:yellow>Dust fills the air as a wind groans by you flowing to the north.</>")
self.room:send("<yellow>Massive pillars of stone open to form a new passage.</>")