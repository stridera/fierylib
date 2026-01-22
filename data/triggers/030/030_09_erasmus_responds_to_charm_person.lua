-- Trigger: Erasmus responds to "charm person"
-- Zone: 30, ID: 9
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3009

-- Converted from DG Script #3009: Erasmus responds to "charm person"
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(2)
if string.find(actor.class, "Illusionist") then
    if actor:has_skill("charm person") == 100 then
        self:say("A nice spell, isn't it?  I hope you're enjoying it.")
    elseif actor.level < 17 then
        self:say("Ah, charm person.  A powerful spell, capable of great evil - or good.")
        wait(2)
        self:say("Come back when you have a bit more experience, and I'll teach it to you.")
    else
        self:say("Oh, the charm person spell.  You're ready to learn that one!")
        wait(2)
        self:say("Stand still there while I teach you.")
        wait(2)
        self:emote("launches into a marathon of lectures and speeches about diverse arcana.")
        wait(5)
        self:emote("is still spewing forth obscure knowledge at a furious rate!")
        wait(5)
        self:emote("seems to be winding down, as if the lesson were almost over.")
        wait(5)
        if actor.room == self.room then
            self:say("I'm impressed with your attentiveness, " .. tostring(actor.name) .. ".")
            wait(3)
            self:say("I can see that you've learned charm person rather well.")
            skills.set_level(actor, "charm person", 100)
        else
            self:say("Eh?  Where did " .. tostring(actor.name) .. " go?  Must not have a thirst for knowledge!")
        end
    end
elseif string.find(actor.class, "Sorcerer") then
    if actor:has_skill("charm person") == 100 then
        self:command("gasp")
        wait(3)
        self:say("What's this?  An ordinary sorcerer with charm person?!")
        wait(5)
        self:say("Will wonders never cease!")
        wait(5)
        self:command("shake")
    else
        self:say("Don't look at me!  I'm a legendary teacher, but some things are just beyond me!")
        wait(5)
        self:say("You sorcerers require extra help learning this... rather simple spell.")
        wait(5)
        self:say("And you'll get none of it for me, because I have better things to do.")
    end
else
    self:command("sigh")
    wait(3)
    self:say("Yes, yes, a wonderful spell, how incredible we illusionists are, certainly.")
    wait(3)
    self:command("roll")
    wait(3)
    self:say("Why don't you go bash some poor rodents' heads in.  Or whatever it is you do.")
end