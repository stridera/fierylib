-- Trigger: Auto door opener
-- Zone: 40, ID: 2
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4002
-- Reveals the hidden up exit in room (40, 19) for 10 pulses when a
-- passphrase is spoken (DG num_arg 0 = phrase match): the full phrase
-- "darkness hear my call unto you".

-- Speech phrase: darkness hear my call unto you (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]darkness hear my call unto you[%s%p]") then
    return true  -- Not the phrase
end

get_room(40, 19):exit("up"):set_state({hidden = false})
self.room:send("The southern wall crumbles and falls as darkness flees from behind it.")
self.room:send("Unknowing steps are revealed ascending.")
wait(10)
get_room(40, 19):exit("up"):set_state({hidden = true})
