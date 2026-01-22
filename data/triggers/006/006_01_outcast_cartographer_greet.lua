-- Trigger: outcast cartographer greet
-- Zone: 6, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #601

-- Converted from DG Script #601: outcast cartographer greet
-- Original: MOB trigger, flags: GREET, probability: 100%
self.room:send(tostring(self.name) .. " shouts, 'Quickly now, tell me what you want and get out!'")