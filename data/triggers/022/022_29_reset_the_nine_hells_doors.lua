-- Trigger: RESET THE NINE HELLS DOORS
-- Zone: 22, ID: 29
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2229

-- Converted from DG Script #2229: RESET THE NINE HELLS DOORS
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: Restart the Nine Hells quest.
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "restart") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "nine") or string.find(string.lower(speech), "hells") or string.find(string.lower(speech), "quest.")) then
    return true  -- No matching keywords
end
doors.set_state(get_room(22, 1), "down", {action = "purge"})
doors.set_state(get_room(22, 10), "down", {action = "purge"})
doors.set_state(get_room(22, 11), "down", {action = "purge"})
doors.set_state(get_room(22, 12), "down", {action = "purge"})
doors.set_state(get_room(22, 13), "down", {action = "purge"})
doors.set_state(get_room(22, 14), "down", {action = "purge"})
doors.set_state(get_room(22, 15), "down", {action = "purge"})
doors.set_state(get_room(22, 16), "down", {action = "purge"})
doors.set_state(get_room(22, 17), "down", {action = "purge"})
self.room:send("Doors reset.")