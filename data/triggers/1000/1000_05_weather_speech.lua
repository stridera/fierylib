-- Trigger: weather speech
-- Zone: 0, ID: 5
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5
-- Saying "weather" reveals a hidden door to the north into another zone.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"weather"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

get_room(12, 10):exit("n"):set_state({hidden = false})
self.room:send("<cyan>The air wrinkles and swirls into a door to the north</>")
return true
