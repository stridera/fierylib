-- Trigger: give_to_luchiaans
-- Zone: 510, ID: 11
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #51011

-- Converted from DG Script #51011: give_to_luchiaans
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- damaged book...there is another part to do yet
if object.id == 51022 then
    wait(5)
    self:say("Hmm...a damaged spellbook.")
    wait(2)
    self:say("Look, " .. tostring(actor.name) .. ", why don't you fix this and then maybe we can talk.")
    _return_value = false
    local clericquest = 2
    globals.clericquest = globals.clericquest or true
    -- complete spellbook - did we do this in one go (bonus)
elseif object.id == 51023 then
    wait(5)
    self:command("grin")
    self:say(tostring(actor.name) .. ", you've done me proud.")
    self:say("Although I guess you haven't really done any favours for the rest of the world!")
    self:command("cackle")
    world.destroy(self.room:find_actor("book-of-healing"))
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
    local clericquest = 3
    globals.clericquest = globals.clericquest or true
elseif object.id == 51028 then
    wait(5)
    self:say("Thanks, " .. tostring(actor.name) .. ".")
    self:say("Now I can generate an army of undead, unkillable zombies to help in my plans.")
    self:command("cackle")
    world.destroy(self.room:find_actor("phoenix-heart"))
    if magequest == 1 then
        self:say("Oh... about that partner thing.  You know I was joking right?")
        self:emote("looks a bit sheepish.")
        self:say("Well... here's a token of my thanks, but that's all you're getting.")
        self.room:spawn_object(510, 29)
        self:command("give green " .. tostring(actor.name))
        local magequest = 2
        globals.magequest = globals.magequest or true
    else
        self:say("It was very generous of you to give this when I didn't ask for it!")
        self:command("grin")
    end
elseif object.id == 8550 then
    return _return_value
else
    _return_value = false
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    wait(8)
    self:say("What am I supposed to do with this?")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
end
return _return_value