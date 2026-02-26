-- Trigger: Nukreth Spire beastmaster load
-- Zone: 462, ID: 31
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #46231

-- Converted from DG Script #46231: Nukreth Spire beastmaster load
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- Wait for mob to be placed in its room after load
wait(1)
local room = self.room
if not room then return end
local scratch = get_room(11, 0)
self:teleport(scratch)
local follower1 = scratch:spawn_mobile(462, 13)
if follower1 then
    follower1:follow(self)
    follower1:teleport(room)
end
local follower2 = scratch:spawn_mobile(462, 13)
if follower2 then
    follower2:follow(self)
    follower2:teleport(room)
end
local follower3 = scratch:spawn_mobile(462, 15)
if follower3 then
    follower3:follow(self)
    follower3:teleport(room)
end
self:teleport(room)