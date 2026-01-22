-- Trigger: Moonwell Granite Receive
-- Zone: 163, ID: 62
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16362

-- Converted from DG Script #16362: Moonwell Granite Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("moonwell_spell_quest") == 11 then
    wait(2)
    self:destroy_item("ring")
    actor.name:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(15)
    actor:send(tostring(self.name) .. " tells you, 'Excellent, hand me your map so that I may finish this.'")
end