-- Trigger: Coup
-- Zone: 18, ID: 20
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1820

-- Converted from DG Script #1820: Coup
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- Find and damage any nymph mobs (id 1808) in the room
for _, prsn in ipairs(self.room.actors) do
    if prsn.id == 1808 then
        self.room:send("King Thelmor delivers a final coup de grace, killing the nymph!")
        prsn:damage(10000)  -- type: physical
    end
end