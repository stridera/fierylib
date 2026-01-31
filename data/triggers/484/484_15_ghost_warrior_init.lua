-- Trigger: ghost warrior init
-- Zone: 484, ID: 15
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #48415

-- Converted from DG Script #48415: ghost warrior init
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- Teleport to another room so that other undead-captains
-- don't get in the way.
local room = self.room
local staging_room = get_room(11, 0)
if not staging_room then return end

self:teleport(staging_room)

-- Spawn ghost warriors and have them follow the captain
local warrior1 = self.room:spawn_mobile(484, 4)
if warrior1 then
    warrior1:follow(self)
    warrior1:teleport(room)
end

local warrior2 = self.room:spawn_mobile(484, 4)
if warrior2 then
    warrior2:follow(self)
    warrior2:teleport(room)
end

local warrior3 = self.room:spawn_mobile(484, 4)
if warrior3 then
    warrior3:follow(self)
    warrior3:teleport(room)
end

self:teleport(room)