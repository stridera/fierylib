-- Trigger: cloud dragon fight
-- Zone: 488, ID: 7
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48807

-- Converted from DG Script #48807: cloud dragon fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local mode = random(1, 10)
if mode <= 3 then
    wait(2)
    self:breath_attack("frost", nil)
elseif mode <= 6 then
    wait(2)
    self:command("sweep")
elseif mode <= 8 then
    wait(2)
    self:command("roar")
elseif actor and (actor.room == self.room) and (actor.id == -1) then
    wait(1)
    self.room:send(tostring(self.name) .. " suddenly breaks apart into <cyan>millions of droplets of moisture</>!")
    wait(1)
    if actor and (actor.room == self.room) then
        local damage = 350 + random(1, 50)
        if actor:has_effect(Effect.Sanctuary) then
            local damage = damage / 2
        end
        local damage_dealt = actor:damage(damage)  -- type: cold
        if damage_dealt == 0 then
            actor:send("<cyan>The cloud of droplets envelopes you, cooling you.</>")
            self.room:send_except(actor, "<cyan>" .. tostring(actor.name) .. " enjoys a nice misting from the cloud.</>")
        else
            actor:send("<cyan>The cloud of droplets envelopes you, draining your energy!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(actor, "<cyan>" .. tostring(actor.name) .. " gasps for breath as the cloud of droplets envelopes " .. tostring(actor.object) .. "!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
        end
        wait(1)
    end
    self.room:send("<cyan>The cloud of droplets coalesces back into the form of " .. tostring(self.name) .. ".</>")
end