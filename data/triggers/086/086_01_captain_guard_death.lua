-- Trigger: captain_guard_death
-- Zone: 86, ID: 1
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #8601

-- Converted from DG Script #8601: captain_guard_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO: verify self:destroy_item API exists; original DG was likely `%purge% key` to remove key from inventory on death
self:destroy_item("key")