-- Trigger: reload_helpers_2
-- Zone: 533, ID: 4
-- Type: MOB, Flags: HIT_PERCENT
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #53304
--
-- 10% per-tick chance to flavor-emote concern about losing children.
-- TODO: Original DG Script likely intended further logic (the orphaned
-- 'loaded' counter and 'globals.loaded' flag in the converted output
-- suggest a missing branch). Currently this trigger only emotes.

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("looks worried and tries to find some more children.")
