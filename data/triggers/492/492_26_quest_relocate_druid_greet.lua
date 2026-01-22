-- Trigger: quest_relocate_druid_greet
-- Zone: 492, ID: 26
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #49226

-- Converted from DG Script #49226: quest_relocate_druid_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- Loads staff on entry into room
-- note that it purges the staff first to ensure only one loads
if actor:get_quest_stage("relocate_spell_quest") == 1 then
    self:destroy_item("mystics")
    wait(10)
    self:say("All this way and still I am found!")
    wait(5)
    self:command("scream")
    self:say("Fine, if you want this staff so badly, come and get it!")
    self.room:spawn_object(492, 50)
    self:command("hold staff")
end