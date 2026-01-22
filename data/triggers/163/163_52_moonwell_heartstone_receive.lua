-- Trigger: Moonwell Heartstone receive
-- Zone: 163, ID: 52
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16352

-- Converted from DG Script #16352: Moonwell Heartstone receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("moonwell_spell_quest") == 3 then
    wait(2)
    actor.name:advance_quest("moonwell_spell_quest")
    actor:send(tostring(self.name) .. " tells you, 'Very good! This will work perfectly as an anchor stone.'")
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " in the center of the well's outline.")
    self:destroy_item("jewel")
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'Back when I was still mortal, I frequently traveled with")
    actor:send("</>Eleweiss, a ranger of great skill and magical acumen.  We once ventured north")
    actor:send("</>into the frozen mountains, and came across a cult that worshipped a")
    actor:send("</>particularly nasty white dragon.  Due to some unfortunate circumstances, we")
    actor:send("</>ended up having to battle the dragon and were forced to retreat.'")
    wait(20)
    actor:send(tostring(self.name) .. " tells you, 'In our retreat, Eleweiss lost a flask which contained")
    actor:send("</>water blessed by the Goddess Herself.  That water would be ideal for our magic")
    actor:send("</>well.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I imagine the flask is the kind of thing a dragon would")
    actor:send("</>add to its treasure hoard.  Please take revenge for us and obtain the flask.'")
end