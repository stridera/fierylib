-- Trigger: EnterDemonessRoom
-- Zone: 125, ID: 21
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #12521

-- Converted from DG Script #12521: EnterDemonessRoom
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
self:command("glare " .. tostring(actor.name))
wait(1)
self.room:send(tostring(self.name) .. " says, 'The master will be displeased...  He would want me to kill")
self.room:send("</>you.'")