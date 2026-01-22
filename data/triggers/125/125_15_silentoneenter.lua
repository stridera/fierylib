-- Trigger: SilentOneEnter
-- Zone: 125, ID: 15
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #12515

-- Converted from DG Script #12515: SilentOneEnter
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
actor.name:send(tostring(self.name) .. " looks at you pleadingly.")