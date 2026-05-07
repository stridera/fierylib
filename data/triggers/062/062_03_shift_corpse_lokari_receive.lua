-- Trigger: shift_corpse_lokari_receive
-- Zone: 62, ID: 3
-- Type: MOB, Flags: RECEIVE
--
-- Lokari (the moonless-night god) accepts the glowing black crystal (62, 28)
-- from a player on stage 1 of the shift_corpse quest, advances the quest, and
-- becomes hostile.
--
-- Original DG Script: #6203

if object.zone_id == 62 and object.local_id == 28 and actor:get_quest_stage("shift_corpse") == 1 then
    actor:advance_quest("shift_corpse")
    self.room:send(tostring(objects.template(62, 28).name) .. " flares with <blue>&9darkness visible!</>")
    wait(1)
    self.room:send("<blue>&9" .. tostring(self.name) .. "</> <red>ROARS</> <blue>&9with divine fury!</>")
    self:say("You will never destroy me!!")
    combat.engage(actor)
end
return true