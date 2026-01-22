-- Trigger: nick_why
-- Zone: 43, ID: 15
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4315

-- Converted from DG Script #4315: nick_why
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self.room:send(tostring(self.name) .. " says, 'Oh if only you could see it the way I do, you would understand")
self.room:send("</>that of COURSE I'm right.'")
wait(4)
self:emote("fumes with rage!")
wait(5)
self:say("Why do I always let guys do this to me?!")