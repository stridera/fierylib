-- Trigger: catherine_monkeys
-- Zone: 43, ID: 30
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4330

-- Converted from DG Script #4330: catherine_monkeys
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"monkey", "monkey?", "monkeys", "monkeys?", "key", "key?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    wait(0.2)
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
    wait(0.2)
    self:say("Help me " .. tostring(actor.name) .. ", you're my only hope!")
end