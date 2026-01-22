-- Trigger: Disc_Toss
-- Zone: 22, ID: 61
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #2261

-- Converted from DG Script #2261: Disc_Toss
-- Original: OBJECT trigger, flags: GET, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end
-- (placeholder trigger)