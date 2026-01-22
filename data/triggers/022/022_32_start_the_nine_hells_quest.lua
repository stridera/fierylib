-- Trigger: START THE NINE HELLS QUEST
-- Zone: 22, ID: 32
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2232

-- Converted from DG Script #2232: START THE NINE HELLS QUEST
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: Start the Nine Hells quest.
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "start") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "nine") or string.find(string.lower(speech), "hells") or string.find(string.lower(speech), "quest.")) then
    return true  -- No matching keywords
end
doors.set_state(get_room(22, 1), "down", {action = "room"})
doors.set_name(get_room(22, 1), "down", "hole")
doors.set_description(get_room(22, 1), "down", "&1The hole in the earth seems to be a bottomless shaft, with the roiling flames of hell licking the edges.&0")
get_room(22, 1):at(function()
    self.room:send("<red>The earth <yellow>heaves<red> and suddenly breaks open to reveal a <blue>fiery </><red>pit.</>")
end)
self.room:send("Quest started.")