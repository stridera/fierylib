-- Trigger: UNUSED
-- Zone: 490, ID: 46
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #49046

-- Converted from DG Script #49046: UNUSED
-- Original: MOB trigger, flags: FIGHT, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
self:command("circle")