-- Trigger: START THE NINE HELLS QUEST
-- Zone: 22, ID: 32
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2232

-- Converted from DG Script #2232: START THE NINE HELLS QUEST
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- Speech phrase: Start the Nine Hells quest. (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "start the nine hells quest.", 1, true) then
    return true  -- Not the phrase
end
get_room(22, 1):exit("down"):set_state({hidden = false})
get_room(22, 1):exit("down"):set_state({name = "hole"})
get_room(22, 1):exit("down"):set_state({description = "&1The hole in the earth seems to be a bottomless shaft, with the roiling flames of hell licking the edges.&0"})
get_room(22, 1):at(function()
    self.room:send("<red>The earth <yellow>heaves<red> and suddenly breaks open to reveal a <blue>fiery </><red>pit.</>")
end)
self.room:send("Quest started.")