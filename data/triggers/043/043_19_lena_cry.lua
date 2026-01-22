-- Trigger: lena_cry
-- Zone: 43, ID: 19
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4319

-- Converted from DG Script #4319: lena_cry
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:emote("screams, 'It's just not fair!'")
wait(5)
self:emote("sobs hysterically.")
wait(3)
self.room:send(tostring(self.name) .. " says, 'No one appreciates what I do here!  I never get recognized for")
self.room:send("</>ANYTHING!!'")