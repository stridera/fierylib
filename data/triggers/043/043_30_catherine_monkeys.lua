-- Trigger: catherine_monkeys
-- Zone: 43, ID: 30
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4330

-- Converted from DG Script #4330: catherine_monkeys
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: monkey monkey? monkeys monkeys? key key?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "monkey") or string.find(string.lower(speech), "monkey?") or string.find(string.lower(speech), "monkeys") or string.find(string.lower(speech), "monkeys?") or string.find(string.lower(speech), "key") or string.find(string.lower(speech), "key?")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    wait(2)
    self:emote("points up to the ceiling.")
    wait(1)
    self:say("Ya see, there's these monkeys that live in the rafters...")
    self:command("glare")
    wait(2)
    self:say("Those horrible monkeys!")
    wait(4)
    actor:send(tostring(self.name) .. " turns to look at you.")
    self.room:send_except(actor, tostring(self.name) .. " turns to look at " .. tostring(actor.name))
    wait(2)
    self:say("We call them \"Ceiling Monkeys,\" for lack of a better term.")
    wait(4)
    self:say("Anyway the monkeys got loose this afternoon and attacked us as we came in!")
    wait(1)
    self:say("It was madness!  MADNESS!!")
    wait(3)
    self:command("shudder")
    wait(1)
    self:say("In any case, they ran off with a few of our things, and I think my dressing room key was one of them!")
    wait(4)
    self:say("So now my eyelashes are still locked in my dressing room, Theo needs his duck, and the only person who can get to the stupid monkeys to get my key back is the House Gnome King.")
    wait(3)
    self:say("Find my key and my eyelashes and bring them back to me.")
    wait(2)
    self:say("Help me " .. tostring(actor.name) .. ", you're my only hope!")
end