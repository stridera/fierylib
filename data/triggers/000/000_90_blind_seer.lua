-- Trigger: blind seer
-- Zone: 0, ID: 90
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #90

-- Converted from DG Script #90: blind seer
-- Original: MOB trigger, flags: ENTRY, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self:emote("seems to be looking for someone.")