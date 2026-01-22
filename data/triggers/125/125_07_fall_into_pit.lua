-- Trigger: Fall_into_pit
-- Zone: 125, ID: 7
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #12507

-- Converted from DG Script #12507: Fall_into_pit
-- Original: WORLD trigger, flags: PREENTRY, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
-- (placeholder trigger)