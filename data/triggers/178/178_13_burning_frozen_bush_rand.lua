-- Trigger: burning_frozen_bush_rand
-- Zone: 178, ID: 13
-- Type: MOB, Flags: RANDOM, GREET
-- Status: CLEAN
--
-- Original DG Script: #17813

-- Converted from DG Script #17813: burning_frozen_bush_rand
-- Original: MOB trigger, flags: RANDOM, GREET, probability: 15%

-- 15% chance to trigger
if not percent_chance(15) then
    return true
end
self.room:send("Pitiful wails of pain scream from the burning part of the shrub.")
wait(2)
self:emote("moans as best as shrubs can moan.")