-- Trigger: vines
-- Zone: 0, ID: 94
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #94

-- Converted from DG Script #94: vines
-- Original: WORLD trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self.room:send("A vine nips at your heels!")