-- Trigger: Mausoleum trigger
-- Zone: 0, ID: 85
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #85
-- Saying "Ziijhan" reveals the hidden western exit of room 85:24.

-- Speech keyword: ziijhan
if not string.find(string.lower(speech), "ziijhan") then
    return true
end

get_room(85, 24):exit("w"):set_state({hidden = false})
self.room:send("You hear the slow grind of rock against rock. A doorway appears to the west.")
return true
