-- Trigger: amy_mean
-- Zone: 43, ID: 16
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4316

-- Converted from DG Script #4316: amy_mean
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("roll")
wait(3)
self.room:send(tostring(self.name) .. " says, 'God, my sister is so bossy.  I wish she would just shut her big")
self.room:send("</>fat mouth.  I can't stand her!'")
self:say("I can't stand her.")
wait(4)
self:emote("prattles on to no one in particular.")