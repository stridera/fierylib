-- Trigger: earth elemental init
-- Zone: 484, ID: 14
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #48414

-- Converted from DG Script #48414: earth elemental init
-- Original: MOB trigger, flags: LOAD, probability: 100%
-- Wait for mob to be placed in its room after load
wait(1)
-- Teleport to another room so that other earth-elemental-leaders
-- don't get in the way.
local room = self.room
if not room then return end
local scratch = get_room(11, 0)
self:teleport(scratch)
local follower1 = scratch:spawn_mobile(484, 0)
if follower1 then
    follower1:follow(self)
    follower1:teleport(room)
end
local follower2 = scratch:spawn_mobile(484, 0)
if follower2 then
    follower2:follow(self)
    follower2:teleport(room)
end
local follower3 = scratch:spawn_mobile(484, 0)
if follower3 then
    follower3:follow(self)
    follower3:teleport(room)
end
self:teleport(room)