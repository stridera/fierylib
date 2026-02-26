-- Trigger: antipaladin quest
-- Zone: 0, ID: 87
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #87

-- Converted from DG Script #87: antipaladin quest
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 8504 then
    wait(5)
    self:emote("throws his head back in childish delight!")
else
    wait(5)
    self:say("You are a miserable failure!")
end  -- auto-close block