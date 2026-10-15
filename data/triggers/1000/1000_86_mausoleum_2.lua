-- Trigger: Mausoleum 2
-- Zone: 0, ID: 86
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #86
-- Saying "path" reveals a downward trapdoor in room 85:25.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"path"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

get_room(85, 25):exit("d"):set_state({hidden = false})
self.room:send("The Blood of the Evil Runes begins to boil, and solidifies into a trapdoor.")
return true
