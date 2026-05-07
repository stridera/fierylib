-- Trigger: Kerristone Castle (South)
-- Zone: 0, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #7
-- Receive trigger: praises the giver if the gift is the right item.

if object.zone_id == 147 and object.local_id == 50 then
    wait(5)
    self:say("Good!")
else
    wait(5)
    self:say("bad!")
end
