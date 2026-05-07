-- Trigger: Moonwell Chaos Receive
-- Zone: 163, ID: 60
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16360
--
-- Dryad receives the Chaos Orb at stage 10. Sets the per-quest "map" flag so
-- handing over the bark map next (16361) advances the stage. The orb is
-- destroyed after being placed on the well perimeter.
if actor:get_quest_stage("moonwell_spell_quest") == 10 then
    wait(2)
    actor:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(10)
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " along the circumference of the circle and utters a prayer.")
    wait(1)
    self.room:send(tostring(object.shortdesc) .. " crackles and shatters, shooting streaks of red lightning around the periphery of the well.")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Please give me the map to update!'")
    self:destroy_item("orb")
end