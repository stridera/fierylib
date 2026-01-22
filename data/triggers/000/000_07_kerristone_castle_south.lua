-- Trigger: Kerristone Castle (South)
-- Zone: 0, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #7

-- Converted from DG Script #7: Kerristone Castle (South)
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 14750 then
    wait(5)
    self:say("Good!")
else
    wait(5)
    self:say("bad!")
end