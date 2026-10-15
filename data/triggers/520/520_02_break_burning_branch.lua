-- Trigger: break_burning_branch
-- Zone: 520, ID: 2
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #52002

-- Converted from DG Script #52002: break_burning_branch
-- Original: OBJECT trigger, flags: DROP, probability: 100%
wait(0.1)
self.room:send("The branch cracks and breaks into 3 pieces!")
self.room:spawn_object(520, 35)
self.room:spawn_object(520, 35)
self.room:spawn_object(520, 35)
-- Legacy `opurge burning-branch` matches the script's own object by keyword wherever it is
-- (floor, bag, hand); find_object only sees the room floor, so a branch put in a bag survived
-- and the embers duplicated on every put/get.
world.destroy(self)