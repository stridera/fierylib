-- Trigger: Mausoleum 2
-- Zone: 0, ID: 86
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #86
-- Saying "path" reveals a downward trapdoor in room 85:25.

-- Speech keyword: path
if not string.find(string.lower(speech), "path") then
    return true
end

get_room(85, 25):exit("d"):set_state({hidden = false})
self.room:send("The Blood of the Evil Runes begins to boil, and solidifies into a trapdoor.")
return true
