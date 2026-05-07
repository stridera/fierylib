-- Trigger: weather speech
-- Zone: 0, ID: 5
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5
-- Saying "weather" reveals a hidden door to the north into another zone.

-- Speech keyword: weather
if not string.find(string.lower(speech), "weather") then
    return true
end

get_room(12, 10):exit("n"):set_state({hidden = false})
self.room:send("<cyan>The air wrinkles and swirls into a door to the north</>")
return true
