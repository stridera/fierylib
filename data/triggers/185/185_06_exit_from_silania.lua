-- Trigger: exit_from_silania
-- Zone: 185, ID: 6
-- Type: MOB, Flags: SPEECH
--
-- "Exit"/"exit?" → Silania apologetically opens the hidden passage
-- by manually firing 185_07.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"exit", "exit?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Ooops, how embarassing, I forgot about the door!")
run_room_trigger(185, 7)