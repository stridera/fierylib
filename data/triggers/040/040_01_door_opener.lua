-- Trigger: Door opener
-- Zone: 40, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4001
-- Reveals the hidden staircase down in room (40, 10) for 10 pulses
-- when the passphrase is spoken nearby (DG num_arg 0 = phrase match).

-- Speech phrase: norhamen beneti sovering tarlon campri (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]norhamen beneti sovering tarlon campri[%s%p]") then
    return true  -- Not the phrase
end

get_room(40, 10):exit("down"):set_state({hidden = false})
self.room:send("The wall screams in vain as air thrust towards you.")
self.room:send("The wall fades out of view revealing a staircase downward.")
wait(10)
get_room(40, 10):exit("down"):set_state({hidden = true})
