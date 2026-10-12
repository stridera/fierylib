-- Trigger: RESET THE NINE HELLS DOORS
-- Zone: 22, ID: 29
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #2229

-- Converted from DG Script #2229: RESET THE NINE HELLS DOORS
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- Speech phrase: Restart the Nine Hells quest. (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "restart the nine hells quest.", 1, true) then
    return true  -- Not the phrase
end
get_room(22, 1):exit("down"):set_state({hidden = true})
get_room(22, 10):exit("down"):set_state({hidden = true})
get_room(22, 11):exit("down"):set_state({hidden = true})
get_room(22, 12):exit("down"):set_state({hidden = true})
get_room(22, 13):exit("down"):set_state({hidden = true})
get_room(22, 14):exit("down"):set_state({hidden = true})
get_room(22, 15):exit("down"):set_state({hidden = true})
get_room(22, 16):exit("down"):set_state({hidden = true})
get_room(22, 17):exit("down"):set_state({hidden = true})
self.room:send("Doors reset.")