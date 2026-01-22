-- Trigger: Mog Death Log
-- Zone: 22, ID: 33
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #2233

-- Converted from DG Script #2233: Mog Death Log
-- Original: MOB trigger, flags: DEATH, probability: 100%
trigger_log(tostring(actor.name) .. " has killed " .. tostring(self.name))