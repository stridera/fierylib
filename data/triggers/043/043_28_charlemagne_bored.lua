-- Trigger: charlemagne_bored
-- Zone: 43, ID: 28
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #4328

-- Converted from DG Script #4328: charlemagne_bored
-- Original: MOB trigger, flags: RANDOM, probability: 10%

-- 10% chance to trigger
if not percent_chance(10) then
    return true
end
self:command("shake")
self:say("So little and so few to do...")
wait(3)
self.room:send(tostring(self.name) .. " says, 'What is such a giant on the battlefield and in the bedroom")
self.room:send("</>to do?'")