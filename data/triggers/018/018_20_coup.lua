-- Trigger: Coup
-- Zone: 18, ID: 20
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #1820

-- Converted from DG Script #1820: Coup
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- Iterate occupants of room (18,2); when the fallen nymph (mob 18/8) is present,
-- King Thelmor delivers the killing blow.
local target_room = get_room(18, 2)
if target_room then
    for _, prsn in ipairs(target_room.actors) do
        if prsn.zone_id == 18 and prsn.local_id == 8 then
            target_room:send("King Thelmor delivers a final coup de grace, killing the nymph!")
            prsn:damage(10000)  -- type: physical
        end
    end
end