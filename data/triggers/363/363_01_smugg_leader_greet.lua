-- Trigger: Smugg_leader_greet
-- Zone: 363, ID: 1
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #36301

-- Converted from DG Script #36301: Smugg_leader_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- This is to engage anyone walking in
actor:send(tostring(self.name) .. " looks around quickly.")
if actor.level > 99 then
    self:say("Hehe, I _am_ honoured to have such a visitor")
    self:command("bow")
else
    actor:send(tostring(self.name) .. " stares at you in disbelief.")
    self.room:send_except(actor, tostring(self.name) .. " stares at " .. tostring(actor.name) .. " in disbelief.")
    self:say("What the HELL do you think you are DOING!?")
    self:say("You just made the last mistake of your miserable existence!")
    combat.engage(self, actor.name)
end