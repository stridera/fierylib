-- Trigger: lets do get help
-- Zone: 30, ID: 11
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #3011

-- Converted from DG Script #3011: lets do get help
-- Original: MOB trigger, flags: FIGHT, probability: 50%

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
self:command("roar")
wait(2)
self:emote("yells out for assistance from anyone that can help!")
wait(2)
self.room:spawn_mobile(30, 52)
self.room:send("A half-elven town guard arrives so quickly, you're not sure what direction he came from.")