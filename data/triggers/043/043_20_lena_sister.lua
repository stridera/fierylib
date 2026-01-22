-- Trigger: lena_sister
-- Zone: 43, ID: 20
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4320

-- Converted from DG Script #4320: lena_sister
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("scream")
wait(2)
self.room:send(tostring(self.name) .. " says, 'My sister is so MEAN to me!  I wish someone would just KILL")
self.room:send("</>her!'")