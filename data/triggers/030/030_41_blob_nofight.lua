-- Trigger: blob_nofight
-- Zone: 30, ID: 41
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #3041

-- Converted from DG Script #3041: blob_nofight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local room = self.room
self:emote("seems to disintegrate, melting into the ground.")
self:teleport(get_room(11, 0))
wait(5)
self:teleport(room)
self.room:send("Green gelatin suddenly bubbles out of the ground, wriggling into a blob.")