-- Trigger: Kerristone_north_trainer_rand2
-- Zone: 324, ID: 11
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #32411

-- Converted from DG Script #32411: Kerristone_north_trainer_rand2
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
-- Hrmmm
wait(1)
self:say("Fine horses! Why walk?")
self:command("smile")
wait(1)
self:say("You can use one of my fine horses and enjoy the trip!")
self.room:send(tostring(self.name) .. " says, 'Only 30 <b:yellow>gold</> pieces to get to Morgan Hill!'")
self.room:send(tostring(self.name) .. " says, '</></>Twelve</> more and you can go all the way to the <b:cyan></><blue>&9Rugged</> Moutains!</>'")
self:command("ponder")