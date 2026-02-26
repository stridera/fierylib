-- Trigger: Auto door opener
-- Zone: 40, ID: 2
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4002

-- Converted from DG Script #4002: Auto door opener
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: darkness hear my call unto you
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "darkness") or string.find(string.lower(speech), "hear") or string.find(string.lower(speech), "my") or string.find(string.lower(speech), "call") or string.find(string.lower(speech), "unto") or string.find(string.lower(speech), "you")) then
    return true  -- No matching keywords
end
doors.set_state(get_room(40, 19), "u", {action = "room"})
self.room:send("The southern wall crumbles and falls as darkness flees from behind it.")
self.room:send("Unknowing steps are revealed ascending.")
wait(10)
doors.set_state(get_room(40, 19), "up", {action = "purge"})