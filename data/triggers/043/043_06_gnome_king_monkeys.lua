-- Trigger: gnome_king_monkeys
-- Zone: 43, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4306

-- Converted from DG Script #4306: gnome_king_monkeys
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: monkeys? monkeys monkey
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "monkeys?") or string.find(string.lower(speech), "monkeys") or string.find(string.lower(speech), "monkey")) then
    return true  -- No matching keywords
end
self:say("Yes, the Ceiling Monkeys!")
wait(4)
self:command("mutter")
wait(3)
self.room:send(tostring(self.name) .. " says, 'They managed to sneak off the catwalk this afternoon and ran amuck through the theater.'")
wait(3)
-- (empty say)
self.room:send(tostring(self.name) .. " says, 'I believe my gnomes and I managed to get them all back up into their nesting grounds.  Unfortunately, they made off with a couple of the actors' personal belongings.'")
wait(4)
self:command("eye " .. tostring(actor.name))
wait(5)
self.room:send(tostring(self.name) .. " says, 'However, you might be able to help.  Are you up to it?'")