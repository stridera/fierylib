-- Trigger: Demise_dying_knight_rand3
-- Zone: 430, ID: 8
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #43008

-- Converted from DG Script #43008: Demise_dying_knight_rand3
-- Original: MOB trigger, flags: RANDOM, probability: 18%

-- 18% chance to trigger
if not percent_chance(18) then
    return true
end
self:command("cough")
self.room:send(tostring(self.name) .. " spews blood and bile from his gaping wounds.")
self.room:send(tostring(self.name) .. " rolls over and stares blankly at the sky...")