-- Trigger: Dark_ice_sea_damage
-- Zone: 22, ID: 4
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #2204

-- Converted from DG Script #2204: Dark_ice_sea_damage
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
-- self is the room in a WORLD trigger; self.room resolves to it.
local room = self.room
if room == nil then
    return true
end
local count = room.actor_count
if count > 3 then
    count = 3
end
while count > 0 do
    -- Everyone may have left (or died) during the wait: re-read the occupants each round
    local actors = room.actors
    if #actors == 0 then
        break
    end
    local victim = actors[random(1, #actors)]
    -- legacy vnum 2215: mob 15 in this zone is immune
    if not (victim.zone_id == 22 and victim.id == 15) then
        local damage = 20 + random(1, 15)
        local which = random(1, 2)
        -- switch on which
        if which == 1 then
            -- Less damage for flying people
            if not (victim:has_effect(Effect.Flying)) then
                damage = damage * 3
            end
            local damage_dealt = victim:damage(damage)  -- type: slash
            victim:send("A sharp-edged iceberg suddenly comes rushing out of the water and into you! (<b:red>" .. tostring(damage_dealt) .. "</>)")
            room:send_except(victim, "A twisted iceberg suddely rushes out of the water, striking " .. tostring(victim.name) .. "! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
        else
            -- More damage for people with stoneskin
            if not (victim:has_effect(Effect.Stone)) then
                damage = damage * 3
                local damage_dealt = victim:damage(damage)  -- type: cold
                victim:send("Ice begins to form around your stony skin, dragging you downwards! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                room:send_except(victim, "Frost starts forming all over the skin of " .. tostring(victim.name) .. ", freezing " .. tostring(victim.possessive) .. " joints! (<b:blue>" .. tostring(damage_dealt) .. "</>)")
            else
                damage = damage * 2
                local damage_dealt = victim:damage(damage)  -- type: cold
                victim:send("The dark waters around you begin to chill your bones. (<b:red>" .. tostring(damage_dealt) .. "</>)")
                room:send_except(victim, tostring(victim.name) .. " grows a little blue and begins to shiver. (<b:blue>" .. tostring(damage_dealt) .. "</>)")
            end
        end
    end
    count = count - 1
    wait(3)
end