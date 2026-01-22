-- Trigger: Archmage responds to 'necromancer'
-- Zone: 30, ID: 7
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3007

-- Converted from DG Script #3007: Archmage responds to 'necromancer'
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(1)
if string.find(actor.class, "Sorcerer") and actor.level > 9 and actor.level < 46 then
    self:say("So you want to take on the dark arts, eh?  The foul arts?  The stinky death arts?")
    wait(3)
    self:command("sniff")
    wait(3)
    self:say("I suppose there's no accounting for taste.  You might want to find a pungent necromancer to help with this endeavour.  If you absolutely must.")
    wait(4)
    self:say("Or a diabolist, even.  Seriously.  They're all the same, painted dark purple and wearing old umbrellas.")
    wait(4)
    self:say("Yes, there IS a necromancer nearby.  I should think the odor would have given him away to you long ago.")
    wait(4)
    self:say("Go look around the creepy nasty parts of town.  No, NOT underground!  This is Asiri we're talking about here!")
    self:say("He's vain and no doubt sips blood in a musty parlour, but he won't stand for mold.")
    wait(4)
    self:say("I suppose a run-down shack of some kind would suit him.  I've never been to visit.  Never will.")
elseif string.find(actor.class, "Sorcerer") and actor.level < 10 then
    self:say("You want to know about evil, scheming death mages?  A fine young sorcerer like yourself?")
    wait(4)
    self:say("I canNOT imagine why.  They lead frightful lives.  Entertained and served by corpses.")
    wait(3)
    self:command("shudder")
    wait(3)
    self:say("At any rate, Asiri won't do a thing for you at your age.  So you can just put the idea out of your mind.")
    wait(4)
    self:say("Preferably forever.")
elseif string.find(actor.class, "Necromancer") then
    actor:send(tostring(self.name) .. " looks you over.")
    self.room:send_except(actor, tostring(self.name) .. " looks " .. tostring(actor.name) .. " over.")
    wait(4)
    self:say("Indeed.  I suppose you are.  Well.")
    wait(4)
    self:say("It can't be helped, can it?  You're... well, you're what you are, aren't you.")
    wait(4)
    self:say("If you're looking for your guild, I can only assure you that it's nowhere nearby.")
    wait(4)
    self:say("Well, it can't be TOO far away, as I can smell the rot of old Asiri.  It drifts over half the town.")
    wait(3)
    self:command("gag")
    wait(3)
    self:say("Why don't you look for a few undead folks?  Asiri seems to discard as many corpses as he employs.")
else
    self:say("You smell it, too?")
    wait(4)
    self:say("I'm going to start a petition to have Asiri evicted from our fine town.")
    wait(4)
    self:say("I hope I can count on you to sign promptly.")
    wait(4)
    self:command("eyebrow " .. tostring(actor.name))
end