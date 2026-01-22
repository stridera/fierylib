-- Trigger: Coup
-- Zone: 18, ID: 20
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1820

-- Converted from DG Script #1820: Coup
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local numpeople = people.1802
while numpeople >= 0 do
    if numpeople > 0 then
        local prsn = self.people[numpeople]
        if prsn.id == 1808 then
            self.room:send("King Thelmor delivers a final coup de grace, killing the nymph!")
            prsn:damage(10000)  -- type: physical
        end
    end
    local numpeople = numpeople -1
end