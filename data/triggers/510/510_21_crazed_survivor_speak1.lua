-- Trigger: crazed_survivor_speak1
-- Zone: 510, ID: 21
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51021
-- Reacts to "book" — the survivor recounts finding the book in
-- Luchiaans' office and the catastrophe that followed.

-- Speech keyword: "book"
if not string.find(string.lower(speech or ""), "book") then
    return true
end
self:say("Yes, I used to be a cleaner in the Council chambers and one day I found a book in the corner of Luchiaans' office.")
self:emote("scratches his chin.")
self:say("I told the Council leader about it, and three days later the town is like it is now.")
self:say("Nothing has happened since, but I can feel something brewing.")
wait(1)
self:command("shrug")
self:say("I presume the book is still there, leastways I didn't touch it, not after what I'd read from it.")
self:emote("rubs his arms as if he is suddenly cold.")