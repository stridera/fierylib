-- Trigger: phase_armor_refuse
-- Zone: 556, ID: 32
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55632

-- Converted from DG Script #55632: phase_armor_refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
actor:send(tostring(self.name) .. " tells you, 'Why are you handing me this stuff?  I don't want it!'")
actor:send(tostring(self.name) .. " refuses to accept " .. tostring(object.shortdesc) .. " from you.")
return true