-- Trigger: Grand Master responds to 'guild'
-- Zone: 172, ID: 0
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17200

-- Converted from DG Script #17200: Grand Master responds to 'guild'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: guild
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "guild")) then
    return true  -- No matching keywords
end
wait(1)
if string.find(actor.class, "Sorcerer") then
    self:command("eyebrow " .. tostring(actor.name))
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I know and you know that it's right behind Bigby's shop!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Now stop wasting my time.'")
elseif string.find(actor.class, "Cryomancer") then
    actor:send(tostring(self.name) .. " says, 'Your guild?  Ickle, perhaps?'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'I'm impressed that you haven't melted into a puddle from being so far south.'")
elseif string.find(actor.class, "Pyromancer") then
    actor:send(tostring(self.name) .. " says, 'Where's your guild?  Probably somewhere hot, I should say?'")
    wait(3)
    self:command("chuckle grand")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Sorry, I've been shut up in this tower far too long!'")
elseif string.find(actor.class, "Illusionist") then
    actor:send(tostring(self.name) .. " says, 'Yes, you'll be wanting to visit your guild.'")
    wait(3)
    self:command("nod " .. tostring(actor.name))
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I haven't visited Mielikki in ages, but there is certainly one there for you.  But as to where...'")
    wait(3)
    self:command("sigh")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'The best person to ask would be the Archmage.  She really ought to keep track of these things.'")
else
    self:command("sigh")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Look, I'm no good at these sorts of questions.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Guilds are usually found near centers of commerce.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'You're the adventurer, find it yourself!'")
end