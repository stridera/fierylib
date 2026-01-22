-- Trigger: break_burning_branch
-- Zone: 520, ID: 2
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #52002

-- Converted from DG Script #52002: break_burning_branch
-- Original: OBJECT trigger, flags: DROP, probability: 100%
wait(1)
self.room:send("The branch cracks and breaks into 3 pieces!")
self.room:spawn_object(520, 35)
self.room:spawn_object(520, 35)
self.room:spawn_object(520, 35)
world.destroy(self.room:find_object("burning-branch"))