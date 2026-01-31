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