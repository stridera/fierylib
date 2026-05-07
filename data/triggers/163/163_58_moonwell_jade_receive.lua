-- Trigger: Moonwell Jade Receive
-- Zone: 163, ID: 58
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16358
--
-- Dryad receives the jade ring at stage 9. Sets the per-quest "map" flag so
-- handing over the bark map next (16359) advances the stage. The ring is
-- destroyed after being placed on the well perimeter.
if actor:get_quest_stage("moonwell_spell_quest") == 9 then
    actor:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(5)
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " along the circumference of the circle and utters a prayer.")
    wait(1)
    self.room:send(tostring(object.shortdesc) .. " dissipates into a circle of undulating soft blue-green light.")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Good.  Please give me your map so I may update it.'")
    self:destroy_item("ring")
end