-- Trigger: Demise_dying_knight_rand2
-- Zone: 430, ID: 7
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #43007

-- Converted from DG Script #43007: Demise_dying_knight_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 22%

-- 22% chance to trigger
if not percent_chance(22) then
    return true
end
self:command("groan")
self.room:send(tostring(self.name) .. " says softly 'help me....'")
self.room:send(tostring(self.name) .. " tries to pull himself off the trail onto a stump so as not to drown in his own blood.")