-- Trigger: hunt-oracle-greet
-- Zone: 484, ID: 3
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #48403

-- Converted from DG Script #48403: hunt-oracle-greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if actor:get_quest_stage("doom_entrance") == 1 then
    self:emote("looks at " .. tostring(actor.name) .. " once and nods.")
    self.room:send(tostring(self.name) .. " says, 'To prove to Azkrael that you are worthy of")
    self.room:send("</>seeking out her traitorous brother, you shall have to find and slay her")
    self.room:send("</>favorite prey, a white hart.'")
    wait(1)
    self.room:spawn_object(484, 30)
    self:command("give rag " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " says, 'The white hart disguises itself as a")
    self.room:send("</>white-tailed deer.  But if you hold this rag in its presence, it will reveal")
    self.room:send("</>its true nature to you, " .. tostring(actor.name) .. ".'")
    wait(1)
    self:say("All normal deer will simply flee.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Slay the hart and return its antlers to me")
    self.room:send("</>as proof.'")
elseif actor:get_quest_stage("doom_entrance") == 2 then
    self:command("smile " .. tostring(actor.name))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Give me the antlers of the white hart,")
    self.room:send("</>" .. tostring(actor.name) .. ".'")
else
    wait(1)
    self.room:send("As you look at " .. tostring(self.name) .. ", you get a sense of her power")
    self.room:send("</>and majesty. This is no ordinary warrior, no ordinary person.")
    wait(2)
    self.room:send("You realize it'd be a bad idea to attack her.")
    self.room:send("And, as if reading your mind to see that you've realized this,")
    self.room:send("</>the Oracle speaks, her voice like silver.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'The Goddess Azkrael, protectress of")
    self.room:send("</>huntresses and virgins, was doubly outraged when Lokari took the honor, then")
    self.room:send("</>the life, of the woman Irinia, then abused her further by forcing her spirit")
    self.room:send("</>to serve his evil whims.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Though Lokari be Azkrael's own brother--")
    self.room:send("</>and a god-- he must be punished.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Azkrael is forbidden to raise her hand")
    self.room:send("</>against Lokari herself, but if you will aid her, she will allow you the use")
    self.room:send("</>of the great Horn of the Hunt.  You will find it somewhere on one of the four")
    self.room:send("</>Elemental Planes.  Use it to gain entrance to Lokari's Keep, and set the ghost")
    self.room:send("</>of Irinia free.'")
    wait(2)
    self.room:send("The Oracle waits, as if expecting you to leave. She says no more.")
end