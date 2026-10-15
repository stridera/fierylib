-- Trigger: Mausoleum trigger
-- Zone: 0, ID: 85
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #85
-- Saying "Ziijhan" reveals the hidden western exit of room 85:24.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"ziijhan"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

get_room(85, 24):exit("w"):set_state({hidden = false})
self.room:send("You hear the slow grind of rock against rock. A doorway appears to the west.")
return true
