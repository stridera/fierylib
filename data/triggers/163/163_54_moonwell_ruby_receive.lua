-- Trigger: Moonwell Ruby Receive
-- Zone: 163, ID: 54
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16354

-- Converted from DG Script #16354: Moonwell Ruby Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("moonwell_spell_quest") == 6 then
    wait(2)
    actor.name:set_quest_var("moonwell_spell_quest", "map", 1)
    actor:send(tostring(self.name) .. " tells you, 'Good.  Thank you!'")
    wait(15)
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " along the circumference of the circle and utters a prayer.")
    wait(1)
    self.room:send(tostring(object.shortdesc) .. " starts flickering with sparking lights!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Now that we have the first symbol, we can go for the")
    actor:send("</>second.  The second item we need is an orb, representing the element of Air.")
    actor:send("</>This orb is somewhere in a dark fortress to the east.  Please obtain the orb.'")
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'Oh wait, please allow me to update your map.'")
    world.destroy(object)
end