-- Trigger: crazed_survivor_speak1
-- Zone: 510, ID: 21
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51021

-- Converted from DG Script #51021: crazed_survivor_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: book?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "book?")) then
    return true  -- No matching keywords
end
self:say("Yes, I used to be a cleaner in the Council chambers and one day I found a book in the corner of Luchiaans' office.")
self:emote("scratches his chin.")
self:say("I told the Council leader about it, and three days later the town is like it is now.")
self:say("Nothing has happened since, but I can feel something brewing.")
wait(1)
self:command("shrug")
self:say("I presume the book is still there, leastways I didn't touch it, not after what I'd read from it.")
self:emote("rubs his arms as if he is suddenly cold.")