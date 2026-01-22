-- Trigger: fv_guard_entry
-- Zone: 534, ID: 11
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #53411

-- Converted from DG Script #53411: fv_guard_entry
-- Original: MOB trigger, flags: ENTRY, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:emote("peers around the room as if he expects to see an enemy in the shadows.")