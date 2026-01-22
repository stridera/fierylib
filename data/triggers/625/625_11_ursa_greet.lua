-- Trigger: ursa greet
-- Zone: 625, ID: 11
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #62511

-- Converted from DG Script #62511: ursa greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 then
    if actor.level < 100 then
        self:command("stand")
        self:command("roar")
        self:attack_all()
        actor:send(tostring(self.name) .. " snarls at you.")
        self.room:send_except(actor, tostring(self.name) .. " snarls at " .. tostring(actor.name) .. ".")
    end
end