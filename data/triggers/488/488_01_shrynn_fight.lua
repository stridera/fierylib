-- Trigger: shrynn fight
-- Zone: 488, ID: 1
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48801

-- Converted from DG Script #48801: shrynn fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local mode = random(1, 10)
if mode < 7 then
    wait(2)
    if actor and (actor.room == self.room) and (actor.id == -1) then
        local max_tries = 5
        while max_tries > 0 do
            local victim = room.actors[random(1, #room.actors)]
            if (victim.id == -1) and (victim.name ~= actor.name) then
                local okay = 1
                local max_tries = 0
            end
            local max_tries = max_tries - 1
        end
        if not okay then
            return _return_value
        end
        local actor_damage = 310 + random(1, 100)
        if actor:has_effect(Effect.Sanctuary) then
            local actor_damage = actor_damage / 2
        end
        local victim_damage = 150 + random(1, 100)
        if victim:has_effect(Effect.Sanctuary) then
            local victim_damage = victim_damage / 2
        end
        actor:send(tostring(self.name) .. " sucks you into his vortex, spinning you around in a blur!")
        self.room:send_except(actor, tostring(self.name) .. " sucks " .. tostring(actor.name) .. " into a vortex, spinning " .. tostring(actor.object) .. " around vigorously!")
        local damage_dealt = actor:damage(actor_damage)  -- type: crush
        local actor_damage = damage_dealt
        local damage_dealt = victim:damage(victim_damage)  -- type: crush
        local victim_damage = damage_dealt
        actor:send("The vortex spits you out and flings you into headlong into " .. tostring(victim.name) .. "! (<b:red>" .. tostring(actor_damage) .. "</>) (<blue>" .. tostring(victim_damage) .. "</>)")
        victim:send("The vortex flings " .. tostring(actor.name) .. " into you! (<b:red>" .. tostring(victim_damage) .. "</>) (<blue>" .. tostring(actor_damage) .. "</>)")
        victim:teleport(get_room(11, 0))
        self.room:send_except(actor, "The vortex flings " .. tostring(actor.name) .. " out, and right into " .. tostring(victim.name) .. "! (<blue>" .. tostring(actor_damage) .. "</>) (<blue>" .. tostring(victim_damage) .. "</>)")
        actor:teleport(get_room(11, 0))
        -- Teleport back and forth to break combat
        actor:teleport(get_room(self.room.zone_id, self.room.local_id))
        victim:teleport(get_room(self.room.zone_id, self.room.local_id))
    end
else
    wait(2)
    if actor and (actor.room == self.room) and (actor.id == -1) then
        local damage = 120 + random(1, 100)
        if actor:has_effect(Effect.Sanctuary) then
            local damage = damage / 2
        end
        local damage_dealt = actor:damage(damage)  -- type: crush
        actor:send("<cyan>" .. tostring(self.name) .. " throws a tremendous burst of wind at you, throwing you from the area!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, "<cyan>" .. tostring(self.name) .. " throws a tremendous burst of wind at " .. tostring(actor.name) .. ", throwing " .. tostring(actor.object) .. " from the area!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
        if actor and (actor.room == self.room) then
            actor:teleport(get_room(488, random(1, 29) + 1))
            -- actor looks around
        end
    end
end