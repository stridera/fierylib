-- Trigger: Moonwell Flask Receive
-- Zone: 163, ID: 53
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16353
--
-- Dryad receives Eleweiss' Flask. Stage 4 (haven't been told to fetch it
-- yet) -> rebuke + destroy.  Stage 5 -> advance to 6, hand the player a map
-- (163/51) and send them after the ruby ring.
if actor:get_quest_stage("moonwell_spell_quest") == 4 then
    wait(2)
    self:destroy_item("flask")
    actor:send(tostring(self.name) .. " tells you, 'How did you get this?  No no, go get it yourself.'")
elseif actor:get_quest_stage("moonwell_spell_quest") == 5 then
    wait(2)
    self:destroy_item("flask")
    actor:advance_quest("moonwell_spell_quest")
    actor:send(tostring(self.name) .. " tells you, 'Thank you, thank you.'")
    wait(15)
    self.room:send(tostring(self.name) .. " opens the flask and pours the water into the boundary of the well while reciting a prayer to Mielikki.")
    wait(4)
    self.room:send("The boundary of the well becomes translucent and starts to glow!")
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'Okay now we need some items of power to place around the")
    actor:send("</>outside edge of the well.'")
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'Each needs to be either an orb or circle to reflect the")
    actor:send("</>circular boundary of the well itself.'")
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'The first item shall be a ring representing Fire.  Fire")
    actor:send("</>is most closely associated with rubies, so a ruby ring would be good.  One from")
    actor:send("</>a place connected with fire would be ideal!'")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Oh, before you leave.  Here takes this.'")
    self.room:spawn_object(163, 51)
    self:command("give map " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'That will help you keep track of everything.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Now go!'")
end