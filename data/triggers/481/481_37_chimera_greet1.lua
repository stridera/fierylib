-- Trigger: chimera_greet1
-- Zone: 481, ID: 37
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48137

-- Converted from DG Script #48137: chimera_greet1
-- Original: MOB trigger, flags: GREET, probability: 100%
-- 
-- Added by Acerite oct 2004
-- 
-- Check for moonwell quest
-- 
if actor:get_quest_stage("moonwell_spell_quest") == 1 then
    self:destroy_item("vine")
    self.room:spawn_object(163, 50)
end
self:emote("turns its dragon head to examine you.")
self:command("consider " .. tostring(actor.name))
if actor.level < 30 then
    spells.cast(self, "dispel magic", actor.name)
else
    spells.cast(self, "ray of enf", actor.name)
end