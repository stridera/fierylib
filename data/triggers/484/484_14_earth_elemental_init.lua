-- Trigger: earth elemental init
-- Zone: 484, ID: 14
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #48414

-- Converted from DG Script #48414: earth elemental init
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- Teleport to another room so that other earth-elemental-leaders
-- don't get in the way.
local room = self.room
local staging_room = get_room(11, 0)
if not staging_room then return end

self:teleport(staging_room)

-- Spawn followers and have them follow the leader
local follower1 = self.room:spawn_mobile(484, 0)
if follower1 then
    follower1:follow(self)
    follower1:teleport(room)
end

local follower2 = self.room:spawn_mobile(484, 0)
if follower2 then
    follower2:follow(self)
    follower2:teleport(room)
end

local follower3 = self.room:spawn_mobile(484, 0)
if follower3 then
    follower3:follow(self)
    follower3:teleport(room)
end

self:teleport(room)