-- Trigger: wolf pack
-- Zone: 533, ID: 7
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
-- Fixed: Converted %room% to use proper room variable
--
-- Original DG Script: #53307

-- Converted from DG Script #53307: wolf pack
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- "2.wolf" in DG Script refers to self (the pack leader)
local room = self.room
local staging_room = get_room(11, 0)
if not staging_room then return end

self:teleport(staging_room)

-- Spawn wolves and have them follow the pack leader
local wolf1 = self.room:spawn_mobile(533, 15)
if wolf1 then
    wolf1:follow(self)
    wolf1:teleport(room)
end

local wolf2 = self.room:spawn_mobile(533, 15)
if wolf2 then
    wolf2:follow(self)
    wolf2:teleport(room)
end

local wolf3 = self.room:spawn_mobile(533, 15)
if wolf3 then
    wolf3:follow(self)
    wolf3:teleport(room)
end

self:teleport(room)