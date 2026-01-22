-- Trigger: crystalline monument (griffin)
-- Zone: 0, ID: 97
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #97

-- Converted from DG Script #97: crystalline monument (griffin)
-- Original: OBJECT trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self.room:send("The crystalline monument begins to glow and hum, then stops abruptly.")