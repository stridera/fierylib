-- Trigger: pippin_fulfillment
-- Zone: 43, ID: 44
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4344

-- Converted from DG Script #4344: pippin_fulfillment
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:say("Ultimate fulfillment...")
wait(1)
self.room:send("Pippin's eyes gleam with determination.")
wait(1)
self:say("And I'm going to find it!")