-- Trigger: Angel_Room
-- Zone: 521, ID: 5
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #52105

-- Converted from DG Script #52105: Angel_Room
-- Original: MOB trigger, flags: RANDOM, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end
self.room:send("A warmth feels the room.")