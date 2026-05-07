-- Trigger: shrynn fight
-- Zone: 488, ID: 1
-- Type: MOB, Flags: FIGHT
-- Status: REVIEWED
--
-- Original DG Script: #48801
--
-- Behavior: Each round (100% prob), Shrynn either:
--   - 60% chance: vortex attack — picks a different player from the room and
--     slams the actor into them, dealing crush damage to both. Brief teleport
--     bounce off room 11/0 (Limbo) to break combat positioning.
--   - 40% chance: gale attack — blasts a single actor for crush damage and
--     teleports them to a random sibling room within the zone.
local mode = random(1, 10)
if mode < 7 then
    wait(2)
    if actor and (actor.room == self.room) and actor.is_player then
        -- Pick a random other player in the room as the secondary victim.
        local victim = nil
        local max_tries = 5
        while max_tries > 0 do
            local candidate = room.actors[random(1, #room.actors)]
            if candidate and candidate.is_player and (candidate.name ~= actor.name) then
                victim = candidate
                break
            end
            max_tries = max_tries - 1
        end
        if not victim then
            return true
        end
        local actor_damage = 310 + random(1, 100)
        if actor:has_effect(Effect.Sanctuary) then
            actor_damage = actor_damage / 2
        end
        local victim_damage = 150 + random(1, 100)
        if victim:has_effect(Effect.Sanctuary) then
            victim_damage = victim_damage / 2
        end
        actor:send(tostring(self.name) .. " sucks you into his vortex, spinning you around in a blur!")
        self.room:send_except(actor, tostring(self.name) .. " sucks " .. tostring(actor.name) .. " into a vortex, spinning " .. tostring(actor.object) .. " around vigorously!")
        actor_damage = actor:damage(actor_damage)  -- type: crush
        victim_damage = victim:damage(victim_damage)  -- type: crush
        actor:send("The vortex spits you out and flings you into headlong into " .. tostring(victim.name) .. "! (<b:red>" .. tostring(actor_damage) .. "</>) (<blue>" .. tostring(victim_damage) .. "</>)")
        victim:send("The vortex flings " .. tostring(actor.name) .. " into you! (<b:red>" .. tostring(victim_damage) .. "</>) (<blue>" .. tostring(actor_damage) .. "</>)")
        victim:teleport(get_room(11, 0))
        self.room:send_except(actor, "The vortex flings " .. tostring(actor.name) .. " out, and right into " .. tostring(victim.name) .. "! (<blue>" .. tostring(actor_damage) .. "</>) (<blue>" .. tostring(victim_damage) .. "</>)")
        actor:teleport(get_room(11, 0))
        -- Teleport back and forth to break combat
        actor:teleport(self.room)
        victim:teleport(self.room)
    end
else
    wait(2)
    if actor and (actor.room == self.room) and actor.is_player then
        local damage = 120 + random(1, 100)
        if actor:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        local damage_dealt = actor:damage(damage)  -- type: crush
        actor:send("<cyan>" .. tostring(self.name) .. " throws a tremendous burst of wind at you, throwing you from the area!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        self.room:send_except(actor, "<cyan>" .. tostring(self.name) .. " throws a tremendous burst of wind at " .. tostring(actor.name) .. ", throwing " .. tostring(actor.object) .. " from the area!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
        if actor and (actor.room == self.room) then
            actor:teleport(get_room(488, 1 + random(1, 29)))
            -- actor looks around
        end
    end
end
