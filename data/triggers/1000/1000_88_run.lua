-- Trigger: run
-- Zone: 0, ID: 88
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #88

-- Converted from DG Script #88: run
-- Original: WORLD trigger, flags: RANDOM, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
self.room:send("The wind howls around the Cathedral.")
self.room:send("The wind seems to whisper run....run!")