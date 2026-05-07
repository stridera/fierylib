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

-- TODO(parity): original DG keyword was the exact phrase "Start the Nine Hells quest.";
-- converter split it into OR of common words ("the", "quest.") which match nearly any speech.
-- Should require all keywords to match (admin-only quest start speech).
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "start") and string.find(speech_lower, "nine") and string.find(speech_lower, "hells") and string.find(speech_lower, "quest")) then
    return true  -- No matching keywords
end
get_room(22, 1):exit("down"):set_state({hidden = false})
get_room(22, 1):exit("down"):set_state({name = "hole"})
get_room(22, 1):exit("down"):set_state({description = "&1The hole in the earth seems to be a bottomless shaft, with the roiling flames of hell licking the edges.&0"})
get_room(22, 1):at(function()
    self.room:send("<red>The earth <yellow>heaves<red> and suddenly breaks open to reveal a <blue>fiery </><red>pit.</>")
end)
self.room:send("Quest started.")