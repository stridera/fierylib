-- Trigger: undefined
-- Zone: 625, ID: 49
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #62549

-- Converted from DG Script #62549: undefined
-- Original: MOB trigger, flags: DEATH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end
return _return_value