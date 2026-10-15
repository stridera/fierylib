-- Trigger: crazed_survivor_speak1
-- Zone: 510, ID: 21
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51021
-- Reacts to "book" — the survivor recounts finding the book in
-- Luchiaans' office and the catastrophe that followed.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech or "") .. " "
local speech_hit = false
for _, w in ipairs({"book?", "book"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:say("Yes, I used to be a cleaner in the Council chambers and one day I found a book in the corner of Luchiaans' office.")
self:emote("scratches his chin.")
self:say("I told the Council leader about it, and three days later the town is like it is now.")
self:say("Nothing has happened since, but I can feel something brewing.")
wait(0.1)
self:command("shrug")
self:say("I presume the book is still there, leastways I didn't touch it, not after what I'd read from it.")
self:emote("rubs his arms as if he is suddenly cold.")