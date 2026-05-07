-- Trigger: Door opener
-- Zone: 40, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4001
-- Reveals the hidden staircase down in room (40, 10) for 10 pulses
-- when a passphrase is spoken nearby. Original DG probability is 0%
-- (preserved); effectively disabled until the script is re-enabled
-- by raising the probability.

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: norhamen beneti sovering tarlon campri
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "norhamen")
        or string.find(speech_lower, "beneti")
        or string.find(speech_lower, "sovering")
        or string.find(speech_lower, "tarlon")
        or string.find(speech_lower, "campri")) then
    return true  -- No matching keywords
end

get_room(40, 10):exit("down"):set_state({hidden = false})
self.room:send("The wall screams in vain as air thrust towards you.")
self.room:send("The wall fades out of view revealing a staircase downward.")
wait(10)
get_room(40, 10):exit("down"):set_state({hidden = true})
