-- Trigger: antipaladin quest
-- Zone: 0, ID: 87
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #87
-- Antipaladin quest hand-in: delight at the right offering, scorn otherwise.

if object.zone_id == 85 and object.local_id == 4 then
    wait(5)
    self:emote("throws his head back in childish delight!")
else
    wait(5)
    self:say("You are a miserable failure!")
end
