-- Trigger: tri-asp_load
-- Zone: 163, ID: 45
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #16345

-- Converted from DG Script #16345: tri-asp_load
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor:get_quest_stage("moonwell_spell_quest") ==4 then
    self:destroy_item("flask")
    self.room:spawn_object(163, 56)
end