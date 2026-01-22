-- Trigger: stormlord fight
-- Zone: 488, ID: 9
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48809

-- Converted from DG Script #48809: stormlord fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local mode = random(1, 10)
if mode < 5 then
    wait(1)
    self.room:send("<cyan>Hurricane-force winds suddenly howl, throwing around lightning bolts!</>")
    wait(1)
    self.room:send("<blue>A massive lightning bolt strikes " .. tostring(self.name) .. " in the chest, causing " .. tostring(self.possessive) .. " eyes to glow!</>")
    self.room:find_actor("stormlord"):heal(1000)
elseif mode < 8 then
    wait(2)
    self:emote("lets out a thundering howl, causing the air around to vibrate.")
    local max_hits = 5
    while max_hits > 0 do
        local victim = room.actors[random(1, #room.actors)]
        if (victim.id == -1) and not (victim_list and string.find(victim_list, victim.name)) then
            local damage = 150 + random(1, 50)
            if victim:has_effect(Effect.Sanctuary) then
                local damage = damage / 2
            end
            if victim:has_effect(Effect.Stone) then
                -- More damage for stoneskin
                local damage = damage + 80
                local damage_dealt = victim:damage(damage)  -- type: physical
                self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. "'s stone-like skin grows massive cracks as the thunder rolls into " .. tostring(victim.object) .. "!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                victim:send("<yellow>The thundering howl shatters your stone-like skin, causing immense pain!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            else
                local damage_dealt = victim:damage(damage)  -- type: crush
                if damage_dealt == 0 then
                    self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. " holds " .. tostring(victim.possessive) .. " ground.</>")
                    victim:send("<yellow>You hold your ground.</>")
                else
                    self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. " holds " .. tostring(victim.possessive) .. " head and cries out in pain!</> (<blue>" .. tostring(damage) .. "</>)")
                    victim:send("<yellow>Pain breaks out in your head as the thunder pounds your ears!</> (<b:red>" .. tostring(damage) .. "</>)")
                end
            end
            victim_list = (victim_list or "") .. " " .. victim.name
        end
        local max_hits = max_hits - 1
    end
else
    wait(1)
    self.room:send("<blue>Lightning begins to crackle around " .. tostring(self.name) .. "'s right arm.</>")
    wait(1)
    if actor and (actor.room == self.room) and (actor.id == -1) then
        self.room:send("<blue>The glowing lightning flows into " .. tostring(self.name) .. "'s index finger.</>")
        self.room:send_except(actor, tostring(self.name) .. " points " .. tostring(self.possessive) .. " finger at " .. tostring(actor.name) .. ".")
        actor:send(tostring(self.name) .. " points " .. tostring(self.possessive) .. " finger at you.")
        local damage = 350 + random(1, 100)
        if actor:has_effect(Effect.Sanctuary) then
            local damage = damage / 2
        end
        local damage_dealt = actor:damage(damage)  -- type: shock
        if damage_dealt == 0 then
            actor:send("A blast of lighting strikes you, lighting you up!")
            self.room:send_except(actor, "A blast of lighting strikes " .. tostring(actor.name) .. ", lighting " .. tostring(actor.object) .. " up!")
        else
            self.room:send_except(actor, "A tremendous blast of lightning strikes " .. tostring(actor.name) .. ", burning " .. tostring(actor.possessive) .. " skin! (<blue>" .. tostring(damage_dealt) .. "</>)")
            actor:send("A tremendous blast of lightning strikes you, tearing at your flesh! (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
    end
end