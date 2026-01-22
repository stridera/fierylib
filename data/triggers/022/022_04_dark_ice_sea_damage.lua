-- Trigger: Dark_ice_sea_damage
-- Zone: 22, ID: 4
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #2204

-- Converted from DG Script #2204: Dark_ice_sea_damage
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
local count = self.actor_count
if count > 3 then
    local count = 3
end
while count > 0 do
    local victim = room.actors[random(1, #room.actors)]
    if victim.id ~= 2215 then
        local damage = 20 + random(1, 15)
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            -- Less damage for flying people
            if not (victim:has_effect(Effect.Flying)) then
                local damage = damage * 3
            end
            local damage_dealt = victim:damage(damage)  -- type: slash
            victim:send("A sharp-edged iceberg suddenly comes rushing out of the water and into you! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, "A twisted iceberg suddely rushes out of the water, striking " .. tostring(victim.name) .. "! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        else
            -- More damage for people with stoneskin
            if not (victim:has_effect(Effect.Stone)) then
                local damage = damage * 3
                local damage_dealt = victim:damage(damage)  -- type: cold
                victim:send("Ice begins to form around your stony skin, dragging you downwards! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(victim, "Frost starts forming all over the skin of " .. tostring(victim.name) .. ", freezing " .. tostring(victim.possessive) .. " joints! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
            else
                local damage = damage * 2
                local damage_dealt = victim:damage(damage)  -- type: cold
                victim:send("The dark waters around you begin to chill your bones. (<b:red>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(victim, tostring(victim.name) .. " grows a little blue and begins to shiver. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
            end
        end
    end
    local count = count - 1
    wait(3)
end