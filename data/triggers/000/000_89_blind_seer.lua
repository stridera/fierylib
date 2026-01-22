-- Trigger: blind seer
-- Zone: 0, ID: 89
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #89

-- Converted from DG Script #89: blind seer
-- Original: MOB trigger, flags: ENTRY, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self:emote("grumbles some nonsense about his master.")