-- Trigger: Moonwell Granite Receive
-- Zone: 163, ID: 62
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #16362
--
-- Dryad receives the granite ring (final element) at stage 11. Sets the
-- per-quest "map" flag so handing over the bark map next (16363) finishes
-- the ceremony. The ring is destroyed.
if actor:get_quest_stage("moonwell_spell_quest") == 11 then
    wait(2)
    self:destroy_item("ring")
    actor:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'Excellent, hand me your map so that I may finish this.'")
end