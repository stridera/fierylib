-- Trigger: kristi_nail
-- Zone: 43, ID: 23
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4323

-- Converted from DG Script #4323: kristi_nail
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("dramatically throws one hand to her brow.")
self.room:send(tostring(self.name) .. " says, 'Oh!  Oh!  The world is so miserable!  My hand is nailed to my")
self.room:send("</>forehead!'")
wait(5)
self:emote("sighs with the weight of a thousand elephants.")