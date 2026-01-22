-- Trigger: chimera_death
-- Zone: 481, ID: 2
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #48102

-- Converted from DG Script #48102: chimera_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
self.room:spawn_object(481, 22)
self.room:spawn_object(481, 28)
self.room:spawn_object(481, 29)
self.room:send_except(actor, tostring(self.name) .. " lets out an arduous cry as " .. tostring(actor.name) .. "'s attack lops its heads off!")
actor:send(tostring(self.name) .. " lets out a cry as your attack rends its heads from its body.")