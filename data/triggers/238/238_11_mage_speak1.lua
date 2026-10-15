-- Trigger: mage_speak1
-- Zone: 238, ID: 11
-- Type: MOB, Flags: SPEECH
--
-- Mage delivers the framing riddle when the player greets him or asks about
-- the riddle/quest. Tells the player the question itself is iced over.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"riddle", "quest", "hi", "hello"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(1)
self:command("frown")
wait(2)
self:emote("gestures at the symbols on the walls.")
self:say("There is a riddle here, yes.  It is...somewhat complicated.")
self:emote("takes a deep breath and begins to translate some runes.")
wait(3)
self:say("\"Five friends from five towns liked five colors and stood in a line.  Each was a different race and class, and each fought a different enemy.  In my keep you will find all the information you need to solve the question I ask.\"")
wait(3)
self:command("frown")
wait(1)
self:emote("gestures at the wall, looking frustrated.")
self:say("But the question referred to is obscured by ice.")
