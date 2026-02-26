-- Trigger: Door opener
-- Zone: 40, ID: 1
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4001

-- Converted from DG Script #4001: Door opener
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: norhamen beneti sovering tarlon campri
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "norhamen") or string.find(string.lower(speech), "beneti") or string.find(string.lower(speech), "sovering") or string.find(string.lower(speech), "tarlon") or string.find(string.lower(speech), "campri")) then
    return true  -- No matching keywords
end
doors.set_state(get_room(40, 10), "down", {action = "room"})
self.room:send("The wall screams in vain as air thrust towards you.")
self.room:send("The wall fades out of view revealing a staircase downward.")
wait(10)
doors.set_state(get_room(40, 10), "down", {action = "purge"})