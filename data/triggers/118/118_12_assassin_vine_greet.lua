-- Trigger: assassin_vine_greet
-- Zone: 118, ID: 12
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #11812

-- Converted from DG Script #11812: assassin_vine_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    self:emote("lunches toward " .. tostring(actor.name) .. ".")
    skills.execute(self, "backstab", actor.name)
end