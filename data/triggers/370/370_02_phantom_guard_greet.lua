-- Trigger: Phantom_guard_greet
-- Zone: 370, ID: 2
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #37002

-- Converted from DG Script #37002: Phantom_guard_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- This is a prog to greet players
if actor.id == -1 then
    actor:send(tostring(self.name) .. " says, 'This is no place for puny mortals, like yourself!'")
    actor:send(tostring(self.name) .. " says, 'Go home at once!'")
else
end