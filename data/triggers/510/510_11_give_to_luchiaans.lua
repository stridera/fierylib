-- Trigger: give_to_luchiaans
-- Zone: 510, ID: 11
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #51011
-- Gates Luchiaans' acceptance logic for the cleric-book and
-- phoenix-heart quests:
--   - (510, 22) damaged spellbook  → "fix it first" (clericquest = 2)
--   - (510, 23) completed book     → reward branch driven by clericquest
--   - (510, 28) phoenix heart      → reward branch driven by magequest
--   - (85, 50) generic gate item   → silent halt
--   - anything else                → returns the object to the giver
local clericquest = clericquest or 0
local magequest = magequest or 0
local zone = object.zone_id
local id = object.id

if zone == 510 and id == 22 then
    -- Damaged book - more work to do.
    wait(5)
    self:say("Hmm...a damaged spellbook.")
    wait(2)
    self:say("Look, " .. tostring(actor.name) .. ", why don't you fix this then maybe we can talk.")
    globals.clericquest = 2
    return true
elseif zone == 510 and id == 23 then
    -- Completed spellbook - reward depends on whether they did it solo.
    wait(5)
    self:command("grin")
    self:say(tostring(actor.name) .. ", you've done me proud.")
    self:say("Although I guess you haven't really done any favours for the rest of the world!")
    self:command("cackle")
    local book = self.room:find_object("book-of-healing")
    if book then
        world.destroy(book)
    end
    if clericquest == 1 then
        self:say("And you did it all on your own initiative!  Well, here's a gift you can use.")
        self.room:spawn_object(510, 24)
        self:command("give wand " .. tostring(actor.name))
    elseif clericquest == 2 then
        self:say("Even though I had to help you, you did succeed, so here is a small reward.")
        self.room:spawn_object(510, 25)
        self:command("give wand " .. tostring(actor.name))
    else
        self:say("Best of all, I didn't even ask you to do this, so I don't owe you anything.")
        self:command("cackle")
    end
    globals.clericquest = 3
    return true
elseif zone == 510 and id == 28 then
    -- Phoenix heart.
    wait(5)
    self:say("Thanks, " .. tostring(actor.name) .. ".")
    self:say("Now I can generate an army of undead, unkillable zombies to help in my plans.")
    self:command("cackle")
    local heart = self.room:find_object("phoenix-heart")
    if heart then
        world.destroy(heart)
    end
    if magequest == 1 then
        self:say("Oh... about that partner thing.  You know I was joking right?")
        self:emote("looks a bit sheepish.")
        self:say("Well... here's a token of my thanks, but that's all you're getting.")
        self.room:spawn_object(510, 29)
        self:command("give green " .. tostring(actor.name))
        globals.magequest = 2
    else
        self:say("It was very generous of you to give this when I didn't ask for it!")
        self:command("grin")
    end
    return true
elseif zone == 85 and id == 50 then
    -- Generic gate item - silently accept and stop.
    return true
else
    -- Unrecognized gift - return it.
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(8)
    self:say("What am I supposed to do with this?")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
    return false
end
