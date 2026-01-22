-- Trigger: ghost warrior greet
-- Zone: 484, ID: 7
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48407

-- Converted from DG Script #48407: ghost warrior greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    wait(1)
    self.room:send("The warrior murmurs some words...")
    wait(2)
    self.room:send("The words reach your ears as he attacks, 'Flee!  Flee! I beg you...'")
end