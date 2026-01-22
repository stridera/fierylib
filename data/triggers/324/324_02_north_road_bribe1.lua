-- Trigger: North_Road_bribe1
-- Zone: 324, ID: 2
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #32402

-- Converted from DG Script #32402: North_Road_bribe1
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
self:say("My trigger commandlist is not complete!")