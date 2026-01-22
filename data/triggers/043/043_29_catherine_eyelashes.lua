-- Trigger: catherine_eyelashes
-- Zone: 43, ID: 29
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4329

-- Converted from DG Script #4329: catherine_eyelashes
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
self:emote("frantically searches for something.")
wait(4)
self:say("Oh damn it, where is it?!")
wait(4)
self:command("fume")
wait(3)
self.room:send(tostring(self.name) .. " says, 'I bet those stupid monkeys ran off with my key...  That's why")
self.room:send("</>I can't find it.'")