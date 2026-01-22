-- Trigger: blue dragon fight
-- Zone: 488, ID: 5
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48805

-- Converted from DG Script #48805: blue dragon fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
wait(2)
local mode = random(1, 10)
if mode <= 1 then
    self:breath_attack("lightning", nil)
elseif mode <= 2 then
    self:command("sweep")
elseif mode <= 4 then
    self:command("roar")
elseif (mode <= 5) and actor and (actor.room == self.room) and (actor.id == -1) then
    local damage = 290 + random(1, 50)
    if actor:has_effect(Effect.Sanctuary) then
        local damage = damage / 2
    end
    if actor:has_effect(Effect.Stone) then
        local damage = damage / 2
    end
    local damage_dealt = actor:damage(damage)  -- type: shock
    self.room:send("<b:blue>Lightning crackles across the scales of " .. tostring(self.name) .. "!</>")
    if damage_dealt == 0 then
        actor:send("<blue>A blast of lightning flows off one of the dragon's claws and harmlessly into you!</>")
        self.room:send_except(actor, "<blue>A blast of lightning flows off one of the dragon's claws and harmlessly into " .. tostring(actor.name) .. "!</>")
    else
        actor:send("<blue>A blast of lightning flows off one of the dragon's claws and into your body!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, "<blue>A blast of lightning flows off one of the dragon's claws and into " .. tostring(actor.name) .. "'s body!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
    end
end