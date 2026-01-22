-- Trigger: angry-gardener_greet
-- Zone: 464, ID: 10
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #46410

-- Converted from DG Script #46410: angry-gardener_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
actor:send(tostring(self.name) .. " peers at you intently.")
wait(1)
actor:send(tostring(self.name) .. " tells you, 'Was it you?  Did you kill my friends?'")