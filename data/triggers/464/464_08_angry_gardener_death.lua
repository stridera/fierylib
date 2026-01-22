-- Trigger: angry_gardener_death
-- Zone: 464, ID: 8
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #46408

-- Converted from DG Script #46408: angry_gardener_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:send(tostring(self.name) .. " shouts, 'Noooooooo!   I WILL be avenged!  " .. tostring(actor.name) .. ", you wretch!'")