-- Trigger: reload_helpers_2
-- Zone: 533, ID: 4
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #53304

-- Converted from DG Script #53304: reload_helpers_2
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("looks worried and tries to find some more children.")
local loaded = 0
globals.loaded = globals.loaded or true