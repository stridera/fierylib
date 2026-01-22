-- Trigger: new trigger
-- Zone: 61, ID: 57
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #6157

-- Converted from DG Script #6157: new trigger
-- Original: MOB trigger, flags: GREET, probability: 7%

-- 7% chance to trigger
if not percent_chance(7) then
    return true
end
self:say("My trigger commandlist is not complete!")