-- Trigger: pirate-entity_greet
-- Zone: 521, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #52101

-- Converted from DG Script #52101: pirate-entity_greet
-- Original: MOB trigger, flags: GREET, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
wait(1)
self.room:send("The shade mourns out, 'Help us! Free us from her!'")
wait(3)
self.room:send("The shade yells out, 'She is enternal evil! Beware!'")