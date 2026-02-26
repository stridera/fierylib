-- Trigger: Druid spy moves once
-- Zone: 302, ID: 1
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #30201

-- Converted from DG Script #30201: Druid spy moves once
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- Teleports the druid spy to a random location, once. Because I want it to be
-- in different places, but it can't be a wanderer, because that would make it
-- lose its hidden status.
-- Applied to: m30214
local destination = 30213 + random(1, 35)
self:teleport(get_room(vnum_to_zone(destination), vnum_to_local(destination)))